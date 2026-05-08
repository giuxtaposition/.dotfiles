---
name: react-useeffect-avoid
description: When NOT to use useEffect — covers derived state, event handling, and state sync anti-patterns. Use whenever the user reaches for useEffect, especially for derived state, event handling, or reacting to prop changes. Load proactively when reviewing React code that uses useEffect.
---

# React: When Not to Use useEffect

**`useEffect` is an escape hatch for synchronizing with external systems, not for state management or event handling.**

## Decision Tree

```
Need to sync with external system?
├─ Yes (browser APIs, websockets, timers) → Use useEffect
└─ No (pure React logic)
   ├─ Derived state? → Calculate during render
   ├─ User action? → Use event handler
   ├─ State reset? → Use key prop
   └─ Really need effect? → Use useState/useReducer
```

## Quick Reference

### ❌ Don't use useEffect for:

| Scenario        | Alternative                |
| --------------- | -------------------------- |
| Derived state   | Calculate during render    |
| State resets    | Use `key` prop             |
| User actions    | Event handlers             |
| List filtering  | Filter in render           |
| Browser APIs    | `useSyncExternalStore`     |
| Form submission | Direct async handler       |
| Data fetching   | React Query, SWR, Suspense |

### ✅ DO use useEffect for:

- Subscribing to external systems (websockets, browser APIs)
- Setting up timers with cleanup
- Third-party library integration
- Document title changes
- Analytics/telemetry

## React 19+

```jsx
function UserProfile({ userId }) {
  const user = use(fetchUser(userId)); // Reads promise directly
  return <div>{user.name}</div>;
}
```

**Reference:** [React Docs: You Might Not Need an Effect](https://react.dev/learn/you-might-not-need-an-effect)
