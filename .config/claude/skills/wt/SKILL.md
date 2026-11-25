---
name: wt
description: Manage terminal agents, git worktrees, and tmux sessions with the
  wt helper. Use when the user asks to open or start an agent in a project,
  check running agents or their progress in a tmux session, or work with
  worktrees or parallel agent workflows.
---

# wt

`wt` pairs a git worktree with a tmux window so several coding agents can work
in parallel, each on its own branch in its own checkout. It is a small shell
wrapper over `git worktree` and `tmux`; everything it does can also be done by
hand with those two commands.

**If the user asks you to create worktrees or dispatch tasks (e.g.,
"/worktree ..."), you are a dispatcher.** Write prompt files and run
commands. Do NOT explore, read, or research the codebase first. Use
context you already have. The worktree agent does all the work.

## Key concepts

- **Handle**: the worktree directory name, which is also the branch name.
  Every command addresses agents by handle.
- **Worktree directory**: `<project>__worktrees/<handle>`, a sibling of the
  project root.
- **tmux window**: named `wt-<handle>`, in the session named after the
  repository directory. Handles resolve across every session, so an agent in
  another project can be addressed by its handle alone.
- **Agent status**: `working`, `waiting` (needs input), `done`. Claude Code
  hooks write it to the window's `@agent-status` option, which is also what
  draws the coloured dot in the tmux statusline. An agent with no reported
  status shows as `unknown`.
- **Base branch**: recorded at creation as `branch.<handle>.wt-base` in git
  config, and used by `/merge` and `/rebase`.

## Opening agents in projects

When the user asks to open or start a new agent in `<project>`, treat the
project name as a tmux session name. Resolve the project's directory, reuse
that tmux session if it exists, and create it if it does not. Start the agent
in a new window in that session, with the project directory as its working
directory. Use the agent requested by the user or the configured default.
This means a terminal agent in tmux, not a new chat in the assistant app.

For an existing session:

```bash
tmux new-window -d -P -F '#{window_id}' -t <project> -n <name> \
  -c <project-path> <agent>
```

If the session does not exist, create it with the agent in its first window:

```bash
tmux new-session -d -P -F '#{window_id}' -s <project> -n <name> \
  -c <project-path> <agent>
```

Use tmux session metadata to resolve existing project paths, for example
`tmux list-sessions -F '#{session_name}\t#{session_path}'`. Avoid directory
listings when that metadata already supplies the path. Create windows with
`tmux new-window -d -P -F '#{window_id}' ...` to return the new window ID;
use that ID for subsequent operations instead of listing windows again.
When switching is requested, batch the client lookup and switch into one
tool call. Switch only when requested. Avoid redundant verification calls
when the command's successful result already confirms the operation.

When a separate worktree would clearly benefit the task, use `wt add` from the
target repository instead. Pass `-s <project>` to place the agent in the
intended tmux session; `wt` creates that session if it does not exist.
Otherwise, use the existing project checkout.

## Checking agent status

Reuse known sessions, paths, and handles. If handles are unknown, run
`wt status` first.

Batch `wt status` and `wt capture <handle> -n 50` for relevant agents in one
tool call. Skip idle shells and unrelated projects. Report task, progress,
blockers, and completion evidence; stop when clear.

## Commands

### Create a worktree

```bash
wt add <handle>
```

Creates the worktree and branch, opens a tmux window with the agent running in
it, and switches to that window.

Flags:

- `-b, --background`: create without switching to the new window
- `-P <file>`: prompt from file, passed to the agent as its first message
- `-p <text>`: inline prompt, same
- `-a <agent>`: override the agent (default `claude`, or `$WT_AGENT`)
- `--base <branch>`: branch from a specific base (default: current branch)
- `-s <session>`: tmux session that receives the window (default: repository
  directory name)

Prints `<handle>\t<path>\t<window-id>` on success.

### List worktrees

```bash
wt list
```

One line per worktree: handle, branch, agent status, path.

### Interact with other agents

