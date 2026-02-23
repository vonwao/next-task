# Installation

## Prerequisites

- **Git** — sprint uses git for state and commits
- **One or more agents:**
  - [Codex CLI](https://www.npmjs.com/package/@openai/codex) — `npm i -g @openai/codex`
  - [Claude Code](https://code.claude.com/docs) — `npm i -g @anthropic-ai/claude-code`

## Install sprint

### Option 1: Clone and Symlink (Recommended)

```bash
# Clone the repo
git clone https://github.com/vonwao/sprint-cli.git ~/.sprint-cli

# Add to PATH (add to your shell profile)
export PATH="$HOME/.sprint-cli/src:$PATH"

# Or symlink
ln -s ~/.sprint-cli/src/sprint /usr/local/bin/sprint
```

### Option 2: Download Script Directly

```bash
curl -o /usr/local/bin/sprint https://raw.githubusercontent.com/vonwao/sprint-cli/main/src/sprint
chmod +x /usr/local/bin/sprint
```

## Verify Installation

```bash
sprint help
```

You should see:

```
sprint: A CLI for running AI work in short, repeatable task loops.

Usage: sprint [command]

Commands:
  (default)      Run next ready task (single task, then stop)
  add            ➕ Add a new task to TASKS.md
  loop           🔄 Run tasks continuously until done
  preview        👀 Dry run: show what would happen
  status         Show task status
  done           Mark current task complete (manual mode)
  commit         Commit changes (uses task message or custom)
  skip           Skip current task
  retry          Retry the in-progress task
  list           Show TASKS.md
  log            Show LOG.md
  reset          Clear in-progress state
  init           Initialize project
  archive        📦 Archive SPRINT.md → sprints/sprint-NN.md
  new            🌱 Create a new SPRINT.md
  ss             📊 Show compact sprint overview
  help           Show this help
```

## Agent Configuration

### Codex

```bash
codex login
```

### Claude Code

```bash
claude login
```

## Troubleshooting

### Agent not found

If `sprint run` fails with a "command not found" error for `codex` or `claude`:

1. Verify the agent is installed: `which codex` or `which claude`
2. Check that the agent binary is on your `$PATH`
3. Re-install the agent:
   - Codex: `npm i -g @openai/codex`
   - Claude Code: `npm i -g @anthropic-ai/claude-code`

### Wrong agent version

Sprint expects non-interactive (headless) execution. Make sure your agent supports:
- Codex: `codex exec` command
- Claude Code: `claude --print` flag

## Next Steps

- [Quick Start](quick-start.md) — Create your first task queue
- [Concepts](/concepts/how-it-works.md) — Understand how sprint works
