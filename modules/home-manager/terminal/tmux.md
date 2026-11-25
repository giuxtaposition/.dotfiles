# tmux

Cheat sheet for `tmux.nix` and `wt.sh`. Prefix is `C-a` (`C-a C-a` sends a
literal `C-a`). Keys marked `[*]` are set in `tmux.nix`; everything else is a
tmux default kept as-is. `prefix ?` lists the live bindings if this drifts.

## No prefix (root table)

| Key                    |     | Action                                       |
| ---------------------- | --- | -------------------------------------------- |
| `C-h/j/k/l`            | [*] | move to pane left/down/up/right (or to nvim) |
| `C-Left/Down/Up/Right` | [*] | same, arrow keys                             |
| `M-h/j/k/l`            | [*] | resize pane left/down/up/right by 3          |
| `M-Left/Down/Up/Right` | [*] | same, arrow keys                             |
| `M-1` .. `M-9`         | [*] | select window 1..9                           |
| `S-Left` / `S-Right`   | [*] | previous / next window                       |

## Prefix: sessions & server

| Key     |     | Action                               |
| ------- | --- | ------------------------------------ |
| `C-c`   | [*] | new session                          |
| `d`     |     | detach client                        |
| `D`     |     | choose a client to detach            |
| `s`     |     | choose session (tree)                |
| `$`     |     | rename session                       |
| `(` `)` |     | previous / next session              |
| `L`     |     | last session                         |
| `:`     |     | command prompt                       |
| `?`     |     | list all key bindings                |
| `/`     |     | describe one key                     |
| `~`     |     | show server messages                 |
| `C`     |     | customize-mode (options browser)     |
| `r`     |     | redraw client                        |
| `C-z`   |     | suspend client                       |
| `R`     | [*] | re-source `~/.config/tmux/tmux.conf` |

## Prefix: windows

| Key         |     | Action                                                 |
| ----------- | --- | ------------------------------------------------------ |
| `c`         | [*] | new window in the current pane's directory             |
| `a`         |     | send a literal `C-a`                                   |
| `n` / `p`   |     | next / previous window                                 |
| `M-n` `M-p` |     | next / previous window with activity                   |
| `0` .. `9`  |     | select window by index (windows start at 1)            |
| `'`         |     | prompt for a window index                              |
| `w`         |     | choose window (tree)                                   |
| `,`         |     | rename window                                          |
| `.`         |     | move window to another index                           |
| `&`         |     | kill window (confirms)                                 |
| `<`         |     | window menu                                            |
| `f`         | [*] | fuzzy-search this pane's scrollback                    |
| `e`         | [*] | open a `file:line` from the scrollback in nvim         |
| `F`         | [*] | pick files and type them into the pane                 |
| `Tab`       | [*] | session + agent dashboard, in a popup                  |
| `S`         | [*] | session + agent sidebar, a persistent pane on the left |
| `C-s`       | [*] | save the session layout now                            |
| `C-r`       | [*] | restore the last saved layout                          |

## Prefix: panes

| Key                    |     | Action                                                                                   |
| ---------------------- | --- | ---------------------------------------------------------------------------------------- |
| `v`                    | [*] | split side by side, same directory                                                       |
| `b`                    | [*] | split stacked, same directory                                                            |
| `h/j/k/l`              | [*] | select pane left/down/up/right (repeatable)                                              |
| `Left/Down/Up/Right`   |     | select pane by direction (repeatable)                                                    |
| `C-Left/Down/Up/Right` |     | resize pane by 1 (repeatable)                                                            |
| `M-Left/Down/Up/Right` |     | resize pane by 5 (repeatable)                                                            |
| `o` / `;`              |     | next pane / last pane                                                                    |
| `q`                    |     | show pane numbers, type one to select                                                    |
| `z`                    |     | zoom pane                                                                                |
| `x`                    |     | kill pane (confirms)                                                                     |
| `!`                    |     | break pane out into its own window                                                       |
| `*`                    |     | new pane                                                                                 |
| `m` / `M`              |     | mark / clear marked pane                                                                 |
| `{` / `}`              |     | swap pane up / down                                                                      |
| `C-o` / `M-o`          |     | rotate panes forward / backward                                                          |
| `Space`                |     | next layout                                                                              |
| `M-1` .. `M-7`         |     | preset layouts (even-h, even-v, main-h, main-v, tiled, main-h-mirrored, main-v-mirrored) |
| `E`                    |     | spread panes out evenly                                                                  |
| `i`                    |     | display pane info                                                                        |
| `t`                    |     | clock                                                                                    |
| `>`                    |     | pane menu                                                                                |

