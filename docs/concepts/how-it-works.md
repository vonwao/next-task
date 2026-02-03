# How It Works

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

next-task uses files as the source of truth:

| File | Purpose |
|------|---------|
| `TASKS.md` | Task definitions, marked ✅ when done |
| `.agent/state.json` | Machine-readable state |
| `.agent/config.yml` | Configuration |
| `AGENT.md` | Context injected into every prompt |
| `LOG.md` | Append-only completion history |

This means:
- **Restarts are safe** — state survives process death
- **Git tracks everything** — every completion is a commit
- **Easy debugging** — inspect files to see what happened

## Task Selection

1. **Parse TASKS.md** — Extract all task IDs and metadata
2. **Check state.json** — Get list of completed tasks
3. **Filter by dependencies** — Task is ready if all `Depends:` tasks are done
4. **Pick first ready task** — Tasks are processed in file order

## Prompt Construction

When a task runs, the prompt includes:

1. **AGENT.md** (if exists) — project context
2. **Task description** — everything between task header and next task
3. **Commit message hint** — from `**Commit:**` field

## Agent Execution

**Codex:**
```bash
codex exec --dangerously-bypass-approvals-and-sandbox "prompt"
```

**Claude:**
```bash
claude --print --dangerously-skip-permissions "prompt"
```

## Commit Tracking

1. **Before agent** — capture current HEAD
2. **After agent** — capture new HEAD
3. **If HEAD changed** — agent committed, record that hash
4. **If HEAD unchanged** — try auto-commit with `TASK_COMMIT`
