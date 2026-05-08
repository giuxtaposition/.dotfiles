---
name: react-use-state
description: React useState best practices — when to use it, how to structure state, and common pitfalls. Use when the user works with React component state, discusses local vs global state, or initializes state incorrectly. Load when reviewing React components with state management.
---

# React: useState Best Practices

## When to Use useState

| Use Case             | Example                                       |
| -------------------- | --------------------------------------------- |
| Form inputs          | `const [name, setName] = useState('')`        |
| UI state             | `const [isOpen, setIsOpen] = useState(false)` |
| Simple counters      | `const [count, setCount] = useState(0)`       |
| Local component data | `const [items, setItems] = useState([])`      |

## When NOT to Use useState

- **useRef**: Mutable values that don't trigger re-renders
- **useReducer**: Complex state logic, multiple sub-values
- **Computed values**: Calculate during render, use useMemo if expensive
- **Shared state**: Context, Zustand, TanStack Query

## Critical Rules

### 1. Never Mutate State Directly

```jsx
// BAD
obj.x = 10;
setObj(obj);
arr.push(item);
setArr(arr);

// GOOD
setObj({ ...obj, x: 10 });
setArr([...arr, item]);
```

### 2. Use Updater Function for Sequential Updates

```jsx
// BAD: Only increments by 1
setCount(count + 1);
setCount(count + 1);

// GOOD: Increments by 2
setCount((c) => c + 1);
setCount((c) => c + 1);
```

### 3. Use Initializer Function for Expensive Values

```jsx
// BAD: createTodos() runs every render
const [todos, setTodos] = useState(createTodos());

// GOOD: createTodos runs only once
const [todos, setTodos] = useState(createTodos);
```

## Common Patterns

```jsx
// Object update
setForm({ ...form, email: newEmail });

// Array operations
setItems(items.filter((i) => i.id !== id)); // Remove
setItems([...items, newItem]); // Add
setItems(items.map((i) => (i.id === id ? { ...i, done: true } : i))); // Update

// Reset with key
<Form key={version} />;
```
