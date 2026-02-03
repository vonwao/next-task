---
title: AGENT.md
description: Context file injected into every prompt
---

## Purpose

`AGENT.md` provides context that every task prompt receives. It's your place to tell agents:
- How to build/run the project
- What patterns to follow
- What to avoid

## Location

```
AGENT.md        # Project root
```

## What to Include

### Build Commands

```markdown
## Build & Run

- Build: `pnpm build`
- Dev: `pnpm dev`
- Test: `pnpm test`
- Lint: `pnpm lint`
```

### Project Context

```markdown
## Project

TypeScript Express API with PostgreSQL.

Stack:
- Express.js for HTTP
- Prisma for database
- Vitest for testing
```

### Patterns to Follow

```markdown
## Patterns

- Use the logger from `src/utils/logger.ts`
- Follow repository pattern in `src/repos/`
- All API responses use `src/utils/response.ts` helpers
```

### Things to Avoid

```markdown
## Avoid

- Don't modify files in `vendor/`
- Don't add new dependencies without noting in the task
- Don't change the database schema without a migration
```

## Keep It Brief

Following the Ralph methodology, keep AGENT.md concise — around 60 lines max. A bloated AGENT.md:
- Uses precious context tokens
- Dilutes important information
- Gets ignored by agents

## Example

```markdown
# AGENT.md

## Project
TypeScript REST API for todo management.

## Commands
- Build: `pnpm build`
- Test: `pnpm test`
- Dev: `pnpm dev`

## Structure
- `src/routes/` — API endpoints
- `src/services/` — Business logic
- `src/repos/` — Database access
- `src/types/` — TypeScript interfaces

## Patterns
- Use Zod for request validation
- Use the Result type for error handling
- Follow existing patterns in similar files

## Avoid
- Don't use `any` types
- Don't skip error handling
- Don't modify package.json without noting it
```

## How It's Used

When you run `next run` or `next loop`:

1. AGENT.md is read (if exists)
2. Prepended to the task prompt
3. Agent sees: `[AGENT.md contents]\n---\n[Task description]`

## See Also

- [How It Works](/concepts/how-it-works/) — Execution flow
- [Config File](/configuration/config-file/) — .agent/config.yml
