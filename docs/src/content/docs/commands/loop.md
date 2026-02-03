---
title: next loop
description: Run tasks continuously (Ralph mode)
---

## Usage

```bash
next loop [max_iterations] [--push]
```

## Arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `max_iterations` | 0 (unlimited) | Stop after N iterations |
| `--push` | false | Git push after each task |

## Examples

```bash
# Run until all tasks done (Ctrl+C to stop)
next loop

# Run max 10 iterations
next loop 10

# Run forever, push after each
next loop 0 --push

# Run 5 iterations with push
next loop 5 --push
```

## Description

Loop mode runs tasks continuously until:
- All tasks are complete
- Max iterations reached
- Too many failures (3 consecutive)
- User presses Ctrl+C

This is inspired by the [Ralph Wiggum pattern](https://ghuntley.com/ralph/) for autonomous coding.

## Output

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔄 RALPH MODE: Continuous Loop
Max iterations: 10
Press Ctrl+C to stop
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

════════════════════ ITERATION 1 ════════════════════

Task: T1: Initialize project @codex
Agent: codex

▶ Running Codex (non-interactive)
...
✅ Completed: T1: Initialize project

════════════════════ ITERATION 2 ════════════════════

Task: T2: Add core types @codex
Agent: codex
...
✅ Completed: T2: Add core types

════════════════════ ITERATION 3 ════════════════════

🎉 All tasks complete!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Loop finished after 3 iterations
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Failure Handling

If a task fails 3 times in a row, the loop stops:

```
⚠️  Task may have failed (exit: 1, no commit)
Retrying... (failure 1/3)

⚠️  Task may have failed (exit: 1, no commit)
Retrying... (failure 2/3)

⚠️  Task may have failed (exit: 1, no commit)
Too many failures (3). Stopping loop.
Run 'next skip' to skip this task, or 'next reset' to clear state.
```

To continue:
- Fix the issue and `next loop` again
- `next skip` to skip the problematic task
- `next reset` to clear state and retry

## See Also

- [Loop Mode Concept](/concepts/loop-mode/) — Full guide
- [next run](/commands/run/) — Single task execution
- [next skip](/commands/skip/) — Skip a failing task
