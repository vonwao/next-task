---
title: next init
description: Initialize a project for next-task
---

## Usage

```bash
next init
```

## Description

Sets up next-task in the current directory. Creates the necessary files and directories.

## Files Created

| File | Purpose |
|------|---------|
| `.agent/config.yml` | Configuration (default agent, yolo mode) |
| `.agent/state.json` | State tracking (done tasks, in-progress) |
| `LOG.md` | Completion history |

## Output

```
Created .agent/config.yml
Created .agent/state.json
Created LOG.md
Project initialized for next-task v2
```

## After Init

Create a `TASKS.md` file with your task queue:

```bash
next init
# Edit TASKS.md with your tasks
next status
next run
```

## See Also

- [Quick Start](/getting-started/quick-start/) — Full setup guide
- [Task Files](/concepts/task-files/) — TASKS.md format
