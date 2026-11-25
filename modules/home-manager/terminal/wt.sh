# wt — git worktrees paired with tmux windows, one coding agent per worktree.
#
# A worktree lives at <repo>__worktrees/<handle> and owns a tmux window named
# wt-<handle> in the session named after the repository. The agent running
# there reports working / waiting / done through the window's @agent-status
# option, set by the Claude Code hooks in ~/.config/claude/settings.json; that
# option is what `wt status` and `wt wait` read.
set -euo pipefail

agent_default=${WT_AGENT:-claude}
window_prefix=wt-

die() {
  printf 'wt: %s\n' "$1" >&2
  exit "${2:-1}"
}

# The common dir is the main worktree's .git for every linked worktree too, so
# this resolves to the same repository root from anywhere inside it.
main_root() {
  local common
  common=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) ||
    die "not a git repository"
  dirname "$common"
}

session_name() { basename "$(main_root)"; }
worktree_root() { printf '%s__worktrees' "$(main_root)"; }
handle_path() { printf '%s/%s' "$(worktree_root)" "$1"; }

# Window id for a handle, empty when the handle has no window. Searched across
# every session, so agents in other projects resolve too.
window_id() {
  tmux list-windows -a -F '#{window_name} #{window_id}' 2>/dev/null |
    awk -v name="$window_prefix$1" '$1 == name { print $2; exit }'
}

require_window() {
  local id
  id=$(window_id "$1")
  [ -n "$id" ] || die "no agent window for '$1'" 5
  printf '%s' "$id"
}

agent_pane() { tmux list-panes -t "$1" -F '#{pane_id}' | head -n1; }

status_of() {
  local status
  status=$(tmux show-options -wqv -t "$1" @agent-status 2>/dev/null || true)
  printf '%s' "${status:-unknown}"
}

