# Tasks — sprint

Dogfooding: using sprint to build sprint.

## Archived Tasks
- T1 ✅ Specs directory support `4673ecc` → sprints/sprint-03.md
- T2 ✅ Progress notifications `26ae514` → sprints/sprint-03.md
- T3 ✅ Task templates `9b22107` → sprints/sprint-03.md
- T4 ✅ Inject SPRINT.md into prompts `5794050` → sprints/sprint-03.md
- T5 ✅ Inject PROGRESS.md tail into prompts `9f8d9b5` → sprints/sprint-03.md
- T6 ✅ Runner-appended progress blocks `ffc643d` → sprints/sprint-03.md
- T7 ✅ Update next init to create SPRINT.md and PROGRESS.md `28f59a0` → sprints/sprint-03.md
- T8 ✅ Verify progress blocks work end-to-end `e12c67a` → sprints/sprint-03.md

- T9 ✅ Scope sprint-done task list to current sprint `f963680` → sprints/sprint-04.md
- T10 ✅ next sprint-status command `20b45fd` → sprints/sprint-04.md
- T11 ✅ Update next init for sprint support `6779763` → sprints/sprint-04.md
- T12 ✅ Auto-commit tracking files after each task `cd8d4c5` → sprints/sprint-04.md
- T13 ✅ sprint-done sweeps uncommitted tracking files `1ee94b1` → sprints/sprint-04.md
## Sprint 09: Harden Loop + Fix Agent Integration

> Sprint anchor: 2026-02-22
> Goal: Replace the CLAUDE.md symlink hack, add .gitignore, enrich progress blocks, explicit stop reasons.
> See SPRINT.md for full acceptance criteria.

### T14: Replace CLAUDE.md symlink with --append-system-prompt @claude ✅ (done: 2026-02-22, b596312)
**Depends:** (none)
**Artifacts:** src/sprint (modified)
**Commit:** `feat: use --append-system-prompt for claude agent context`

Replace the fragile CLAUDE.md symlink hack in `run_agent()` with Claude Code's
`--append-system-prompt` flag to inject AGENT.md content.

Current behavior (lines 479-509 of src/sprint):
1. Creates symlink `CLAUDE.md → AGENT.md` before running claude
2. Claude Code reads CLAUDE.md natively as project context
3. Guardrails + SPRINT.md prepended to user prompt
4. After agent finishes, symlink deleted
5. Bug: agent can commit the symlink

New behavior:
1. Build a system prompt string from AGENT.md content
2. Pass it via `--append-system-prompt "$(cat AGENT.md)"` flag on the claude command
3. Remove all symlink creation/cleanup code (lines 479-483, line 509)
4. Remove the `CREATED_SYMLINK` variable
5. Keep guardrails + SPRINT.md in the user prompt (they're sprint-scoped, not project-level)

The codex path stays unchanged (temp file prepend works fine).

Test: run `sprint preview` and verify it still shows task info correctly.
Verify: no CLAUDE.md file created during or after agent execution.

### T15: Add .gitignore with sensible defaults @claude ✅ (done: 2026-02-22, 5574850)
**Depends:** T14
**Artifacts:** .gitignore (new file)
**Commit:** `chore: add .gitignore`

Create a `.gitignore` file with:
```
# Safety net: CLAUDE.md was previously created as a temp symlink
CLAUDE.md

# Agent runtime artifacts
.agent/*.sock
*.tmp
```

Keep it minimal. Don't add things that aren't relevant to this project.

### T16: Add duration tracking to progress blocks @claude ✅ (done: 2026-02-22, 0299197)
**Depends:** (none)
**Artifacts:** src/sprint (modified)
**Commit:** `feat: add duration to progress blocks`

Track how long each task takes and include it in progress blocks.

Implementation:
1. In `cmd_run()`, record `SECONDS=0` (bash built-in timer) right before `run_agent`
2. After the agent finishes, capture `local duration=$SECONDS`
3. Pass duration to `append_progress()` — add a new parameter or append to the block
4. Do the same in `cmd_loop()` for each iteration
5. Update `append_progress()` to accept and display duration

Updated block format:
```
---
**[T8]** Task title — 2026-02-22 14:20 (47s)
Agent: codex | Validate: passed | Commit: abc1234
Result: completed
---
```

For durations over 60s, format as `Xm Ys` (e.g., `2m 15s`).

### T17: Add files-changed count to progress blocks @claude ✅ (done: 2026-02-22, 1f1f1fb)
**Depends:** T16
**Artifacts:** src/sprint (modified)
**Commit:** `feat: add files-changed count to progress blocks`

After a task commits, capture how many files changed and include it in the progress block.

Implementation:
1. After detecting a commit (agent or auto-commit), run:
   `git diff --stat HEAD~1 HEAD 2>/dev/null | tail -1` to get the summary line
   (e.g., "3 files changed, 45 insertions(+), 12 deletions(-)")
2. Or simpler: `git diff --name-only HEAD~1 HEAD 2>/dev/null | wc -l` for just a count
3. Pass to `append_progress()` and include in the block
4. Do this in both `cmd_run()` and `cmd_loop()`

Updated block format:
```
---
**[T8]** Task title — 2026-02-22 14:20 (47s)
Agent: codex | Validate: passed | Commit: abc1234 | Files: 3
Result: completed
---
```

### T18: Explicit stop reasons in loop mode @claude ✅ (done: 2026-02-22, c4f8952)
**Depends:** T17
**Artifacts:** src/sprint (modified)
**Commit:** `feat: explicit stop reasons in loop mode`

Make loop mode record WHY it stopped, both in terminal output and PROGRESS.md.

Current stop points in `cmd_loop()`:
1. Max iterations reached → prints "Reached max iterations" but no progress block
2. All tasks complete → prints "All tasks complete" but no progress block
3. Too many failures → prints "Too many failures" but stop reason only in terminal
4. Validation failed (at threshold) → similar

Implementation:
1. Add a `loop_stop_reason` variable
2. At each break point, set it and append a special progress block:
```
---
**[LOOP]** Stopped — 2026-02-22 14:35 (12m 30s)
Iterations: 5 | Completed: 3 | Failed: 2
Reason: failure threshold reached (3/3)
---
```
3. Track loop-level stats: total iterations, tasks completed, tasks failed
4. Record total loop duration (SECONDS from loop start)

