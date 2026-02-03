---
title: How It Works
description: Understanding the next-task execution model
---

## The Execution Flow

```
┌─────────────────────────────────────────────────────────────┐
│                        next run                              │
├─────────────────────────────────────────────────────────────┤
│  1. Read TASKS.md                                           │
│  2. Read .agent/state.json (what's done)                    │
│  3. Find next ready task (dependencies satisfied)           │
│  4. Build prompt (task + AGENT.md context)                  │
│  5. Run agent (codex/claude)                                │
│  6. Capture commit (agent's or auto-commit)                 │
│  7. Update state.json + LOG.md                              │
│  8. Mark task done in TASKS.md                              │
└─────────────────────────────────────────────────────────────┘
```

## Files as Memory

next-task uses files as the source of truth, not in-memory state:

| File | Purpose |
|------|---------|
| `TASKS.md` | Task definitions, marked ✅ when done |
| `.agent/state.json` | Machine-readable state (done list, in-progress) |
| `.agent/config.yml` | Configuration (default agent, yolo mode) |
| `AGENT.md` | Context injected into every prompt |
| `LOG.md` | Append-only completion history |

This means:
- **Restarts are safe** — state survives process death
- **Git tracks everything** — every completion is a commit
- **Easy debugging** — inspect files to see what happened

## Task Selection

When you run `next` or `next run`:

1. **Parse TASKS.md** — Extract all task IDs and metadata
2. **Check state.json** — Get list of completed tasks
3. **Filter by dependencies** — Task is ready if all `Depends:` tasks are done
4. **Pick first ready task** — Tasks are processed in file order

### Example

```markdown
### T1: Setup @codex ✅ (done)
### T2: Types @codex        ← Ready (T1 done)
**Depends:** T1
### T3: Logic @claude       ← Blocked (T2 not done)
**Depends:** T2
```

## Prompt Construction

When a task runs, the prompt sent to the agent includes:

1. **AGENT.md** (if exists) — project context, build commands
2. **Task description** — everything between the task header and next task
3. **Commit message hint** — `Commit with: "feat: add types"`

The agent sees a focused prompt, not the entire TASKS.md file.

## Agent Execution

Depending on the assigned agent:

### Codex (`@codex`)
```bash
codex exec --dangerously-bypass-approvals-and-sandbox "prompt"
```
- Non-interactive mode
- Full auto-approval (yolo)
- Exits when done

### Claude (`@claude`)
```bash
claude --print --dangerously-skip-permissions "prompt"
```
- Print mode (non-interactive)
- Permission bypass
- Returns output

## Commit Tracking

next-task tracks commits intelligently:

1. **Before agent runs** — capture current HEAD
2. **After agent runs** — capture new HEAD
3. **If HEAD changed** — agent committed, record that hash
4. **If HEAD unchanged** — try auto-commit with `TASK_COMMIT` message
5. **Record hash** — stored in state.json and LOG.md

This prevents the "double commit" problem where both agent and runner commit.

## Loop Mode

`next loop` wraps the single-task flow in a while loop:

```bash
while tasks_remaining; do
  next run
  sleep 1
done
```

With additions:
- **Failure handling** — retry up to 3 times, then stop
- **Max iterations** — optional limit
- **Push after each** — optional `--push` flag

See [Loop Mode](/concepts/loop-mode/) for details.
