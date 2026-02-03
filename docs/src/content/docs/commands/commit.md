---
title: next commit
description: Commit changes during a task
---

## Usage

```bash
next commit [message]
next c [message]      # Short alias
```

## Description

Commits current changes. Useful for checkpointing work before completing a task.

## Behavior

1. Stages all changes (`git add -A`)
2. Uses commit message from:
   - Argument (if provided)
   - Current task's `**Commit:**` field
   - Falls back to `wip: checkpoint`
3. Commits and reports hash

## Examples

```bash
# Use task's commit message
next commit

# Custom message
next commit "feat: add user model"

# Short form
next c "wip: halfway done"
```

## Output

```
Using task commit message: feat: add service
✅ Committed (abc1234)

abc1234 feat: add service
```

## If Nothing to Commit

```
Nothing to commit (working tree clean)
```

## See Also

- [next done](/commands/done/) — Complete the task
- [next run](/commands/run/) — Start a task
