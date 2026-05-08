---
name: react-key-prop
description: React key prop best practices. Use when rendering lists with .map(), when seeing array index used as key, or any time React list rendering is involved. Always apply when the user is mapping over arrays to render JSX elements.
---

# React: Key Prop Best Practices

**Use stable, unique IDs from your data. Never use array index for dynamic lists.**

## Use Data IDs (Preferred)

```jsx
{
  todos.map((todo) => <li key={todo.id}>{todo.text}</li>);
}
```

Ideal keys are:

- **Unique** - No two items share the same key
- **Stable** - Never changes during component lifetime
- **Predictable** - Directly tied to the data item

## Generate IDs on Data Load

When data lacks IDs, create them **once** when receiving data:

```jsx
import { nanoid } from "nanoid";

useEffect(() => {
  fetch("/api/items")
    .then((res) => res.json())
    .then((data) => {
      const itemsWithIds = data.map((item) => ({
        ...item,
        _tempId: nanoid(),
      }));
      setItems(itemsWithIds);
    });
}, []);
```

## When Index Is Acceptable (Rare)

ONLY when ALL conditions are met:

- List is absolutely static
- Items never added/removed (except at end)
- Order never changes
- Items have no internal state

## Anti-Patterns

```jsx
// ❌ Creates new key every render - destroys all components
{
  items.map((item) => <li key={Math.random()}>{item.name}</li>);
}

// ❌ Index fails when list changes
{
  items.map((item, index) => <li key={index}>{item.name}</li>);
}
```

**The bug:** Index represents position, not data identity. When positions change but indexes stay the same, React incorrectly "mutates" existing components, causing state mismatch.

## Quick Reference

| DO                                    | DON'T                         |
| ------------------------------------- | ----------------------------- |
| Use unique, stable `id` from data     | Generate `key` during render  |
| Generate IDs once at data load        | Use `index` for dynamic lists |
| Always use `key` when rendering lists | Use `useId()` for list keys   |
