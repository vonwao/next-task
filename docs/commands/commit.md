# sprint commit

Commit changes during a task.

## Usage

```bash
sprint commit [message]
sprint c [message]
```

## Examples

```bash
sprint commit              # Uses task's commit message
sprint commit "my message" # Custom message
sprint c "wip: halfway"    # Short form
```

## Behavior

1. Stages all changes (`git add -A`)
2. Uses commit message from argument, task, or "wip: checkpoint"
3. Commits and reports hash
