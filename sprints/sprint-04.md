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

---

## Completed Task Details

### T9: Scope sprint-done task list to current sprint @claude ✅ (done: 2026-02-20, f963680)
**Depends:** T8
**Artifacts:** src/next (modified)
**Commit:** `fix: sprint-done only lists tasks completed in current sprint`

`cmd_sprint_done()` currently appends ALL done task IDs from state to the archive.
It should only include tasks completed *since the previous sprint was archived*.

Use the log[] array in `.agent/state.json` — each entry has `taskId` and `timestamp`.
The previous sprint archive file's git commit timestamp gives the cutoff, but that's complex.
Simpler: record a sprint start timestamp in state when SPRINT.md is created or when sprint-done runs.

Implementation:
1. In `cmd_sprint_done()`, after archiving, write a `sprintStartedAt` key to state.json with the current ISO timestamp
2. In `cmd_sprint_done()`, when collecting done IDs, filter log[] entries to only those with timestamp >= state.sprintStartedAt (if present); if no sprintStartedAt, include all (backward compat)
3. On first run ever, sprintStartedAt is absent → include all done tasks (correct for first sprint)

State update helper already exists (`update_state` or similar python3 inline) — follow that pattern.

---

### T10: next sprint-status command @claude ✅ (done: 2026-02-20, 20b45fd)
**Depends:** T9
**Artifacts:** src/next (modified)
**Commit:** `feat: next sprint-status command`

Add `next sprint-status` (alias: `ss`) that shows a compact sprint overview.

Output format:
```
Sprint: Sprint 09 — Sprint Lifecycle Commands
Tasks:  3 done · 2 remaining · 0 blocked
Next:   T11: next init update @claude
Last:   T9: Scope sprint-done task list (2026-02-20)
```

Implementation:
1. Read sprint title from SPRINT.md first heading (same as sprint-done does)
2. Count done/remaining/blocked tasks using existing task-parsing logic
3. Find next ready task (reuse `find_next_task` logic)
4. Find last completed task from log[] in state.json
5. If no SPRINT.md, print a message: "No active sprint. Run: next sprint-new \"Title\""

Wire up in case statement: `sprint-status|ss) cmd_sprint_status ;;`

---

### T11: Update next init for sprint support @codex ✅ (done: 2026-02-20, 6779763)
**Depends:** T10
**Artifacts:** src/next (modified)
**Commit:** `feat: init creates sprints directory and mentions sprint commands`

Two small updates to `cmd_init()`:
1. Create `sprints/` directory with a `.gitkeep` if it doesn't exist, so the archive location is ready from day one
2. After printing the list of created files, add a section:
   ```
   Sprint commands:
     next sprint-done    Archive current sprint
     next sprint-new     Start a new sprint
     next sprint-status  Show sprint progress
   ```

Keep it brief — just a nudge so users discover sprint commands on init.

---

### T12: Auto-commit tracking files after each task @claude ✅ (done: 2026-02-20, cd8d4c5)
**Depends:** T11
**Artifacts:** src/next (modified)
**Commit:** `feat: auto-commit tracking files after each task`

After every task completes, the runner updates `.agent/state.json`, `TASKS.md` (✅ marker),
`LOG.md`, and `PROGRESS.md` — but leaves them uncommitted. This means `next loop` always
ends with a dirty working tree, which is surprising and inconsistent.

Fix: after updating all tracking files, commit them in a single follow-up commit.

**Where to add this in `src/next`:**

The tracking updates in `cmd_run()` happen at lines ~805-808:
```bash
mark_task_done "$TASK_ID" "$commit_hash"
mark_done_in_tasks "$TASK_ID" "$commit_hash"
append_log "$TASK_ID" "$TASK_TITLE" "$commit_hash"
append_progress "$TASK_ID" "$TASK_TITLE" "$TASK_AGENT" "$validate_result" "$commit_hash" "completed"
```

Immediately after these four lines, add:
```bash
# Commit tracking files (state, tasks marker, log, progress)
if git rev-parse --git-dir > /dev/null 2>&1; then
  git add "$STATE_FILE" "$TASKS_FILE" "$LOG_FILE" "$PROGRESS_FILE" 2>/dev/null
  git diff --staged --quiet 2>/dev/null || \
    git commit -m "chore: tracking [${TASK_ID}]" --no-verify 2>/dev/null
fi
```

Also apply the same pattern to `cmd_done()` and `cmd_skip()` — both update tracking files
and should commit them. Find the equivalent tracking update lines in each and add the same
block after them.

Do NOT add this to `cmd_loop()` — it calls `cmd_run()` internally so it gets it for free.

---

### T13: sprint-done sweeps uncommitted tracking files @codex ✅ (done: 2026-02-20, 1ee94b1)
**Depends:** T12
**Artifacts:** src/next (modified)
**Commit:** `fix: sprint-done commits all tracking files`

After T12, each task auto-commits its tracking files. But as a safety net, `sprint-done`
should also sweep any remaining uncommitted tracking files into its archive commit — in case
someone ran tasks before T12 was deployed, or used manual `next done`/`next skip` flows.

In `cmd_sprint_done()`, find the `git add "$archive_path" "$TASKS_FILE"` line and extend it:

```bash
git add "$archive_path" "$TASKS_FILE" "$STATE_FILE" "$LOG_FILE" "$PROGRESS_FILE" 2>/dev/null
```

That's the entire change — one line. The commit that follows already handles the rest.
