# sprint loop

Run tasks continuously (Ralph mode).

## Usage

```bash
sprint loop [max_iterations] [--push]
```

## Examples

```bash
sprint loop           # Until all done (Ctrl+C to stop)
sprint loop 10        # Max 10 iterations
sprint loop 0 --push  # Push after each task
```

## Description

Runs tasks continuously until:
- All tasks are complete
- Max iterations reached
- Too many failures (3 consecutive)
- User presses Ctrl+C

## Failure Handling

```
⚠️  Task may have failed (exit: 1, no commit)
Retrying... (failure 1/3)
...
Too many failures (3). Stopping loop.
```

To continue:
- Fix the issue and `sprint loop` again
- `sprint skip` to skip the problematic task

See [Loop Mode](/concepts/loop-mode.md) for full guide.
