# next loop

Run tasks continuously (Ralph mode).

## Usage

```bash
next loop [max_iterations] [--push]
```

## Examples

```bash
next loop           # Until all done (Ctrl+C to stop)
next loop 10        # Max 10 iterations
next loop 0 --push  # Push after each task
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
- Fix the issue and `next loop` again
- `next skip` to skip the problematic task

See [Loop Mode](/concepts/loop-mode.md) for full guide.
