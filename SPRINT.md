# Sprint 09 — Consistency & Transparency

**Date:** 2026-02-20
**Tasks:** T9–T13

## Goal

Make next-task's behavior fully consistent and transparent. After any `next` operation,
the working tree should be clean. No surprise uncommitted files, no hidden state.

## Current State (end of Sprint 08 + sprint lifecycle work)

Sprint 08 complete (T1–T8). Sprint lifecycle commands added outside the task loop:
- `next sprint-done` — archives SPRINT.md, strips done task bodies from TASKS.md, commits
- `next sprint-new` — creates fresh SPRINT.md from template

**Known inconsistency (the thing we're fixing):**
After `next loop` completes, `.agent/state.json`, `LOG.md`, `PROGRESS.md`, and `TASKS.md`
(✅ markers) are all left uncommitted. The agent commits product code, then the runner
updates tracking files — but never commits them. `sprint-done` also misses them.

This is confusing: the user sees a dirty tree after a "completed" loop, has to wonder
what's uncommitted and whether it's safe to ignore.

## What We're Building (T9–T13)

**T9** — `sprint-done` scopes the completed task list: write `sprintStartedAt` to
state.json, filter log[] entries by that timestamp. Currently lists ALL ever-done tasks.

**T10** — `next sprint-status` command: compact sprint overview (title, counts, next task,
last completed). Shows "No active sprint" when SPRINT.md is absent.

**T11** — `next init` creates `sprints/` directory + mentions sprint commands in output.

**T12** — Auto-commit tracking files after each task. After `mark_task_done` +
`mark_done_in_tasks` + `append_log` + `append_progress` in `cmd_run()`, `cmd_done()`,
`cmd_skip()` — commit `.agent/state.json`, `TASKS.md`, `LOG.md`, `PROGRESS.md` in a
`chore: tracking [Tnn]` commit. Working tree clean after every task.

**T13** — `sprint-done` sweeps any remaining uncommitted tracking files into its commit.
Safety net for manual flows and pre-T12 history. One-line fix.

## What NOT to Do

- Don't change how agents commit their own work — that stays as-is
- Don't use `--amend` to fold tracking into the agent's commit (breaks clean history)
- Don't add new config knobs — just make it work consistently by default
- Don't modify TASKS.md parsing logic (T9–T11 are runner/command changes only)

## Key Implementation Notes

The tracking commit block (T12) goes in THREE places in `src/next`:
1. `cmd_run()` — after line ~808 (after `append_progress`)
2. `cmd_done()` — after its equivalent tracking update lines
3. `cmd_skip()` — after its equivalent tracking update lines

`cmd_loop()` does NOT need it — it calls `cmd_run()` internally.

## File Reference

- `src/next` — entire CLI (~1500 lines), one bash script
- `.agent/state.json` — `done[]`, `inProgress`, `log[]` with timestamps, `sprintStartedAt`
- `LOG_FILE` = `LOG.md`, `PROGRESS_FILE` = `PROGRESS.md`, `STATE_FILE` = `.agent/state.json`
- `TASKS_FILE` = `TASKS.md`
