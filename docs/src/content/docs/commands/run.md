---
title: next run
description: Run a single task
---

## Usage

```bash
next run
next        # Same as 'next run'
```

## Description

Runs the next ready task from the queue. This is the default command when you just type `next`.

## Behavior

1. Checks for any in-progress task (resumes if found)
2. Finds the first task where all dependencies are satisfied
3. Parses task metadata (agent, artifacts, commit message)
4. Builds prompt from task description + AGENT.md
5. Runs the assigned agent
6. Tracks commits (agent's or auto-commit)
7. Marks task as done
8. Updates state.json and LOG.md

## Output

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: T3: Implement user service @codex
Agent: codex
Artifacts: src/services/user.ts
Commit: feat: add user service
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

▶ Running Codex (non-interactive)

[... agent output ...]

Agent finished.
Agent committed: abc1234
✅ Completed: T3: Implement user service

📋 my-project — Task Status
Done: 3 | In Progress: 0 | Ready: 2 | Blocked: 1
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Task completed successfully |
| 0 | No tasks ready (all done or blocked) |
| 1 | Task already in progress (use `done` or `skip`) |

## If a Task is In Progress

```
Task already in progress: T3: Implement user service
Run 'next done' to complete it, or 'next skip' to skip.
```

This happens if:
- A previous run was interrupted
- You're running `next` in a different terminal

To resolve:
- `next done` — mark the task complete manually
- `next skip` — skip it and move on
- `next reset` — clear in-progress state (loses progress)

## See Also

- [next loop](/commands/loop/) — Run tasks continuously
- [next done](/commands/done/) — Manually complete a task
- [next status](/commands/status/) — Check queue status
