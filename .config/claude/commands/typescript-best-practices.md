---
name: typescript-best-practices
description: TypeScript best practices covering strictness, type safety, common patterns, and what to avoid. Use whenever writing or reviewing TypeScript code. Load proactively for any TypeScript file to enforce quality standards.
---

# TypeScript Best Practices

## Quick Reference

```typescript
// Type inference - let TS do the work
const name = 'Alice';

// Explicit for APIs
function greet(name: string): string { ... }

// Unknown over any
function safe(data: unknown) { ... }

// Type-only imports
import type { User } from './types';

// Const assertions
const tuple = [1, 2] as const;

// Null safety
const len = str?.length ?? 0;

// Guard clauses
if (!valid) throw new Error();
// main logic...
```

## Common Mistakes

| Mistake                       | Solution                              |
| ----------------------------- | ------------------------------------- |
| Overusing `any`               | Use `unknown`, generics, proper types |
| Not using strict mode         | Enable `"strict": true`               |
| Redundant annotations         | Trust type inference                  |
| Ignoring union types          | Use type guards                       |
| Not handling null             | Use `?.` and `??` operators           |
| Nested conditionals           | Use guard clauses                     |
| Duplicate types with Zod      | Use `z.infer<typeof schema>`          |
| Sequential independent awaits | Use `Promise.all`                     |

## Key Principles

1. **Type inference when obvious** - Let TypeScript infer simple types
2. **Explicit for public APIs** - Document function signatures clearly
3. **Unknown over any** - Use `unknown` with type guards instead of `any`
4. **Guard clauses** - Early returns reduce nesting
5. **Type-only imports** - Better tree-shaking with `import type`
