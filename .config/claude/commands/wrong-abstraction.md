---
name: wrong-abstraction
description: Avoiding wrong abstractions — prefer duplication until patterns stabilize, apply Rule of Three before extracting. Use when the user creates a new abstraction, extracts a utility function, or refactors duplicate code. Load proactively when reviewing code that introduces new shared utilities or base classes.
---

# Avoiding Wrong Abstractions

**Prefer duplication over the wrong abstraction. Wait for patterns to emerge before abstracting.**

## The Rule of Three

Don't abstract until code appears in **at least 3 places**.

```jsx
// First occurrence - just write it
const userTotal = items.reduce((sum, item) => sum + item.price, 0);

// Second occurrence - still duplicate
const cartTotal = products.reduce((sum, p) => sum + p.price, 0);

// Third occurrence - NOW consider abstraction
const calculateTotal = (items, priceKey = "price") =>
  items.reduce((sum, item) => sum + item[priceKey], 0);
```

## When to Abstract

### ✅ Abstract When

- Same code appears in **3+ places**
- Pattern has **stabilized**
- Abstraction **simplifies** understanding
- Use cases share **identical behavior**

### ❌ Don't Abstract When

- Code only appears in 1-2 places
- Requirements are still evolving
- Use cases need **different behaviors**
- Would require parameters/conditionals for variations

## Fixing Wrong Abstractions

1. **Inline** the abstraction back into each caller
2. **Delete** the portions each caller doesn't need
3. **Accept** temporary duplication for clarity
4. **Re-extract** proper abstractions based on current understanding

## Quick Reference

| Approach | Meaning                  | When to Use              |
| -------- | ------------------------ | ------------------------ |
| **DRY**  | Don't Repeat Yourself    | After patterns stabilize |
| **WET**  | Write Everything Twice   | Default starting point   |
| **AHA**  | Avoid Hasty Abstractions | Guiding principle        |

**References:**

- [The Wrong Abstraction - Sandi Metz](https://sandimetz.com/blog/2016/1/20/the-wrong-abstraction)
- [AHA Programming - Kent C. Dodds](https://kentcdodds.com/blog/aha-programming)
