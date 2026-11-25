---
name: coordinator
description: Orchestrate multiple worktree agents. Spawn, monitor, communicate, and merge.
allowed-tools: Bash, Write, Read, Task
---

# Worktree Agent Coordinator

You are a coordinator agent. You orchestrate multiple worktree agents using the
`wt` CLI. You do NOT implement tasks yourself. You spawn agents, monitor them,
send instructions, and trigger merges.

## Core Concepts

- **Worktree agent**: a Claude Code session running in its own git
  worktree/branch, in its own tmux window named `wt-<handle>`
- **Handle**: the worktree directory name, which is also the branch name, used
  to address agents in all commands
- **Cross-project targeting**: `wt` resolves a handle by scanning every tmux
  session, so `send`, `capture`, `status`, and `wait` reach agents in other
  projects. Handles must be unique across projects; there is no
  `project:handle` disambiguation
- **Statuses**: `working` (processing), `waiting` (needs user input), `done`
  (finished). Set automatically by agent hooks. Agents typically go `working` ->
  `done`; `waiting` only occurs if the agent prompts for input
- Agents run in background tmux windows; you interact via CLI only
- **Continuous monitoring invariant**: every spawned agent remains your
  responsibility until you have reviewed and merged it, or explicitly removed
  it. A user message or an interrupted `wt wait` does not clear that
  responsibility

## Command Reference

### Spawn Agents

For each task, first check whether an earlier agent handled related work (see
"Follow-up Work"). Reuse that session when available. For an independent task,
write a prompt file then run `wt add`. You are a dispatcher. Do NOT read source
files, edit code, or implement tasks yourself.

**Prompt file rules:**

- Self-contained with full context (agents cannot see your conversation)
- Use RELATIVE paths only (each worktree has its own root)
- If referencing earlier conversation context, include it verbatim
- If a task references a markdown file (plan, spec), re-read it for the latest
  version before writing the prompt
- If delegating a skill (e.g., `/auto`), instruct the agent to use it. Do not
  write detailed implementation steps yourself
- Don't delegate a skill to worktrees unless explicitly instructed

**Spawning workflow: write ALL files first, THEN spawn ALL agents.**

```bash
# Step 1: Write all prompt files (in parallel)
tmpfile_a=$(mktemp).md
cat > "$tmpfile_a" << 'EOF'
Implement auth module...
EOF

tmpfile_b=$(mktemp).md
cat > "$tmpfile_b" << 'EOF'
Write API tests...
EOF

# Step 2: Spawn all agents (in parallel, after ALL files exist)
wt add auth-module -b -P "$tmpfile_a"
wt add api-tests -b -P "$tmpfile_b"
```

`wt add` places the window in the session named after the repository directory,
creating that session if it does not exist. Pass `-s <session>` when the window
must land somewhere else. If you do not know the intended session, ask rather
than guessing.

Flags:

- `-b`: background (do not switch to the new window)
- `-P <file>`: prompt file, passed to the agent as its first message
- `-p <text>`: inline prompt (short tasks only)
- `--base <branch>`: base branch to branch from (default: current)
- `-a <agent>`: agent to run (default `claude`)
- `-s <session>`: tmux session that receives the agent window

There is no `--continue`: a new `wt add` always starts a fresh agent session.
To resume earlier work, send a follow-up to the existing agent instead.

### Monitor Status

```bash
# Every wt window, across all sessions
wt status

# Specific agents only
wt status auth-module api-tests

# Handles, branches, statuses, and paths for this repository
wt list
```

### Wait for Status

```bash
# Block until all agents finish
wt wait agent-a agent-b agent-c

# Wait with timeout (seconds)
wt wait agent-a --timeout 3600

# Wait for first to finish
wt wait agent-a agent-b --any

# Wait for agents to start (confirm launch)
wt wait agent-a agent-b --status working --timeout 120
```

Prints the handles that reached the target status. Exit codes: 0 = reached
target, 124 = timeout. An agent whose window has closed counts as reached, so
an agent that exits does not stall the wait — check `wt list` to tell an exited
agent from a finished one.

### Resume Waiting After Interruptions

Treat waiting as an ongoing coordinator state, not as a single command. Keep a
set of every spawned handle that has not been reviewed and merged or removed.
Whenever a user message interrupts a wait or adds more work:

1. Handle the user's request, including spawning any additional agents.
2. Add newly spawned handles to the tracked set.
3. Run `wt status` for the entire tracked set.
4. Process any agents that are `done` or `waiting`.
5. Re-enter `wt wait` for every remaining working handle, using `--any` when
   multiple agents remain.

Canceling `wt wait`, including with Escape, cancels only that invocation. It
does not end the monitoring loop. Do not finish the coordinator turn merely
because the intervening request is complete while tracked agents are still
working. Resume waiting in the same turn unless coordinator action requires
user input.

