---
name: naming-cheatsheet
description: Naming conventions for variables, functions, components, and booleans using the A/HC/LC pattern. Use when naming anything — functions, components, hooks, booleans, constants — or when reviewing code with unclear or inconsistent names. Always load when the user asks how to name something or when renaming during refactoring.
---

# Naming Cheatsheet

Language-agnostic naming conventions using the A/HC/LC pattern.

## Core Principles (S-I-D)

- **Short** - Easy to type and remember
- **Intuitive** - Reads naturally, close to common speech
- **Descriptive** - Reflects what it does/possesses efficiently

## The A/HC/LC Pattern

```
prefix? + action (A) + high context (HC) + low context? (LC)
```

| Name                   | Prefix   | Action (A) | High Context (HC) | Low Context (LC) |
| ---------------------- | -------- | ---------- | ----------------- | ---------------- |
| `getUser`              |          | `get`      | `User`            |                  |
| `getUserMessages`      |          | `get`      | `User`            | `Messages`       |
| `shouldDisplayMessage` | `should` | `Display`  | `Message`         |                  |

## Actions

| Action    | Usage                             | Example                     |
| --------- | --------------------------------- | --------------------------- |
| `get`     | Access data immediately           | `getUser`, `getFruitCount`  |
| `set`     | Set variable declaratively        | `setUser`, `setTheme`       |
| `reset`   | Return to initial state           | `resetForm`, `resetFilters` |
| `remove`  | Remove from collection (→ `add`)  | `removeFilter`              |
| `delete`  | Erase from existence (→ `create`) | `deletePost`                |
| `compose` | Create new data from existing     | `composePageUrl`            |
| `handle`  | Handle action/event               | `handleClick`               |

## Boolean Prefixes

| Prefix   | Usage                                    | Example                        |
| -------- | ---------------------------------------- | ------------------------------ |
| `is`     | Describes characteristic or state        | `isEnabled`, `isBlue`          |
| `has`    | Describes possession                     | `hasProducts`, `hasPermission` |
| `should` | Positive conditional coupled with action | `shouldUpdateUrl`              |

## Rules

1. Use English
2. Be consistent with naming convention (camelCase, etc.)
3. Avoid contractions (`onItemClick` not `onItmClk`)
4. Avoid context duplication (`MenuItem.handleClick` not `MenuItem.handleMenuItemClick`)
5. Reflect expected result (`isDisabled` not `!isEnabled`)
6. Use singular/plural correctly

## React Specifics

- `use` prefix is reserved for hooks
- Factory functions: use verb prefix (`createCartErrorResult`)
- Distinguish `error` (Error instance) from `errorMessage` (string)
