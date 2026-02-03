# next-task

**A task queue system for running AI coding agents (Claude Code / Codex) on project work.**

Run `next` in any project to pick up the next task and launch the right agent automatically.

## Why This Exists

When working with AI coding agents, you want to:
- Define work as discrete tasks with clear outputs
- Pick the right agent for each task (Claude vs Codex)
- Track progress, dependencies, and milestones
- Review artifacts at natural stopping points
- Keep a single line of git history

This tool makes that workflow seamless.

## Quick Start

```bash
# Install
cd ~/dev/next-task && ./install.sh

# Initialize a project
cd ~/dev/your-project
next init

# Edit TASKS.md with your tasks, then:
next           # Run next available task
next done      # Mark complete, commit, unblock dependents
next status    # See what's ready, blocked, in-progress
```

## Core Concepts

### Tasks Have Agents

Each task specifies which agent should run it:

```markdown
### T1: Set up project scaffolding @codex
### T2: Design sync architecture @claude
```

**When to use which:** See [docs/AGENT-SELECTION.md](docs/AGENT-SELECTION.md)

### Tasks Have Dependencies

```markdown
### T3: Implement file watcher @codex
**Depends:** T1

### T4: Build CLI commands @claude
**Depends:** T2, T3
```

`next` automatically picks only tasks whose dependencies are complete.

### Tasks Produce Artifacts

```markdown
### T3: Implement file watcher @codex
**Artifacts:** src/watcher/FileWatcher.ts, src/watcher/FileWatcher.test.ts
**Commit:** `feat: add file watcher`
```

When you run `next done`, it:
1. Optionally verifies artifacts exist
2. Commits with the specified message
3. Marks the task done
4. Unblocks dependent tasks

### Milestones Are Review Points

```markdown
## 🏁 Milestone 1: Local Agent MVP
(tasks here)

---
🎯 **Milestone 1 complete:** Can watch files and run jj commands

## 🏁 Milestone 2: Cloud Sync
(tasks here)
```

At milestones, stop and review before continuing.

### Claude Can Parallelize

```markdown
### T5: Build CLI commands @claude [use-subagents]
**Parallel sub-tasks:**
  - `weldr init` command
  - `weldr status` command  
  - `weldr sync` command
```

The `[use-subagents]` tag tells Claude to spawn sub-agents for parallel work.

## Commands

| Command | Description |
|---------|-------------|
| `next` | Run next ready task (auto-selects agent) |
| `next status` | Show task status (ready/blocked/in-progress) |
| `next done` | Mark current task complete, commit, unblock dependents |
| `next add <desc> @agent` | Add a task to Ready queue |
| `next skip` | Skip current task (move to Blocked with reason) |
| `next list` | Show full TASKS.md |
| `next init` | Initialize project with TASKS.md + AGENT.md |

## Project Structure

After `next init`:

```
your-project/
├── AGENT.md           # Context for AI agents (universal)
├── TASKS.md           # Task queue with dependencies
└── .agent/
    └── config.yml     # Default agent, validation command
```

## Documentation

- [Task Format Specification](docs/FORMAT.md)
- [Agent Selection Guide](docs/AGENT-SELECTION.md)
- [Design Decisions](docs/DESIGN-DECISIONS.md)
- [Examples](examples/)

## Installation

```bash
cd ~/dev/next-task
./install.sh
```

This installs `next` to `~/.local/bin/`. Make sure that's in your PATH.

## Integration

Works with:
- **Claude Code** (`claude` CLI)
- **Codex CLI** (`codex`)
- **CTO task-log** (auto-logs completed tasks)
- **Git** (auto-commits with specified messages)
