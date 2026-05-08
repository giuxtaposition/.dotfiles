---
name: react-use-callback
description: React useCallback best practices — when to use it, when to skip it, and how memoization affects child renders. Use when the user adds useCallback, passes callbacks to child components, or discusses React performance. Load when seeing useCallback in code being reviewed or written.
---

# React: useCallback Best Practices

**useCallback caches a function definition until dependencies change.**
Only use for specific performance optimizations - not by default.

## When to Use useCallback

### 1. Passing Callbacks to Memoized Children

```jsx
const ExpensiveChild = memo(function ExpensiveChild({ onClick }) {
  return <button onClick={onClick}>Click me</button>;
});

function Parent({ productId }) {
  const handleClick = useCallback(() => {
    console.log("Clicked:", productId);
  }, [productId]);

  return <ExpensiveChild onClick={handleClick} />;
}
```

### 2. Custom Hook Return Values

```jsx
function useRouter() {
  const { dispatch } = useContext(RouterStateContext);

  const navigate = useCallback(
    (url) => {
      dispatch({ type: "navigate", url });
    },
    [dispatch],
  );

  return { navigate };
}
```

### 3. Reducing State Dependencies

```jsx
// Before: todos is a dependency
const handleAddTodo = useCallback(
  (text) => {
    setTodos([...todos, { id: nextId++, text }]);
  },
  [todos],
);

// After: No dependency needed
const handleAddTodo = useCallback((text) => {
  setTodos((todos) => [...todos, { id: nextId++, text }]);
}, []);
```

## When NOT to Use useCallback

- Child is not wrapped in `memo()`
- Coarse interactions (page navigation)
- When restructuring code is better (JSX children, local state)

## Anti-Patterns

```jsx
// Missing dependency array - new function every render
const handleClick = useCallback(() => doSomething()); // BAD

// Can't call hooks in loops
items.map((item) => {
  const handleClick = useCallback(() => {}, [item]); // BAD
});
```

## useCallback vs useMemo

| Hook                      | Caches                     |
| ------------------------- | -------------------------- |
| `useCallback(fn, deps)`   | The function itself        |
| `useMemo(() => fn, deps)` | Result of calling function |
