---
name: project-structure
description: Feature-based project architecture with unidirectional code flow. Use when setting up a new project, reorganizing an existing codebase, discussing folder structure, or when code organization feels messy. Load when the user is creating new features, modules, or discussing how to structure their app.
---

# Project Structure: Feature-Based Architecture

**Organize code by feature/domain, not by file type. Enforce unidirectional code flow: shared → features → app.**

## Top-Level Structure

```
src/
├── app/           # Application layer (routing, providers)
├── assets/        # Static files (images, fonts)
├── components/    # Shared UI components
├── config/        # Global configuration
├── features/      # Feature-based modules (main code)
├── hooks/         # Shared hooks
├── lib/           # Pre-configured libraries
├── stores/        # Global state stores
├── types/         # Shared TypeScript types
└── utils/         # Shared utility functions
```

## Feature Structure

```
src/features/users/
├── api/           # API requests & React Query hooks
├── components/    # Feature-scoped components
├── hooks/         # Feature-scoped hooks
├── stores/        # Feature state
├── types/         # Feature types
└── utils/         # Feature utilities
```

## Unidirectional Code Flow

```
shared → features → app
```

| From       | Can Import From      |
| ---------- | -------------------- |
| `app`      | `features`, `shared` |
| `features` | `shared` only        |
| `shared`   | Other `shared` only  |

**Features cannot import from each other.**

## Decision Guide

| Code Type                  | Location                      |
| -------------------------- | ----------------------------- |
| Route/page component       | `app/routes/`                 |
| Feature-specific component | `features/[name]/components/` |
| Reusable UI component      | `components/`                 |
| Feature API calls          | `features/[name]/api/`        |
| Shared utility             | `utils/`                      |
| Feature utility            | `features/[name]/utils/`      |
| Global state               | `stores/`                     |
| Feature state              | `features/[name]/stores/`     |

## Anti-Patterns

### Don't Use Barrel Files (index.ts)

```typescript
// src/features/users/index.ts
export * from "./components/UserList"; // Breaks tree-shaking
```

Import directly instead.

### Don't Import Across Features

```typescript
// Bad
import { UserAvatar } from "@/features/users/components/UserAvatar";

// Good - lift to shared
import { UserAvatar } from "@/components/UserAvatar";
```

### Don't Put Everything in Shared

If only one feature uses it, keep it in that feature.

## Composing Features at App Level

```typescript
// src/app/routes/dashboard/page.tsx
import { UserList } from '@/features/users/components/UserList';
import { PostList } from '@/features/posts/components/PostList';

export function DashboardPage() {
  return (
    <div>
      <UserList />
      <PostList />
    </div>
  );
}
```
