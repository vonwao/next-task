---
title: Installation
description: How to install next-task
---

## Prerequisites

- **Git** — next-task uses git for state and commits
- **One or more agents:**
  - [Codex CLI](https://github.com/openai/codex) — `npm i -g @openai/codex`
  - [Claude Code](https://claude.ai/code) — `curl -fsSL https://claude.ai/install.sh | bash`

## Install next-task

### Option 1: Clone and Symlink (Recommended)

```bash
# Clone the repo
git clone https://github.com/vonwao/next-task.git ~/.next-task

# Add to PATH (add to your shell profile)
export PATH="$HOME/.next-task/src:$PATH"

# Or symlink
ln -s ~/.next-task/src/next /usr/local/bin/next
```

### Option 2: Download Script Directly

```bash
# Download to a directory in your PATH
curl -o /usr/local/bin/next https://raw.githubusercontent.com/vonwao/next-task/main/src/next
chmod +x /usr/local/bin/next
```

## Verify Installation

```bash
next help
```

You should see:

```
next-task v2: Task queue runner for AI coding agents

Usage: next [command]

Commands:
  (default)  Run next ready task (single task, then stop)
  loop       🔄 Ralph mode: run tasks continuously until done
  status     Show task status
  ...
```

## Agent Configuration

### Codex

Ensure you're logged in:

```bash
codex login
```

### Claude Code

Ensure you're logged in:

```bash
claude login
```

## Next Steps

- [Quick Start](/getting-started/quick-start/) — Create your first task queue
- [Concepts](/concepts/how-it-works/) — Understand how next-task works
