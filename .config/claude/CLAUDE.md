# About Me

Name: Giulia
Role: Full Stack Developer with a focus on front-end development.

## Language Preferences

- English

## Response Style

- Main message first - Lead with the core answer or conclusion
- Key details second - Provide supporting information and context

## Tool Preferences

Prefer modern CLI tools over legacy equivalents:

- `rg` (ripgrep) instead of `grep`
- `fd` instead of `find`
- `bat` instead of `cat`
- `eza` instead of `ls`

## Development Guidelines

- Avoid nested if statements
- Follow the single responsibility principle
- Follow the guard clause pattern
- Keep things smart and simple
- Use pnpm for package management
- Clean code should not need comments; if it does, refactor for clarity

## Development Workflow (TDD)

When implementing features, follow this workflow:

1. **Test First**
   - Create comprehensive tests before implementation
   - Follow AAA: Arrange → Act (one action) → Assert
   - Cover: happy path, edge cases, invalid inputs, error scenarios, boundary conditions
   - Review tests before proceeding

2. **Implement + Light Refactor**
   - Implement code to satisfy tests
   - Apply basic refactoring immediately (naming, structure, simplicity)
   - Avoid premature optimization

3. **Review**
   - Check for code quality issues
   - Identify missed edge cases
   - Look for design flaws

4. **Iterate Until Stable**
   - Fix issues, re-run tests
   - Exit when all tests pass and code is clean

### Test Constraints

- No loops, conditionals, or complex logic inside tests
- No testing private methods directly
- One behavior per test
- Mock all external dependencies (no real DB, filesystem, network)
- Tests must be: Fast, Isolated, Deterministic, Self-validating

## Code Review Checklist

When reviewing code, check for:

### Security

- Missing authorization, IDOR
- Injection (SQL/NoSQL/command) via user input
- Secret exposure (API keys in code)
- Weak hashing, insecure random
- Input validation at system boundaries
- Sensitive data in logs

### Performance

- N+1 queries, missing indexes
- Unbounded collections without pagination
- Synchronous blocking calls
- In-memory state that won't scale horizontally
- Missing connection pooling or rate limiting

### Architecture

- SOLID violations (SRP: multiple reasons to change; OCP: modify to extend)
- God objects (>500 lines or >20 methods)
- Anemic domain models, shotgun surgery, feature envy

### Code Quality

- Cyclomatic complexity > 10
- Nested conditionals (use guard clauses)
- Functions > 50 lines
- Missing error handling
- Unclear naming
- Magic numbers/strings without constants

### Error Handling

- Swallowed exceptions (empty catch blocks)
- Generic catch-all without specificity
- Silent failures (no logging, no rethrow)
- Missing finally blocks for cleanup

### Concurrency

- Race conditions (shared state without locks)
- Missing await/async error handling
- Resource leaks (unclosed connections, file handles, event listeners)
- Unhandled promise rejections

### Data & State

- Mutable global state
- Missing null/undefined checks
- Stale cached data without invalidation
- Shallow copy when deep clone needed

### Testing

- Missing coverage for changed paths
- No edge cases tested
- Error scenarios untested

### API

- Breaking changes without deprecation
- Missing schema validation
- Inconsistent error responses

### Accessibility (Frontend)

- Missing ARIA labels on interactive elements
- Keyboard navigation gaps
- Color-only indicators (no text/icon backup)
- Missing alt text on images
- Form inputs without labels

### Dependencies

- Unused imports/dependencies
- Outdated packages with known CVEs
- Duplicate functionality (lodash vs native)

### Observability

- Missing logging in critical paths
- Hardcoded values (should be config/env vars)
- No health checks or metrics hooks
