# Global Development Preferences

## Communication

- Lead with the answer, then details.
- No initial-style abbreviations for domain terms, classes, or files (write "PersonalAccident", not "PA").
- State assumptions. If ambiguous or uncertain, ask before coding.
- When stuck: name the problem, propose 2-3 options with trade-offs, ask for guidance.

## Simplicity

- Smallest change that solves the problem. KISS / YAGNI / DRY.
- No speculative features, abstractions for single-use code, unrequested flexibility, or error handling for impossible cases.
- Reuse before you write: search for existing helpers, utilities, types, and patterns in the codebase before adding new ones. Don't duplicate what already lives a few files over.
- Guard clauses over nested conditionals. Single responsibility.
- Soft limits: functions <30 lines, files <300 lines, nesting ≤3.

## Surgical Changes

- Touch only what the task requires. Match existing style.
- Don't refactor, reformat, or "improve" adjacent code.
- Remove orphans your change created; leave pre-existing dead code (mention it).
- Every changed line must trace to the request.

## Goal-Driven Execution

- Turn tasks into verifiable goals ("fix bug" → "write test that reproduces, then make it pass").
- For multi-step work, state a brief numbered plan with a verify step per item.

## Naming

- Self-documenting. Booleans `is_` / `has_` / `can_`. Functions = verbs. Classes = nouns.
- Avoid abbreviations for variables, functions, types, and domain concepts.

## Commits & Git

- Subject line only unless non-obvious context is needed. Refactor commits explain _why_.
- Never commit or push without explicit approval. Never force-push `main`/`master`.

## Security

- Never commit secrets, API keys, tokens, `.env`, credentials, or PII.
- Validate external input server-side; sanitize before DB queries.
- Credential locations: project → `.env` (gitignored); global → `~/.env`; SSH → `~/.ssh/`; cloud → `~/.aws/`, `~/.config/gcloud/`; npm → `~/.npmrc`.
- If exposed: rotate, `git filter-repo`, force-push.

## Package Management

- pnpm for Node projects.

## Code Review

Prioritize substance over style. Cover areas relevant to the change: correctness, security, performance, architecture, complexity, concurrency, state, API contracts, tests/edge cases, dependencies, accessibility, observability. Large files, long functions, and heavy abstraction are signals to investigate — not automatic violations.
