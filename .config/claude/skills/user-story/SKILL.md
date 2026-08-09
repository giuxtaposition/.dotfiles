---
name: user-story
description: User story format and best practices — As a / I want / So that, with acceptance criteria. Use when writing user stories, defining features, planning sprints, or capturing requirements. Load when the user discusses product features, acceptance criteria, or needs to document behavior from a user perspective.
---

# User Story Fundamentals

## Format

```
"As a [type of user],
 I want [some goal],
 so that [some reason/benefit]."
```

## User Specificity

```
Generic (avoid):
├── "As a user..."

Better:
├── "As a first-time visitor..."
├── "As a mobile user..."

Best:
├── "As a marketing manager who needs weekly reports..."
└── "As a developer debugging production issues..."
```

## INVEST Criteria

- **I**ndependent - Can be developed separately
- **N**egotiable - Details open to discussion
- **V**aluable - Delivers real value
- **E**stimable - Team can estimate effort
- **S**mall - Fits within single sprint
- **T**estable - Has clear acceptance criteria

## Acceptance Criteria

```
Story: "As a user, I want to reset my password via email"

Acceptance Criteria:
□ User can request reset from login page
□ Email sent within 60 seconds
□ Reset link expires after 24 hours
□ Link works only once
□ Password must meet security requirements
```

## Story Splitting

**Split when:** Can't complete in one sprint, multiple user values, contains "and"

**By workflow:** add to cart → enter shipping → enter payment → confirm
**By user type:** admin dashboard → manager view → user view
**By CRUD:** create → view → edit → delete

## Anti-Patterns

| ❌ Avoid                     | ✅ Instead                     |
| ---------------------------- | ------------------------------ |
| "Create database table"      | User-facing value              |
| Missing "so that"            | Explain the benefit            |
| "I want a better experience" | Specific, actionable goal      |
| "I want a dropdown menu"     | User goal, not UI prescription |

## Template

```markdown
**ID:** PROJ-123 **Title:** Brief title

### Story

As a [user type], I want [goal], so that [benefit].

### Acceptance Criteria

- [ ] Condition 1
- [ ] Condition 2

### Notes

- Context, dependencies, technical considerations
```
