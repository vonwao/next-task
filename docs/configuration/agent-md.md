# AGENT.md

Context file injected into every prompt.

## Purpose

Tell agents:
- How to build/run the project
- What patterns to follow
- What to avoid

## Location

```
AGENT.md    # Project root
```

## What to Include

```markdown
# AGENT.md

## Project
TypeScript REST API with PostgreSQL.

## Commands
- Build: `pnpm build`
- Test: `pnpm test`
- Dev: `pnpm dev`

## Structure
- `src/routes/` — API endpoints
- `src/services/` — Business logic
- `src/repos/` — Database access

## Patterns
- Use Zod for request validation
- Use the Result type for error handling
- Follow existing patterns in similar files

## Avoid
- Don't use `any` types
- Don't skip error handling
- Don't modify package.json without noting it
```

## Keep It Brief

~60 lines max. A bloated AGENT.md:
- Uses precious context tokens
- Dilutes important information
- Gets ignored by agents
