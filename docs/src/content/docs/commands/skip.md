---
title: next skip
description: Skip the current task
---

## Usage

```bash
next skip
```

## Description

Skips the current in-progress task without marking it done. The task remains in TASKS.md and will be picked up again when dependencies allow.

## When to Use

- Task is blocked by an external issue
- Agent keeps failing on this task
- You want to work on something else first
- Task needs rethinking

## Output

```
Skipped: T3: Implement service
Task is still in TASKS.md, will be picked up again when ready.

📋 my-project — Task Status
Done: 2 | In Progress: 0 | Ready: 2 | Blocked: 1
```

## See Also

- [next done](/commands/done/) — Complete the task
- [next reset](/commands/reset/) — Clear state completely
