---
title: Loop Mode
description: Ralph-style continuous execution
---

## What is Loop Mode?

Loop mode runs tasks continuously until the queue is empty. Inspired by the [Ralph Wiggum pattern](https://ghuntley.com/ralph/), it lets you kick off work and walk away.

```bash
next loop
```

## How It Works

```
┌─────────────────────────────────────────┐
│            next loop                     │
├─────────────────────────────────────────┤
│  while tasks_remaining:                  │
│    1. Find next ready task              │
│    2. Run agent                         │
│    3. Commit & mark done                │
│    4. Brief pause                       │
│    5. Repeat                            │
└─────────────────────────────────────────┘
         ↓
   🎉 All tasks complete!
```

## Usage

```bash
# Run until all tasks complete (Ctrl+C to stop)
next loop

# Run max 10 iterations
next loop 10

# Run and push after each task
next loop 0 --push

# Run 5 iterations with push
next loop 5 --push
```

## Failure Handling

Loop mode handles failures gracefully:

1. **Task fails** (non-zero exit, no commit)
2. **Retry** up to 3 times
3. **If still failing**, stop the loop
4. **Human intervention**: run `next skip` to move on, or fix manually

```
⚠️  Task may have failed (exit: 1, no commit)
Retrying... (failure 1/3)

⚠️  Task may have failed (exit: 1, no commit)
Retrying... (failure 2/3)

⚠️  Task may have failed (exit: 1, no commit)
Too many failures (3). Stopping loop.
Run 'next skip' to skip this task, or 'next reset' to clear state.
```

## Resuming In-Progress Tasks

If a task was marked in-progress (loop was interrupted), loop mode resumes it:

```
════════════════════ ITERATION 1 ════════════════════

Resuming in-progress task: T5
Task: T5: Implement auth
Agent: claude
```

## When to Use Loop Mode

### ✅ Good for:
- **Overnight runs** — start before bed, check in the morning
- **Well-defined task queues** — clear specs, minimal ambiguity
- **Milestone sprints** — "finish all of Milestone 2"
- **Parallel development** — agents work while you do other things

### ⚠️ Use with caution:
- **Early project stages** — specs might be unclear
- **High-risk changes** — maybe review each commit
- **Unfamiliar codebases** — agent might make wrong assumptions

## Best Practices

### 1. Start Small

Don't loop through 50 tasks on the first try:

```bash
# Test with a few tasks first
next loop 3

# Check the results
git log --oneline -5

# If good, continue
next loop
```

### 2. Use Max Iterations

Limit iterations until you trust the setup:

```bash
next loop 10  # Cap at 10, review, continue
```

### 3. Push Regularly

If running for hours, push to avoid losing work:

```bash
next loop 0 --push
```

### 4. Monitor Progress

In another terminal:

```bash
watch -n 30 'next status'
```

Or check the log:

```bash
tail -f LOG.md
```

### 5. Have an AGENT.md

Provide context that persists across iterations:

```markdown
# AGENT.md

## Project
TypeScript Express API with PostgreSQL.

## Commands
- Build: `pnpm build`
- Test: `pnpm test`
- Lint: `pnpm lint`

## Patterns
- Use the existing logger in src/utils/logger.ts
- Follow the repository pattern in src/repos/
```

## Comparison with Ralph

| Aspect | next loop | Pure Ralph |
|--------|-----------|------------|
| Task selection | Explicit queue order | Agent picks "most important" |
| Dependencies | Enforced | Agent figures out |
| Stopping | Queue empty or max iterations | Manual Ctrl+C |
| State | state.json | IMPLEMENTATION_PLAN.md |
| Context | AGENT.md | AGENTS.md (~60 lines) |

next-task's loop mode is more structured — you define the order, the loop executes. Ralph is more autonomous — the agent decides what's next based on gap analysis.

## Troubleshooting

### Loop stops immediately

Check `next status` — if no tasks are ready (all blocked or done), the loop exits.

### Task keeps failing

1. Check what the agent is doing: `git diff`
2. Run the task manually: `next run`
3. If fundamentally broken, `next skip` and fix later
4. Add guardrails to AGENT.md for future runs

### Lost progress

Loop mode commits after each task. If interrupted mid-task:

```bash
git status           # Check for uncommitted changes
git stash           # Save if needed
next reset          # Clear in-progress state
next loop           # Resume
```
