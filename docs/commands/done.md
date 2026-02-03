# next done

Manually mark current task complete.

## Usage

```bash
next done
next d        # Short alias
```

## When to Use

- Working on a task manually
- Agent finished but task wasn't auto-marked done
- Resuming after an interruption

## Behavior

1. Checks for in-progress task
2. Runs validation (if configured)
3. Commits if there are staged changes
4. Marks task as done
