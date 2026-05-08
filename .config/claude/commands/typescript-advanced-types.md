---
name: typescript-advanced-types
description: TypeScript advanced types — generics, conditional types, mapped types, template literals, and utility types. Use when writing complex TypeScript, generic functions, or type-level programming. Load when the user needs type inference, conditional types, or is struggling with TypeScript's type system.
---

# TypeScript Advanced Types

## Core Concepts

### 1. Generics

```typescript
function identity<T>(value: T): T {
  return value;
}
const num = identity(42); // Type: number
const str = identity("hello"); // Type: string
```

### 2. Conditional Types

```typescript
type IsString<T> = T extends string ? true : false;
type A = IsString<string>; // true
type B = IsString<number>; // false
```

### 3. Mapped Types

```typescript
type Readonly<T> = { readonly [P in keyof T]: T[P] };
type Partial<T> = { [P in keyof T]?: T[P] };
```

### 4. Template Literal Types

```typescript
type EventName = "click" | "focus" | "blur";
type EventHandler = `on${Capitalize<EventName>}`;
// "onClick" | "onFocus" | "onBlur"
```

## The Golden Rule of Generics

**If a type parameter appears only in the function signature, it's likely unnecessary.**

```typescript
// Bad - T only used in signature
function getValue<T extends 'a' | 'b'>(field: T): string { ... }

// Good - use union directly
function getValue(field: 'a' | 'b'): string { ... }
```

## Type Inference

```typescript
// Infer keyword
type ElementType<T> = T extends (infer U)[] ? U : never;
type PromiseType<T> = T extends Promise<infer U> ? U : never;

// Type guards
function isString(value: unknown): value is string {
  return typeof value === "string";
}

// Assertion functions
function assertIsString(value: unknown): asserts value is string {
  if (typeof value !== "string") throw new Error("Not a string");
}
```

## StrictOmit for Safer Property Exclusion

```typescript
// Built-in Omit doesn't validate key exists
type UserWithoutPass = Omit<User, "passwrod">; // No error on typo!

// StrictOmit validates the key
type StrictOmit<T, K extends keyof T> = Omit<T, K>;
type SafeUser = StrictOmit<User, "passwrod">; // Error!
```

## Branded Types

```typescript
type URL = string & { _brand: "url" };

const isURL = (s: unknown): s is URL => z.url().safeParse(s).success;

function fetchAPI(url: URL) {
  /* ... */
}

const url = "https://example.com";
if (isURL(url)) fetchAPI(url); // OK
```

## Zod Schema Inference

```typescript
const userSchema = z.object({
  id: z.string(),
  name: z.string(),
});

type User = z.infer<typeof userSchema>;
```
