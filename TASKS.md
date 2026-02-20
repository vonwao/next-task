# Tasks — next-task

Dogfooding: using next-task to build next-task.

## Archived Tasks
- T1 ✅ Specs directory support `4673ecc` → sprints/sprint-03.md
- T2 ✅ Progress notifications `26ae514` → sprints/sprint-03.md
- T3 ✅ Task templates `9b22107` → sprints/sprint-03.md
- T4 ✅ Inject SPRINT.md into prompts `5794050` → sprints/sprint-03.md
- T5 ✅ Inject PROGRESS.md tail into prompts `9f8d9b5` → sprints/sprint-03.md
- T6 ✅ Runner-appended progress blocks `ffc643d` → sprints/sprint-03.md
- T7 ✅ Update next init to create SPRINT.md and PROGRESS.md `28f59a0` → sprints/sprint-03.md
- T8 ✅ Verify progress blocks work end-to-end `e12c67a` → sprints/sprint-03.md

## P2: Medium Priority Features

## Sprint 08: Memory & Sprint Awareness

> Sprint anchor: 2026-02-18
> Goal: Make loop mode smart over time without changing the queue model.
> See SPRINT.md for full acceptance criteria.

## Verification: Post-Sprint 08

## Sprint 09: Sprint Lifecycle Commands

### T9: Scope sprint-done task list to current sprint @claude
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

### T10: next sprint-status command @claude
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

### T11: Update next init for sprint support @codex
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
