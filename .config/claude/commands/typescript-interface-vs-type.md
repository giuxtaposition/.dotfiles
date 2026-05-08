---
name: typescript-interface-vs-type
description: When to use TypeScript interface vs type alias — the definitive guide. Use whenever the user declares a new type or interface, or when there is a choice between the two. Always load when reviewing TypeScript type declarations.
---

# TypeScript: Interface vs Type

**Use `interface` until you need features from `type`.**

## When to Use Interface

- Object type definitions
- Extending other object types
- Class implementations
- Declaration merging

## When to Use Type

- Union types: `type Status = 'pending' | 'approved'`
- Mapped types: `type Readonly<T> = { readonly [K in keyof T]: T[K] }`
- Conditional types: `type NonNullable<T> = T extends null ? never : T`
- Tuple types: `type Point = [number, number]`
- Function types: `type Handler = (event: Event) => void`

## Prefer `interface extends` Over `&`

```typescript
// ✅ Preferred
interface User {
  name: string;
}

interface Admin extends User {
  permissions: string[];
}

// ❌ Avoid
type User = { name: string };
type Admin = User & { permissions: string[] };
```

### Why?

**Better Error Messages:**

```typescript
interface Base {
  id: number;
}

// Error immediately at definition
interface Extended extends Base {
  id: string; // Error: Type 'string' is not assignable to type 'number'
}
```

With intersections, errors only appear when accessing the incompatible property.

**Better Performance:**

- Interfaces are cached by name (computed once, reused)
- Intersections are recomputed every time they're used

**Reference:** [TypeScript Performance Wiki](https://github.com/microsoft/TypeScript/wiki/Performance#preferring-interfaces-over-intersections)
