# Loop Mode

Run tasks continuously until the queue is empty.

Inspired by the [Ralph Wiggum pattern](https://ghuntley.com/ralph/).

## Usage

```bash
next loop           # Run until all tasks done
next loop 10        # Max 10 iterations
next loop 0 --push  # Push after each task
```

## How It Works

```
while tasks_remaining:
  1. Find next ready task
  2. Run agent
  3. Commit & mark done
  4. Repeat
```

## Failure Handling

If a task fails 3 times in a row, the loop stops:

```
⚠️  Task may have failed (exit: 1, no commit)
Retrying... (failure 1/3)
...
Too many failures (3). Stopping loop.
Run 'next skip' to skip this task.
```

## When to Use

✅ **Good for:**
- Overnight runs
- Well-defined task queues
- Milestone sprints

⚠️ **Use with caution:**
- Early project stages
- High-risk changes
- Unfamiliar codebases

## Best Practices

### Start Small

```bash
next loop 3    # Test with a few tasks first
git log --oneline -5
next loop      # If good, continue
```

### Monitor Progress

```bash
watch -n 30 'next status'
# Or
tail -f LOG.md
```

### Have an AGENT.md

Provide context that persists across iterations:

```markdown
# AGENT.md

## Commands
- Build: `pnpm build`
- Test: `pnpm test`

## Patterns
- Use the logger from src/utils/logger.ts
- Follow the repository pattern in src/repos/
```

## Comparison with Ralph

| Aspect | next loop | Pure Ralph |
|--------|-----------|------------|
| Task selection | Explicit queue | Agent picks |
| Dependencies | Enforced | Agent figures out |
| Stopping | Queue empty | Manual Ctrl+C |
