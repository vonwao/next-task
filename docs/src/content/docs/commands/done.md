---
title: next done
description: Manually mark current task complete
---

## Usage

```bash
next done
next d        # Short alias
```

## Description

Marks the current in-progress task as complete. Use this when:
- Working on a task manually (not via `next run`)
- Agent finished but task wasn't auto-marked done
- Resuming after an interruption

## Behavior

1. Checks for in-progress task
2. Runs validation (if configured)
3. Commits if there are staged changes
4. Marks task as done in state.json
5. Adds ✅ marker to TASKS.md
6. Appends to LOG.md

## Output

```
Using existing commit: abc1234
✅ Completed: T3: Implement service
📝 Logged to task-log

📋 my-project — Task Status
Done: 3 | In Progress: 0 | Ready: 2 | Blocked: 1
```

## If No Task In Progress

```
No task in progress
```

Use `next run` to start a task first.

## See Also

- [next skip](/commands/skip/) — Skip without completing
- [next commit](/commands/commit/) — Commit changes mid-task
