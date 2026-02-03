---
title: Task Files
description: The TASKS.md format specification
---

## Overview

Tasks are defined in a `TASKS.md` file at the root of your project. It's just markdown with a specific structure that next-task can parse.

## Basic Structure

```markdown
# Tasks — project-name

Optional description of the project.

## Milestone 1: Foundation

### T1: Task title @agent
**Depends:** (none)
**Artifacts:** file1.ts, file2.ts
**Commit:** `commit message here`

Task description goes here. Can be multiple paragraphs.

Include any details the agent needs:
- Requirements
- Constraints  
- Examples

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
| `T<id>` | Yes | Task ID (T1, T2, T2a, T_setup, etc.) |
| `<title>` | Yes | Human-readable task name |
| `@<agent>` | No | Agent assignment (codex, claude) |
| `[flags]` | No | Special flags like `[research]`, `[manual]` |

### Examples

```markdown
### T1: Initialize project @codex
### T2: Design API schema @claude [research]
### T3: Manual review [manual]
### T2a: Subtask of T2 @codex
```

## Metadata Fields

All metadata fields are optional:

### Depends

```markdown
**Depends:** T1
**Depends:** T1, T2
**Depends:** (none)
```

Task won't be picked until all dependencies are marked done.

### Artifacts

```markdown
**Artifacts:** src/types.ts
**Artifacts:** src/auth/, tests/auth.test.ts
```

Hint for what files the task should create/modify. Informational only — not enforced.

### Commit

```markdown
**Commit:** `feat: add authentication`
```

Commit message to use if auto-committing. The backticks are optional but recommended for clarity.

## Task Description

Everything between the task header and the next `###` or `##` is the task description:

```markdown
### T1: Build the thing @codex
**Artifacts:** src/thing.ts

This is the task description. It can include:

- Bullet points
- Code examples
- Multiple paragraphs

The agent receives all of this as context.

### T2: Next task
```

## Milestones (Optional)

Use `##` headers to group tasks:

```markdown
## Milestone 1: Setup

### T1: Initialize @codex
### T2: Add deps @codex

## Milestone 2: Core Features

### T3: Implement auth @claude
### T4: Add API routes @codex
```

Milestones are purely organizational — they don't affect execution order.

## Marking Tasks Done

When a task completes, next-task adds a marker:

```markdown
### T1: Initialize project @codex ✅ (done: 2026-02-03, abc1234)
```

This is added in-place — the task stays where it is in the file.

## Flags

### `[research]`

Indicates a research/analysis task rather than implementation:

```markdown
### T5: Research auth options @claude [research]
```

Currently informational, but may affect prompting in the future.

### `[manual]`

Skip this task in automated runs:

```markdown
### T10: Deploy to production [manual]
```

### `[use-subagents]`

Hint to use parallel subagents (Claude-specific):

```markdown
### T6: Analyze codebase @claude [use-subagents]
```

## Complete Example

```markdown
# Tasks — my-api

REST API for todo management.

## Milestone 1: Foundation

### T1: Project scaffolding @codex
**Artifacts:** package.json, tsconfig.json, src/
**Commit:** `chore: initialize project`

Set up a TypeScript Node.js project:
- Express.js for HTTP
- Vitest for testing
- ESLint + Prettier

### T2: Core types @codex
**Depends:** T1
**Artifacts:** src/types/index.ts
**Commit:** `feat: add core types`

Define types:
- Todo { id, title, completed, createdAt }
- CreateTodoInput { title }
- UpdateTodoInput { title?, completed? }

## Milestone 2: API Routes

### T3: GET /todos @codex
**Depends:** T2
**Artifacts:** src/routes/todos.ts
**Commit:** `feat: GET /todos endpoint`

Return all todos as JSON array.

### T4: POST /todos @codex
**Depends:** T3
**Artifacts:** src/routes/todos.ts
**Commit:** `feat: POST /todos endpoint`

Create a new todo. Validate input.
```
