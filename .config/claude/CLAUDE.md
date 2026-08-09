# Global Development Preferences

## Communication

- Respond in English.
- Lead with the main answer or conclusion, then provide supporting details.

## CLI

Prefer modern CLI tools over legacy equivalents:

- `rg` instead of `grep`
- `fd` instead of `find`
- `bat` instead of `cat`
- `eza` instead of `ls`

## Development

- Use pnpm for package management.
- Prefer guard clauses over nested conditionals.
- Follow the single responsibility principle.
- Prefer simple, readable solutions over clever abstractions.
- Don't introduce abstractions without a concrete need.
- Prefer existing patterns over introducing new ones.
- Make the smallest change that completely solves the problem.
- Avoid unrelated refactoring.
- Prefer self-explanatory code over comments.
- Use comments only when they explain non-obvious intent, constraints, or why something is done.

## TDD

When implementing features or fixing bugs:

1. Write tests before implementation.
2. Cover expected behavior, important edge cases, invalid inputs, errors, and relevant boundaries.
3. Follow Arrange → Act → Assert.
4. Keep each test focused on one behavior.
5. Implement the smallest solution that makes the tests pass.
6. Refactor for clarity and simplicity.
7. Review the implementation for missed cases and design issues.
8. Re-run relevant tests until everything is stable.

Tests should be fast, isolated, deterministic, and self-validating.

Prefer testing behavior through public interfaces rather than implementation details. Avoid unnecessary control flow or complex logic in tests.

Mock external dependencies in unit tests. Use integration or E2E tests when real infrastructure behavior is what needs to be verified.

## Commits

- Keep commit messages concise and use a subject line only.
- Refactor commits should explain why the refactor was necessary.
- Skip the commit body unless it is needed to explain non-obvious context.

## Code Review

When reviewing code, consider the areas relevant to the change:

- Security and input validation
- Correctness and error handling
- Performance and scalability
- Architecture and maintainability
- Complexity and readability
- Concurrency and resource management
- Data and state management
- API contracts and validation
- Testing and edge cases
- Dependencies and supply-chain risks
- Accessibility for frontend code
- Observability where applicable

Prioritize substantive issues over stylistic preferences.

Treat large files, long functions, high complexity, and excessive abstraction as signals to investigate rather than absolute violations.

## Working With Existing Code

- Inspect the existing implementation before making changes.
- Follow established project conventions unless there is a good reason not to.
- Reuse existing utilities, components, patterns, and dependencies where appropriate.
- Do not introduce a new dependency when the existing stack can solve the problem cleanly.
- Do not refactor unrelated code unless explicitly asked.
