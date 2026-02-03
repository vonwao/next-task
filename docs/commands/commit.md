# next commit

Commit changes during a task.

## Usage

```bash
next commit [message]
next c [message]
```

## Examples

```bash
next commit              # Uses task's commit message
next commit "my message" # Custom message
next c "wip: halfway"    # Short form
```

## Behavior

1. Stages all changes (`git add -A`)
2. Uses commit message from argument, task, or "wip: checkpoint"
3. Commits and reports hash
