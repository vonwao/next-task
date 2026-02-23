# Quick Start

Get up and running in 5 minutes.

## 1. Initialize a Project

```bash
mkdir my-project && cd my-project
git init
sprint init
```

This creates:
- `.agent/config.yml` — Configuration
- `.agent/state.json` — State tracking
- `LOG.md` — Completion history

## 2. Create TASKS.md

```markdown
# Tasks — my-project

## Milestone 1: Setup

### T1: Initialize project @codex
**Artifacts:** package.json, tsconfig.json, src/
**Commit:** `chore: initialize project`

Create a TypeScript Node.js project:
- package.json with typescript, vitest
- tsconfig.json for ES modules
- src/ directory with index.ts

### T2: Add core types @codex
**Depends:** T1
**Artifacts:** src/types.ts
**Commit:** `feat: add core types`

Define TypeScript types:
- User (id, name, email)
- Config (apiKey, baseUrl)

### T3: Implement main function @codex
**Depends:** T2
**Artifacts:** src/index.ts
**Commit:** `feat: implement main`

Create a main() function that:
- Loads config from environment
- Prints a welcome message
```

## 3. Check Status

```bash
sprint status
```

Output:
```
📋 my-project — Task Status

Ready:
  T1: Initialize project @codex

Blocked:
  T2: Add core types (waiting: T1)
  T3: Implement main function (waiting: T2)

Done: 0 | In Progress: 0 | Ready: 1 | Blocked: 2
```

## 4. Run a Single Task

```bash
sprint run
```

This will:
1. Pick the next ready task (T1)
2. Send it to Codex with full context
3. Wait for completion
4. Auto-commit with the specified message
5. Mark T1 as done

## 5. Or Run All Tasks (Loop Mode)

```bash
sprint loop
```

This runs continuously until the queue is empty. Press `Ctrl+C` to stop.

## 6. Check Progress

```bash
sprint status  # See current state
sprint log     # See completion history
git log      # See commits from each task
```

## What's Next?

- [Task Files](/concepts/task-files.md) — Learn the TASKS.md format
- [Agents](/concepts/agents.md) — Configure Codex vs Claude
- [Loop Mode](/concepts/loop-mode.md) — Ralph-style continuous execution
