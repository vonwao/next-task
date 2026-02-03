# next-task

> **Turn messy AI agent sessions into clean, reviewable commits — automatically.**

Define tasks in markdown. Assign agents. Run the queue. Get clean git history.

```bash
next loop   # Runs all tasks, one clean commit each
```

[![Docs](https://img.shields.io/badge/docs-online-blue)](https://vonwao.github.io/next-task/)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

---

## The Problem

AI coding agents (Claude Code, Codex) are powerful but chaotic:
- They wander off-topic
- Progress is hard to track  
- Git history becomes a mess
- You lose time re-explaining context

## The Solution

**next-task** gives you:

```markdown
# TASKS.md

### T1: Set up project @codex
**Commit:** `chore: initialize project`

### T2: Add user authentication @claude  
**Depends:** T1
**Commit:** `feat: add auth`

### T3: Write tests @codex
**Depends:** T2
**Commit:** `test: add auth tests`
```

Then:

```bash
next loop
```

Each task → right agent → clean commit → next task. Walk away and come back to a working project with reviewable history.

---

## Quick Start

```bash
# Install
git clone https://github.com/vonwao/next-task.git ~/.next-task
export PATH="$HOME/.next-task/src:$PATH"

# Try the demo
git clone https://github.com/vonwao/next-task-demo.git
cd next-task-demo
next loop
```

## Commands

| Command | Description |
|---------|-------------|
| `next` | Run next ready task |
| `next loop` | 🔄 Run all tasks continuously |
| `next status` | Show ready / blocked / done |
| `next preview` | Dry run — show what would happen |
| `next done` | Manually mark task complete |
| `next skip` | Skip current task |

## Task Format

```markdown
### T1: Task title @agent
**Depends:** T0           # Won't run until T0 is done
**Artifacts:** src/foo.ts # Expected output (informational)
**Commit:** `feat: foo`   # Commit message

Task description. The agent sees this as its prompt.
```

**Agents:**
- `@codex` — Fast, good for well-defined tasks
- `@claude` — Better reasoning, good for complex tasks

## How It Works

```
TASKS.md          →  next picks ready task
                  →  launches assigned agent
                  →  agent does work
                  →  auto-commits with clean message
.agent/state.json →  tracks what's done
LOG.md            →  append-only history
```

State lives in files. Restarts are safe. Git tracks everything.

## Loop Mode (Ralph-style)

Inspired by the [Ralph Wiggum pattern](https://ghuntley.com/ralph/):

```bash
next loop        # Run until queue empty
next loop 5      # Max 5 iterations
next loop --push # Push after each commit
```

Kick it off and walk away. Come back to clean commits.

---

## Docs

📖 **[Full Documentation](https://vonwao.github.io/next-task/)**

- [Getting Started](https://vonwao.github.io/next-task/#/getting-started/introduction)
- [Task File Format](https://vonwao.github.io/next-task/#/concepts/task-files)
- [Loop Mode](https://vonwao.github.io/next-task/#/concepts/loop-mode)
- [Command Reference](https://vonwao.github.io/next-task/#/commands/run)

---

## Philosophy

**"Trello, but executable."**

- More structured than pure agent loops
- Less overhead than Jira
- Git as the source of truth

Perfect when you want AI to do the work but stay in control of *what* gets built and *in what order*.

---

## License

MIT