handle_of_cwd() {
  local root top
  root=$(worktree_root)
  top=$(git rev-parse --show-toplevel)
  case "$top" in
  "$root"/*) basename "$top" ;;
  *) die "not inside a worktree managed by wt" ;;
  esac
}

cmd_add() {
  local handle="" base="" prompt_file="" prompt="" background=0 agent=$agent_default session=""
  while [ $# -gt 0 ]; do
    case "$1" in
    -b | --background) background=1 ;;
    -P | --prompt-file)
      prompt_file=$2
      shift
      ;;
    -p | --prompt)
      prompt=$2
      shift
      ;;
    -a | --agent)
      agent=$2
      shift
      ;;
    --base)
      base=$2
      shift
      ;;
    -s | --session)
      session=$2
      shift
      ;;
    -*) die "unknown flag: $1" ;;
    *) handle=$1 ;;
    esac
    shift
  done
  [ -n "$handle" ] ||
    die "usage: wt add <handle> [-b] [-P file | -p text] [-a agent] [--base branch] [-s session]"
  [ -z "$prompt_file" ] || prompt=$(cat "$prompt_file")
  [ -z "$(window_id "$handle")" ] || die "'$handle' already has a window"

  : "${base:=$(git rev-parse --abbrev-ref HEAD)}"
  : "${session:=$(session_name)}"

  local path
  path=$(handle_path "$handle")
  mkdir -p "$(worktree_root)"
  git worktree add -b "$handle" "$path" "$base"
  git -C "$path" config "branch.$handle.wt-base" "$base"

  tmux has-session -t "=$session" 2>/dev/null ||
    tmux new-session -d -s "$session" -c "$(main_root)"

  # The prompt rides in as the agent's argv instead of being typed into the
  # pane afterwards, so there is no window to race against the agent booting.
  local command=("$agent")
  [ -z "$prompt" ] || command+=("$prompt")

  local window
  window=$(tmux new-window -d -P -F '#{window_id}' -t "=$session:" \
    -n "$window_prefix$handle" -c "$path" -- "${command[@]}")
  tmux set-option -w -t "$window" @agent-status working

  [ "$background" -eq 1 ] || tmux select-window -t "$window"
  printf '%s\t%s\t%s\n' "$handle" "$path" "$window"
}

cmd_list() {
  local root path handle window
  root=$(worktree_root)
  while read -r path; do
    case "$path" in
    "$root"/*) ;;
    *) continue ;;
    esac
    handle=$(basename "$path")
    window=$(window_id "$handle")
    printf '%s\t%s\t%s\t%s\n' "$handle" \
      "$(git -C "$path" rev-parse --abbrev-ref HEAD)" \
      "${window:+$(status_of "$window")}" \
      "$path"
  done < <(git worktree list --porcelain | awk '/^worktree /{print $2}')
}

cmd_status() {
  if [ $# -eq 0 ]; then
    tmux list-windows -a -F '#{window_name}	#{window_id}	#{@agent-status}' 2>/dev/null |
      grep "^$window_prefix" || true
    return
  fi
  local handle window
  for handle in "$@"; do
    window=$(window_id "$handle")
    printf '%s\t%s\n' "$handle" "${window:+$(status_of "$window")}"
  done
}

cmd_capture() {
  local lines=200 handle=""
  while [ $# -gt 0 ]; do
    case "$1" in
    -n)
      lines=$2
      shift
      ;;
    *) handle=$1 ;;
    esac
    shift
  done
  [ -n "$handle" ] || die "usage: wt capture <handle> [-n lines]"
  tmux capture-pane -p -J -S "-$lines" -t "$(agent_pane "$(require_window "$handle")")"
}

cmd_send() {
  local handle="" text="" file=""
  while [ $# -gt 0 ]; do
    case "$1" in
    -f)
      file=$2
      shift
      ;;
    *) if [ -z "$handle" ]; then handle=$1; else text=$1; fi ;;
    esac
    shift
  done
  [ -n "$handle" ] || die "usage: wt send <handle> <text> | wt send <handle> -f <file>"
  [ -z "$file" ] || text=$(cat "$file")
  [ -n "$text" ] || die "nothing to send"

  local window
  window=$(require_window "$handle")
  # A waiting agent has a dialog open, where the trailing Enter would pick an
  # answer instead of submitting the message.
  [ "$(status_of "$window")" != waiting ] ||
    die "'$handle' is waiting on a dialog; read it with 'wt capture $handle' first" 3

  local pane
  pane=$(agent_pane "$window")
  if [ "$text" = "${text%$'\n'*}" ]; then
    tmux send-keys -t "$pane" -l -- "$text"
  else
    # A multi-line message is bracketed so it arrives as one paste, rather than
    # as a run of Enters that submit it a line at a time. Only coding agents
    # turn bracketed paste on, which is why a one-liner skips it.
    tmux send-keys -t "$pane" -l $'\e[200~'"$text"$'\e[201~'
  fi
  tmux send-keys -t "$pane" Enter
}

cmd_wait() {
  local target="done" timeout=3600 any=0 elapsed=0
  local handles=() reached=() pending handle window
  while [ $# -gt 0 ]; do
    case "$1" in
    --any) any=1 ;;
    --status)
      target=$2
      shift
      ;;
    --timeout)
      timeout=$2
      shift
      ;;
    -*) die "unknown flag: $1" ;;
    *) handles+=("$1") ;;
    esac
    shift
  done
  [ ${#handles[@]} -gt 0 ] ||
    die "usage: wt wait <handle>... [--any] [--status S] [--timeout secs]"

  while :; do
    reached=()
    pending=0
    for handle in "${handles[@]}"; do
      window=$(window_id "$handle")
      # A closed window means the agent exited; count it as reached rather than
      # waiting out the timeout on something that will never report again.
      if [ -z "$window" ] || [ "$(status_of "$window")" = "$target" ]; then
        reached+=("$handle")
      else
        pending=1
      fi
    done
    if [ "$pending" -eq 0 ] || { [ "$any" -eq 1 ] && [ ${#reached[@]} -gt 0 ]; }; then
      [ ${#reached[@]} -eq 0 ] || printf '%s\n' "${reached[@]}"
      return 0
    fi
    [ "$elapsed" -lt "$timeout" ] || die "timed out after ${timeout}s" 124
    # ponytail: 2s poll, cheap enough next to agent turns that take minutes.
    sleep 2
    elapsed=$((elapsed + 2))
  done
}

cmd_path() { printf '%s\n' "$(handle_path "$1")"; }

cmd_merge() {
  local keep=0 handle=""
  while [ $# -gt 0 ]; do
    case "$1" in
    --keep) keep=1 ;;
    *) handle=$1 ;;
    esac
    shift
  done
  : "${handle:=$(handle_of_cwd)}"

  local path branch base root window
  path=$(handle_path "$handle")
  [ -d "$path" ] || die "no worktree at $path" 5
  branch=$(git -C "$path" rev-parse --abbrev-ref HEAD)
  base=$(git -C "$path" config --get "branch.$branch.wt-base" || printf 'main')
  root=$(main_root)

  git -C "$root" switch "$base"
  git -C "$root" merge --no-edit "$branch"
  [ "$keep" -eq 0 ] || return 0

  window=$(window_id "$handle")
  git -C "$root" worktree remove --force "$path"
  git -C "$root" branch -d "$branch"
  printf 'merged %s into %s\n' "$branch" "$base"
  # Last: this is the agent's own window when /merge runs inside the worktree.
  [ -z "$window" ] || tmux kill-window -t "$window"
}

cmd_rm() {
  local keep_branch=0 handles=()
  while [ $# -gt 0 ]; do
    case "$1" in
    --keep-branch) keep_branch=1 ;;
    *) handles+=("$1") ;;
    esac
    shift
  done
  [ ${#handles[@]} -gt 0 ] || die "usage: wt rm <handle>... [--keep-branch]"

  local handle path branch window root
  root=$(main_root)
  for handle in "${handles[@]}"; do
    path=$(handle_path "$handle")
    [ -d "$path" ] || die "no worktree at $path" 5
    branch=$(git -C "$path" rev-parse --abbrev-ref HEAD)
    window=$(window_id "$handle")
    [ -z "$window" ] || tmux kill-window -t "$window"
    git -C "$root" worktree remove --force "$path"
    [ "$keep_branch" -eq 1 ] || git -C "$root" branch -D "$branch"
  done
}

[ $# -gt 0 ] || die "usage: wt {add|list|status|capture|send|wait|path|merge|rm} ..."
subcommand=$1
shift
case "$subcommand" in
add) cmd_add "$@" ;;
list) cmd_list "$@" ;;
status) cmd_status "$@" ;;
capture) cmd_capture "$@" ;;
send) cmd_send "$@" ;;
wait) cmd_wait "$@" ;;
path) cmd_path "$@" ;;
merge) cmd_merge "$@" ;;
rm | remove) cmd_rm "$@" ;;
*) die "unknown command: $subcommand" ;;
esac
