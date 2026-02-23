# Installation

## Prerequisites

- **Git** — sprint uses git for state and commits
- **One or more agents:**
  - [Codex CLI](https://github.com/openai/codex) — `npm i -g @openai/codex`
  - [Claude Code](https://claude.ai/code) — `curl -fsSL https://claude.ai/install.sh | bash`

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
sprint v2: Task queue runner for AI coding agents

Usage: sprint [command]

Commands:
  (default)  Run next ready task (single task, then stop)
  loop       🔄 Ralph mode: run tasks continuously until done
  status     Show task status
  ...
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

## Next Steps

- [Quick Start](quick-start.md) — Create your first task queue
- [Concepts](/concepts/how-it-works.md) — Understand how sprint works
