# next-task

> Task queue runner for AI coding agents

**Define tasks. Assign agents. Run the queue.**

## What is next-task?

**next-task** is a minimal task queue system designed for AI coding agents like Codex and Claude Code. Define your tasks in markdown, specify which agent should handle each one, and let the queue runner do the rest.

## Features

- **Explicit Task Queue** — Define tasks with clear IDs, dependencies, and expected artifacts
- **Multi-Agent Support** — Assign tasks to `@codex` or `@claude` based on their strengths
- **Loop Mode (Ralph-style)** — Run tasks continuously with `next loop`
- **Git-Native** — State lives in files and git history

## Quick Example

```markdown
# TASKS.md

### T1: Set up project @codex
**Artifacts:** package.json, tsconfig.json
**Commit:** `chore: initialize project`

Create a TypeScript Node.js project with vitest for testing.

### T2: Implement core types @codex
**Depends:** T1
**Artifacts:** src/types/index.ts
**Commit:** `feat: add core types`

Define TypeScript interfaces for Config, Task, and Result.
```

Then run:

```bash
next loop  # Run all tasks continuously
```

## Philosophy

next-task sits between fully manual coding and fully autonomous agents:

- **More structured than Ralph** — explicit task IDs, dependencies, agent assignments
- **Less overhead than Jira** — just markdown files, no server, no UI
- **Git as memory** — every task completion is a commit, progress persists in files

## Get Started

```bash
# Install
git clone https://github.com/vonwao/next-task.git ~/.next-task
export PATH="$HOME/.next-task/src:$PATH"

# Use
cd your-project
next init
# Create TASKS.md
next loop
```

[Read the full guide →](getting-started/introduction.md)