```bash
# Statuses
wt status                      # every wt window, across all sessions
wt status auth api-tests       # specific handles

# Wait
wt wait auth api-tests                 # block until all are done
wt wait auth --timeout 600             # give up after 10 minutes (exit 124)
wt wait auth api-tests --any           # return as soon as one is done
wt wait auth --status working          # wait for a specific status

# Read an agent's terminal output
wt capture auth                # last 200 lines
wt capture auth -n 50          # last 50 lines

# Send an instruction
wt send auth "fix the tests"
wt send auth "/merge"          # a skill command
wt send auth -f followup.md    # from a file
```

`wt send` refuses an agent whose status is `waiting`, because the trailing
Enter would answer the open dialog instead of submitting a message; read it
with `wt capture` first. Failures exit with a stable code:

| Exit | Meaning                                    |
| ---- | ------------------------------------------ |
| 3    | Agent is waiting on a dialog; nothing sent |
| 5    | No window or worktree for that handle      |
| 124  | `wait --timeout` expired                   |

`wt wait` treats a closed window as reached rather than waiting out the
timeout, so an agent that exits does not stall the wait.

### Run a command in a worktree

There is no `run` subcommand; use the worktree path directly.

```bash
git -C "$(wt path auth)" status
(cd "$(wt path auth)" && pytest tests/)
```

### Merge a branch

```bash
wt merge                # the worktree the command runs in
wt merge <handle>       # a specific worktree
wt merge --keep         # merge but keep the worktree, window, and branch
```

Switches the main checkout to the recorded base branch, merges, then removes
the worktree, deletes the branch, and kills the tmux window. Use the `/merge`
skill for the full workflow (commit, rebase, then merge).

### Remove worktrees

```bash
wt rm <handle>...              # kill the window, remove the worktree, delete the branch
wt rm <handle> --keep-branch   # keep the branch
```

`wt rm` deletes the branch with `git branch -D`, so unmerged work goes with it.
Prefer `wt merge` when the work should be kept.

### Other

```bash
wt path <handle>        # print the worktree's filesystem path
```

The tmux dashboard of every session and the agents in them is bound to
`prefix Tab` (`multiplexer-sidebar`); `prefix S` opens it as a sidebar.

## Configuration

`wt` has no config file. The two knobs are `$WT_AGENT` (default agent, default
`claude`) and the `--base` flag. Per-project setup such as copying `.env` or
installing dependencies is not automated: do it in the new worktree, or tell
the dispatched agent to do it in its prompt.

## Common workflows

### Finishing work: direct merge

Use `/merge` to commit, rebase onto the base branch, and merge in one step.
This cleans up the worktree, tmux window, and branch.

### Finishing work: PR-based

1. Commit changes
2. `git push -u origin HEAD`
3. Use `/open-pr` to write a PR description and open in browser
4. After the PR is merged remotely, clean up with `wt rm <handle>`

### Delegating tasks

Use `/worktree` to spin off tasks into parallel worktree agents. The agent
writes a prompt file and runs `wt add -b -P <file>`.

For full lifecycle orchestration (spawn, monitor, merge), use `/coordinator`.

### Cross-project worktree creation

`wt add` creates a worktree in the current working repository. Set the
command's working directory to the target project and pass `-s` to place the
window in a specific tmux session. The working directory and the tmux session
are independent, and `wt` creates the session when it does not exist, so do
not bootstrap it with `tmux new-session`.

```bash
# Run with the command working directory set to <project-path>
wt add <handle> -b -P <prompt-file> -s <session>
```

Do NOT research before dispatching. Use context you already have, but do not
explore or read code just to write the prompt. Worktree agents can read files
from other projects via absolute paths, so reference other projects by path
and let the agent explore on its own.

## Related skills

- **`/merge`**: commit, rebase, and merge the current branch
- **`/rebase`**: rebase with smart conflict resolution
- **`/worktree`**: delegate tasks to parallel worktree agents
- **`/coordinator`**: orchestrate multiple agents (spawn, monitor, merge)
- **`/open-pr`**: write PR description and open in browser
