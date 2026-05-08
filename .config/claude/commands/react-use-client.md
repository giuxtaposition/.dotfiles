---
name: react-use-client
description: React "use client" directive — how to correctly place client boundaries in Next.js and React Server Components. Use in any Next.js App Router or RSC project when discussing server vs client components, "use client" placement, or hydration issues. Always load when working with Next.js 13+ App Router.
---

# React "use client" Directive

`"use client"` marks a **boundary** between server and client components - not a label for individual components.

**Critical Rule:** Once inside a client boundary, ALL imported components are automatically client components. Don't add `"use client"` to child components.

## Mental Model: The Fence

```
SERVER TERRITORY
┌─────────────────────────────────────┐
│ page.tsx (Server Component)         │
│   <SearchFilters />  ─────────────┐ │
│                                   │ │
│ ══════════ "use client" FENCE ════│══
│                                   ▼ │
│ CLIENT TERRITORY                    │
│ ┌─────────────────────────────────┐ │
│ │ SearchFilters.tsx ("use client")│ │
│ │   <FilterDropdown />  ← no      │ │
│ │   <PriceSlider />       directive│ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

## When to Use "use client"

Add the directive when ALL are true:

1. Component is imported by a Server Component
2. AND needs client-side features:
   - React hooks (`useState`, `useEffect`)
   - Event handlers (`onClick`, `onChange`)
   - Browser APIs (`window`, `localStorage`)

## When NOT to Use

1. Already inside a client boundary
2. Component is pure presentation
3. "Just to be safe"

## Common Mistake

```tsx
// ❌ WRONG: Redundant directive
// components/form.tsx
"use client";
import { Input } from "./input";

// components/input.tsx
("use client"); // ❌ Already a client component!
```

```tsx
// ✅ CORRECT: Single boundary
// components/form.tsx
"use client";
import { Input } from "./input";

// components/input.tsx
// No directive needed - imported by client component
```

## Decision Flowchart

```
Is this imported by a Server Component?
├─ NO → Is parent a Client Component?
│       ├─ YES → ❌ Don't add "use client"
│       └─ NO  → Check import chain
└─ YES → Does it need client features?
         ├─ NO  → ❌ Keep it server
         └─ YES → ✅ Add "use client"
```

## Best Practices

| Do                                      | Don't                          |
| --------------------------------------- | ------------------------------ |
| Place at highest necessary point        | Sprinkle on every component    |
| Keep boundary as small as possible      | Make entire pages client       |
| Let children inherit client context     | Add redundant directives       |
| Use server components for data fetching | Fetch in client when avoidable |