## Prefix: copy & paste (vi keys, mouse on)

| Key             | Action                       |
| --------------- | ---------------------------- |
| `[` or `PageUp` | enter copy mode              |
| `]`             | paste buffer                 |
| `=`             | choose buffer to paste       |
| `#` / `-`       | list buffers / delete buffer |

## Copy mode (vi)

| Key                       |     | Action                                         |
| ------------------------- | --- | ---------------------------------------------- |
| `h/j/k/l` `w/b/e` `0/^/$` |     | motions, as in vim                             |
| `g` / `G`                 |     | top / bottom of history                        |
| `C-u/C-d` `C-b/C-f`       |     | half page / full page                          |
| `H/M/L`                   |     | top / middle / bottom visible line             |
| `/` `?` `n/N`             |     | search down / up, next / previous match        |
| `:` NUM                   |     | go to line (counted from the visible top)      |
| `v`                       | [*] | begin selection (default: `Space`)             |
| `C-v`                     | [*] | toggle rectangle selection (default: `r`)      |
| `V`                       |     | select whole line                              |
| `o`                       |     | jump to the other end of the selection         |
| `y`                       | [*] | copy selection and exit (default: `Enter`)     |
| `A`                       |     | append selection to the buffer and exit        |
| `Escape`                  |     | clear selection                                |
| `q` or `C-c`              |     | leave copy mode                                |
| `C-h/j/k/l`, `C-arrows`   | [*] | move to another pane without leaving copy mode |
| Mouse drag                | [*] | selects but does not copy or exit; press `y`   |

## Popups

| Key   |     | Behaviour                                                                                      |
| ----- | --- | ---------------------------------------------------------------------------------------------- |
| `g`   | [*] | lazygit, full screen, in the pane's directory                                                  |
| `f`   | [*] | scrollback search: `Enter` picks, `C-c` aborts, `C-b`/`C-f` scroll the preview                 |
| `e`   | [*] | `file:line` picker, opens in the pane's nvim                                                   |
| `F`   | [*] | file picker: `Tab` multi-selects, paths are `@`-prefixed when a coding agent runs in the pane  |
| `Tab` | [*] | dashboard: `j/k` moves, `Enter` jumps, `/` filters, `n/r/x` makes, renames and kills a session |

## Statusline

Window names sit centred, the current one bright and the rest dim; the session
name is on the left and turns into a filled pill while the prefix is held; CPU
and memory are on the right, sampled from `/proc` every 5s.

A coloured dot before a window name is a coding agent reporting through that
window's `@agent-status` option, which the Claude Code hooks in
`~/.config/claude/settings.json` set:

| Dot    | Status    | Meaning           |
| ------ | --------- | ----------------- |
| yellow | `working` | processing        |
| peach  | `waiting` | needs user input  |
| green  | `done`    | finished its turn |

## Starting tmux

Kitty's `shell` is `tmux new-session -A -s main`, so every kitty window is a
tmux client: `-A` attaches to `main` when it exists and creates it otherwise.
Closing the last tmux window closes the kitty window.

This is set in `kitty.nix`, not in the fish config, which keeps nvim's
`:terminal`, `fish -c`, and script shells out of tmux.

## Saving and restoring sessions

tmux-resurrect writes the session layout, and tmux-continuum drives it:

| Key          | Action                |
| ------------ | --------------------- |
| `prefix C-s` | save now              |
| `prefix C-r` | restore the last save |

State goes to `~/.local/share/tmux/resurrect/`. Sessions, windows, their names,
and their working directories come back; scrollback comes back too
(`@resurrect-capture-pane-contents`). Programs are **not** restored unless they
are on resurrect's default list (nvim, less, man, top, …) — coding agents are
not, which is what you want: a restore gives you the worktree windows without
six agents resuming at once.

