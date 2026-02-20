# Sprint 09 — Sprint Lifecycle Commands

**Date:** 2026-02-20

## Goal

Give next-task first-class sprint lifecycle management: archive completed sprints,
start new ones cleanly, and snapshot which tasks belonged to each sprint.

## Current State (end of Sprint 08)

All Sprint 08 tasks complete (T1–T8). The tool has:
- SPRINT.md and PROGRESS.md injection into agent prompts
- Runner-appended progress blocks after every task
- `next init` creates all files including SPRINT.md and PROGRESS.md
- `next add` for quick task creation

Just added manually (this session, not via task loop):
- `next sprint-done` (alias: `sd`) — archives SPRINT.md → sprints/sprint-NN.md, appends completed task IDs, commits
- `next sprint-new` (alias: `sn`) — creates a fresh SPRINT.md from template, no auto-numbering

## What We're Building (T9+)

1. **`next sprint-done` task scoping** — currently appends ALL done task IDs; should only include IDs completed since the previous sprint archive date (use log[] timestamps)
2. **`next sprint-status`** — show active sprint title, task counts (done/remaining/blocked), last completed task
3. **`next init` update** — create `sprints/` directory stub and mention sprint commands in init output

## What NOT to Do

- Don't change the core queue model (TASKS.md is human-curated, agents don't write it)
- Don't add anything stateful beyond `.agent/state.json`
- Don't break backward compat for repos without SPRINT.md

## Key Files

- `src/next` — entire CLI, one bash script (~1450 lines)
- `.agent/state.json` — tracks done[], inProgress, log[] with timestamps
- `sprints/` — archive directory, created by sprint-done
