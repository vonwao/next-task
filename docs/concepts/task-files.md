# Task Files

Tasks are defined in `TASKS.md` at the root of your project.

## Basic Structure

```markdown
# Tasks — project-name

## Milestone 1: Foundation

### T1: Task title @agent
**Depends:** (none)
**Artifacts:** file1.ts, file2.ts
**Commit:** `commit message here`

Task description goes here. Can be multiple paragraphs.

### T2: Another task @agent
**Depends:** T1
...
```

## Task Header Format

```
### T<id>: <title> @<agent> [flags]
```

| Part | Required | Description |
|------|----------|-------------|
| `T<id>` | Yes | Task ID (T1, T2, T2a, etc.) |
| `<title>` | Yes | Human-readable name |
| `@<agent>` | No | Agent (codex, claude) |
| `[flags]` | No | Special flags |

## Metadata Fields

### Depends

```markdown
**Depends:** T1
**Depends:** T1, T2
```

### Artifacts

```markdown
**Artifacts:** src/types.ts
**Artifacts:** src/auth/, tests/auth.test.ts
```

### Commit

```markdown
**Commit:** `feat: add authentication`
```

## Marking Tasks Done

When complete, next-task adds a marker:

```markdown
### T1: Initialize project @codex ✅ (done: 2026-02-03, abc1234)
```

## Complete Example

```markdown
# Tasks — my-api

REST API for todo management.

## Milestone 1: Foundation

### T1: Project scaffolding @codex
**Artifacts:** package.json, tsconfig.json, src/
**Commit:** `chore: initialize project`

Set up a TypeScript Node.js project with Express and Vitest.

### T2: Core types @codex
**Depends:** T1
**Artifacts:** src/types/index.ts
**Commit:** `feat: add core types`

Define types: Todo, CreateTodoInput, UpdateTodoInput

## Milestone 2: API Routes

### T3: GET /todos @codex
**Depends:** T2
**Artifacts:** src/routes/todos.ts
**Commit:** `feat: GET /todos endpoint`

Return all todos as JSON array.
```