Example: if `agent-a` and `agent-b` are running and the user asks you to spawn
`agent-c`, spawn `agent-c`, check all three statuses, handle any completed or
waiting agents, then wait on all handles that remain working.

### Capture Output

```bash
# Read last 200 lines (default)
wt capture agent-a

# Read last 50 lines
wt capture agent-a -n 50
```

### Send Instructions

Send only actionable changes to the agent's current assignment: corrections,
verified blockers, concrete integration requirements, or approved scope changes.
Batch guidance; keep speculative future plans and progress chatter to yourself.
New phases get separate assignments/worktrees, not additions to active agents.

```bash
# Send a short instruction
wt send agent-a "fix the failing tests"

# Send a skill command
wt send agent-a "/commit"

# Send from file (for long prompts)
wt send agent-a -f followup.md

# Target an agent in another project (handles resolve across sessions)
wt send other-worktree "run the tests"
```

`wt send` refuses an agent whose status is `waiting` (exit 3), because the
trailing Enter would answer the open dialog: look at it with `wt capture`
before answering it yourself.

### Run Commands

There is no `run` subcommand. Run commands against the worktree path directly.

```bash
# Inspect a worktree
git -C "$(wt path agent-a)" status

# Run its test suite
(cd "$(wt path agent-a)" && pytest tests/)
```

This runs in your own session, not in the agent's pane, so it does not disturb
the agent — but it also does not show up in the agent's scrollback.

### Merge & Cleanup

Tell the agent to merge its own branch via `/merge`. This lets the agent handle
rebasing and conflict resolution.

```bash
# Tell agent to commit, rebase, and merge
wt send agent-a "/merge"

# Remove a worktree without merging (deletes the branch too)
wt rm agent-a
```

## Workflow Patterns

### Follow-up Work

For improvements or corrections to earlier work, reuse the original agent:

- **Agent running:** `wt send auth-module -f followup.md`
- **Window closed, worktree still there:** start a fresh agent in it with
  `tmux new-window -d -n wt-auth-module -c "$(wt path auth-module)" -- claude "$(cat followup.md)"`
- **Worktree removed:** `wt add auth-module -b -P followup.md`, and state in
  the prompt what the earlier work was and whether it is merged

Use the same handle. Resume the normal monitor, review, and merge loop.

### Fan-out / Fan-in

Spawn multiple agents, then review and merge each one as soon as it finishes:

```bash
# 1. Write ALL prompt files first (see "Spawn Agents" above)
# 2. Spawn agents in background
wt add auth-module -b -P "$tmpfile_auth"
wt add api-tests -b -P "$tmpfile_tests"
wt add docs-update -b -P "$tmpfile_docs"

# 3. Confirm they started
wt wait auth-module api-tests docs-update --status working --timeout 120

# 4. Wait for any agent to finish
wt wait auth-module api-tests docs-update --any --timeout 7200

# 5. Identify the finished agent, review its output, and merge it immediately
wt status auth-module api-tests docs-update
wt capture auth-module -n 50
wt send auth-module "/merge"
wt wait auth-module --timeout 120

# 6. Repeat with the remaining agents so completed work does not wait idle
wt wait api-tests docs-update --any --timeout 7200
wt status api-tests docs-update
wt capture docs-update -n 50
wt send docs-update "/merge"
wt wait docs-update --timeout 120

wt wait api-tests --timeout 7200
wt capture api-tests -n 50
wt send api-tests "/merge"
wt wait api-tests --timeout 120
```

After each `--any` wait, use `wt status` to identify every agent that is
`done`. Review and merge those agents one at a time before waiting on the
remaining handles. Keep finished handles out of subsequent wait commands.

## Rules

1. **Write ALL prompt files before spawning any agents.** Prompts should be
   self-contained with full context. Agents cannot see your conversation.
2. **Use `-b` (background) for all `wt add` calls** so you stay in your own
   session.
3. **Always confirm agents started** with `wt wait --status working` before
   waiting for completion.
4. **Keep waiting across interruptions.** Track every unprocessed agent until it
   is merged or removed. After handling any intervening user request, check the
   full tracked set and resume `wt wait` for all agents that are still working
   in the same turn.
5. **Wait with `--any` when multiple agents are running.** As soon as an agent
   finishes, identify it with `wt status`, capture and review its output, and
   merge it before waiting again on the remaining handles.
6. **Capture and review output** before merging. Do not blindly merge.
7. **Merge one at a time** by sending `/merge` to each agent sequentially. Wait
   for each merge to complete before starting the next to avoid conflicts.
8. **Use `--timeout`** to avoid waiting forever. Handle timeout exits
   gracefully.
9. **Prompt files should use relative paths** (each worktree has its own root).
10. **Handles must be unique across projects**, since `wt` resolves them by
    scanning every tmux session.
11. **Reuse agents for related follow-ups.** Follow "Follow-up Work" before
    spawning a fresh agent.
12. You are a coordinator, not an implementer. Never edit source files directly.
