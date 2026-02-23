# sprint

> **Short loops. Real progress.**

Not sprint planning. Not Jira. Sprint is a CLI for running AI work in focused loops.

```bash
sprint loop   # Runs all tasks, one clean commit each
```

[![Docs](https://img.shields.io/badge/docs-online-blue)](https://vonwao.github.io/sprint-cli/)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

---

## The Problem

AI coding agents (Claude Code, Codex) are powerful but chaotic:
- They wander off-topic
- Progress is hard to track
- Git history becomes a mess
- You lose time re-explaining context

## The Solution

**sprint** gives you:

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
sprint loop
```

Each task → right agent → clean commit → next task. Walk away and come back to a working project with reviewable history.

---

## Quick Start

```bash
# Install
git clone https://github.com/vonwao/sprint-cli.git ~/.sprint-cli
export PATH="$HOME/.sprint-cli/src:$PATH"

# Try the demo
git clone https://github.com/vonwao/sprint-cli-demo.git
cd sprint-cli-demo
sprint loop
```

## Commands

| Command | Description |
|---------|-------------|
| `sprint` | Run next ready task |
| `sprint loop` | Run all tasks continuously |
| `sprint status` | Show ready / blocked / done |
| `sprint preview` | Dry run — show what would happen |
| `sprint done` | Manually mark task complete |
| `sprint skip` | Skip current task |

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
TASKS.md          →  sprint picks ready task
                  →  launches assigned agent
                  →  agent does work
                  →  auto-commits with clean message
.agent/state.json →  tracks what's done
LOG.md            →  append-only history
```

State lives in files. Restarts are safe. Git tracks everything.

## Loop Mode

Inspired by the [Ralph Wiggum pattern](https://ghuntley.com/ralph/):

```bash
sprint loop        # Run until queue empty
sprint loop 5      # Max 5 iterations
sprint loop --push # Push after each commit
```

Kick it off and walk away. Come back to clean commits.

---

## Docs

📖 **[Full Documentation](https://vonwao.github.io/sprint-cli/)**

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
