---
title: Introduction
description: What is next-task and why use it?
---

**next-task** is a task queue runner for AI coding agents. It provides a simple, file-based way to define work and let agents execute it.

## The Problem

AI coding agents like Codex and Claude Code are powerful, but they work best with clear, scoped tasks. Without structure, they can:

- Wander off-topic and build the wrong thing
- Lose context on what's already done
- Make it hard to track progress

## The Solution

next-task gives you:

1. **A task file** (`TASKS.md`) — markdown-based, human-readable
2. **Explicit dependencies** — T2 doesn't start until T1 is done
3. **Agent assignment** — route tasks to the right tool (`@codex`, `@claude`)
4. **State tracking** — know exactly what's done, what's in progress
5. **Loop mode** — run continuously until the queue is empty

## When to Use next-task

✅ **Good fit:**
- Greenfield projects with clear milestones
- Multi-step implementations (scaffolding → types → logic → tests)
- Mixed human/AI workflows
- When you want audit trails of what was built

❌ **Not ideal for:**
- Exploration/research tasks with unclear scope
- Single quick fixes (just use the agent directly)
- Projects where you prefer the agent to figure out the plan

## How It Compares

| Tool | Style | Best For |
|------|-------|----------|
| **next-task** | Explicit queue, task-by-task | Structured builds, audit trails |
| **Ralph loops** | "Most important thing" each iteration | Spec-driven, AFK coding |
| **Direct agent** | Ad-hoc prompts | Quick fixes, exploration |
| **Cursor/IDE agents** | Inline assistance | Interactive development |

## Core Concepts

- **Task** — A unit of work with an ID, description, and optional metadata
- **Agent** — The AI tool that executes tasks (`codex` or `claude`)
- **State** — Tracked in `.agent/state.json`, survives restarts
- **Log** — Completion history in `LOG.md`

Ready to try it? Head to [Installation](/getting-started/installation/).
