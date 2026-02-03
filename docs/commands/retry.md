# next retry

Re-run the current in-progress task.

## Usage

```bash
next retry
next r
```

## When to Use

After a task fails and you've fixed the issue:

```bash
next run         # Task fails
# ... fix the problem ...
next retry       # Try again
```

## Behavior

1. Checks for in-progress task
2. Clears in-progress state
3. Runs the task again from scratch

## If No Task In Progress

```
No task in progress to retry
Use 'next run' to start a new task.
```