Continuum saves every 15 minutes and restores on server start, which in
practice means the first terminal opened after a boot.

Two things worth knowing, both upstream behaviour:

- **Continuum does nothing while a second tmux server is running.** It skips
  both auto-save and auto-restore rather than let two servers overwrite each
  other's state. A stray `tmux -L something` is enough to disable it.
- **Continuum has no timer of its own.** It hangs a `#()` off `status-right`
  and lets the status line tick drive the save. home-manager emits plugins
  before `extraConfig`, so the `status-right` in `tmux.nix` would wipe that
  hook; it calls `continuum_save.sh` itself instead. Keep that call in
  `status-right` or auto-save stops silently.

# wt

`wt` (`wt.sh`) pairs a git worktree with a tmux window so several coding agents
run in parallel, each on its own branch in its own checkout. It is a thin
wrapper over `git worktree` and `tmux`.

- **Handle**: the worktree directory name, which is also the branch name. Every
  command addresses agents by handle, and handles resolve across every tmux
  session — so they must be unique across projects.
- **Worktree directory**: `<project>__worktrees/<handle>`, a sibling of the
  project root.
- **Window**: named `wt-<handle>`, in the session named after the repository
  directory. `wt` creates that session if it does not exist.
- **Base branch**: recorded at creation as `branch.<handle>.wt-base` in git
  config; `/merge` and `/rebase` read it.

## Commands

| Command                      | Does                                                 |
| ---------------------------- | ---------------------------------------------------- |
| `wt add <handle>`            | create worktree + branch + window, switch to it      |
| `wt list`                    | handle, branch, status, path — one line per worktree |
| `wt status [handle...]`      | agent statuses; no args lists every `wt` window      |
| `wt capture <handle> [-n N]` | last N lines of the agent's pane (default 200)       |
| `wt send <handle> <text>`    | type a message into the agent and press Enter        |
| `wt wait <handle>...`        | block until the agents reach a status                |
| `wt path <handle>`           | print the worktree's filesystem path                 |
| `wt merge [handle]`          | merge into the base branch, then clean up            |
| `wt rm <handle>...`          | kill window, remove worktree, delete branch          |

### `wt add` flags

| Flag              | Does                                                         |
| ----------------- | ------------------------------------------------------------ |
| `-b`              | background: do not switch to the new window                  |
| `-P <file>`       | prompt from a file, passed to the agent as its first message |
| `-p <text>`       | inline prompt, same                                          |
| `-a <agent>`      | agent to run (default `claude`, or `$WT_AGENT`)              |
| `--base <branch>` | branch from a specific base (default: current branch)        |
| `-s <session>`    | tmux session that receives the window                        |

### `wt wait` flags

| Flag               | Does                                                     |
| ------------------ | -------------------------------------------------------- |
| `--any`            | return as soon as one handle reaches the status          |
| `--status <state>` | wait for `working` / `waiting` / `done` (default `done`) |
| `--timeout <secs>` | give up after N seconds (default 3600)                   |

A closed window counts as reached, so an agent that exits does not stall the
wait. Check `wt list` to tell an exited agent from a finished one.

### Other flags

`wt merge --keep` merges but keeps the worktree, window, and branch.
`wt rm --keep-branch` removes the worktree and window but keeps the branch.

### Exit codes

| Exit | Meaning                                              |
| ---- | ---------------------------------------------------- |
| 3    | `send` to an agent waiting on a dialog; nothing sent |
| 5    | no window or worktree for that handle                |
| 124  | `wait --timeout` expired                             |

`wt send` refuses a `waiting` agent because the trailing Enter would answer the
open dialog instead of submitting a message — read it with `wt capture` first.

## No run subcommand

Use the worktree path directly:

```bash
git -C "$(wt path auth)" status
(cd "$(wt path auth)" && pytest tests/)
```

## Not supported

Carried over from workmux and deliberately not reimplemented: PR checkout,
conversation forking, session resume (`--continue`), worktree matrices,
headless mode, per-project config (file copies, symlinks, post-create hooks),
and `project:handle` disambiguation. Do per-project setup inside the new
worktree, or tell the dispatched agent to do it in its prompt.
