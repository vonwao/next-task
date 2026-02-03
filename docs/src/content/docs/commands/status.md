---
title: next status
description: Show task queue status
---

## Usage

```bash
next status
next s        # Short alias
```

## Description

Displays the current state of your task queue: what's done, what's ready, what's blocked.

## Output

```
📋 my-project — Task Status

Done:
  ✅ T1: Initialize project (abc1234)
  ✅ T2: Add core types (def5678)

In Progress:
  🔄 T3: Implement service

Ready:
  T4: Add API routes @codex
  T5: Write tests @codex

Blocked:
  T6: Integration tests (waiting: T4, T5)
  T7: Documentation (waiting: T6)

Done: 2 | In Progress: 1 | Ready: 2 | Blocked: 2
```

## Categories

| Status | Meaning |
|--------|---------|
| **Done** | Task completed with commit hash |
| **In Progress** | Task started but not finished |
| **Ready** | Dependencies satisfied, can run now |
| **Blocked** | Waiting on other tasks |

## See Also

- [next log](/commands/log/) — View completion history
- [next list](/commands/list/) — View raw TASKS.md
