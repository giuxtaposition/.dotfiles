---
name: typescript-satisfies
description: TypeScript satisfies operator — preserves inferred type while validating against a shape. Use when the user type-casts with "as", needs both type checking and inference, or wants to validate object shapes without losing literal types. Load when reviewing TypeScript with type assertions.
---

# TypeScript: satisfies Operator

**"When you use a colon, the type BEATS the value. When you use satisfies, the value BEATS the type."** — Matt Pocock

## Type Annotation vs Satisfies

```typescript
type Route = "/products" | "/cart" | "/checkout";

// Colon - widens to union
const url1: Route = "/products";
// url1 is typed as: Route (wide)

// Satisfies - keeps literal
const url2 = "/products" satisfies Route;
// url2 is typed as: "/products" (narrow)
```

## Classic Use Case: Object Validation

```typescript
type Colors = "red" | "green" | "blue";
type RGB = [number, number, number];

// Type annotation loses specific types
const palette1: Record<Colors, string | RGB> = {
  red: [255, 0, 0],
  green: "#00ff00",
  blue: [0, 0, 255],
};
palette1.green.toUpperCase(); // Error!

// Satisfies validates AND preserves literal types
const palette2 = {
  red: [255, 0, 0],
  green: "#00ff00",
  bleu: [0, 0, 255], // Error: Typo caught!
} satisfies Record<Colors, string | RGB>;
palette2.green.toUpperCase(); // Works!
```

## When to Use What

| Style            | Result     | Use Case                           |
| ---------------- | ---------- | ---------------------------------- |
| `: Type`         | Type wins  | Need wider type for reassignment   |
| `satisfies Type` | Value wins | Need validation + narrow inference |
| `as Type`        | Lies to TS | Escape hatch (sparingly!)          |
| No annotation    | Inference  | Most common - let TS infer         |

## `as const satisfies` Pattern

```typescript
const LANG_MAP = {
  en: "1",
  cs: "2",
} as const satisfies Record<string, string>;

// LANG_MAP.en is '1' (narrow literal)
// Validated against Record<string, string>
```

## Exhaustive Checks

```typescript
type Status = "pending" | "approved" | "rejected";

const statusLabels = {
  pending: "Waiting",
  approved: "Approved",
  rejected: "Rejected",
} satisfies Record<Status, string>;

// Add new Status → TypeScript errors until you add it here
```
