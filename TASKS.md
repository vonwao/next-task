# Tasks — next-task

Dogfooding: using next-task to build next-task.

## P2: Medium Priority Features

### T1: Specs directory support @codex ✅ (done: 2026-02-03, 4673ecc)
**Artifacts:** src/next (modified)
**Commit:** `feat: add specs directory support`

Add support for external spec files referenced in tasks.

When a task has `**Spec:** specs/foo.md`, load that file's content and include it in the prompt sent to the agent.

Implementation:
1. In `parse_task()`, extract TASK_SPEC from the task body (similar to TASK_ARTIFACTS)
2. In `build_prompt()`, if TASK_SPEC is set and the file exists, append its contents to the prompt
3. Handle missing spec files gracefully (warn but continue)

Example task format:
```
**Spec:** specs/auth.md
```

Test by creating a specs/test.md and a task that references it.

### T2: Progress notifications @codex ✅ (done: 2026-02-03, 26ae514)
**Depends:** T1
**Artifacts:** src/next (modified)
**Commit:** `feat: add progress notifications`

Add desktop notifications when tasks complete or fail.

On macOS, use osascript:
```bash
osascript -e 'display notification "T5 complete" with title "next-task"'
```

On Linux, use notify-send if available:
```bash
notify-send "next-task" "T5 complete"
```

Implementation:
1. Add a `notify()` function that detects OS and sends appropriate notification
2. Call notify() after task completion in cmd_run and cmd_loop
3. Call notify() on failure with different message
4. Add config option `notifications: true/false` in .agent/config.yml (default: true)

### T3: Task templates @codex ✅ (done: 2026-02-18, 9b22107)
**Depends:** T2
**Artifacts:** src/next (modified), templates/
**Commit:** `feat: add task templates`

Add `next add` command to quickly add tasks from templates.

Usage:
```bash
next add "Implement user auth" @claude
next add "Add tests for auth" @codex --depends T5
```

Implementation:
1. Add `cmd_add()` function
2. Parse arguments: description, @agent tag, --depends flag
3. Generate task ID (find highest existing T<n>, increment)
4. Append task to TASKS.md with proper formatting
5. Include optional template expansion (if templates/default.md exists)

Template format (templates/default.md):
```
{{ID}}: {{TITLE}} @{{AGENT}}
Depends: {{DEPENDS}}
Artifacts:
Commit: {{COMMIT_PREFIX}}: {{TITLE_LOWER}}
{{DESCRIPTION}}
```

---

## Sprint 08: Memory & Sprint Awareness

> Sprint anchor: 2026-02-18
> Goal: Make loop mode smart over time without changing the queue model.
> See SPRINT.md for full acceptance criteria.

### T4: Inject SPRINT.md into prompts @claude ✅ (done: 2026-02-18, 5794050)
**Depends:** (none)
**Artifacts:** src/next (modified)
**Commit:** `feat: inject sprint context into prompts`

In `build_prompt()`, if `SPRINT.md` exists at the project root, include its contents
in the prompt between the guardrails section and the task section.

Implementation:
1. Add SPRINT context injection in the prompt assembly path (`build_prompt()` and/or `run_agent()`), matching current architecture
2. Use a `## Sprint Context` header to separate it from the task
3. If SPRINT.md doesn't exist, skip silently (backward compatible)

The prompt order should be:
- AGENT.md (already handled in `run_agent()`)
- guardrails (already handled)
- SPRINT.md content (new)
- task title + description + spec + artifacts + commit hint (existing)
- PROGRESS.md tail (T5 will add this)

### T5: Inject PROGRESS.md tail into prompts @claude ✅ (done: 2026-02-18, 9f8d9b5)
**Depends:** T4
**Artifacts:** src/next (modified)
**Commit:** `feat: inject progress memory into prompts`

In `build_prompt()`, if `PROGRESS.md` exists, append a tail of it (last 50 lines)
to the end of the prompt so the agent has cross-iteration memory.

Implementation:
1. At the end of `build_prompt()`, check if PROGRESS.md exists
2. If so, append the last 50 lines under a `## Progress Memory` header
3. Add one instruction line: "Review the progress log above for context from previous iterations. If you learn something useful, append it to PROGRESS.md."
4. If PROGRESS.md doesn't exist, skip silently

Why tail and not full file: PROGRESS.md grows over time. Tailing keeps prompt size bounded.

### T6: Runner-appended progress blocks @claude ✅ (done: 2026-02-18, ffc643d)
**Depends:** T5
**Artifacts:** src/next (modified)
**Commit:** `feat: append structured progress blocks after task attempts`

After every task attempt (success or failure), the runner itself appends a structured
block to PROGRESS.md. This is deterministic — it happens even if the agent forgets.

Implementation:
1. Add an `append_progress()` function that writes a structured block:
   - Timestamp
   - Task ID + title
   - Agent used
   - Validation result (passed/failed/skipped)
   - Commit hash (if any)
   - Result (completed/failed/skipped)
   - Brief failure reason (if applicable)
2. Call `append_progress()` in `cmd_run()` after task completion or failure
3. Call `append_progress()` in `cmd_loop()` after each iteration
4. Call `append_progress()` in manual task-state commands: `cmd_done()`, `cmd_skip()`, and `cmd_retry()`
5. Create PROGRESS.md with a minimal header if it doesn't exist yet

Block format:
```
---
**[T4]** Task title — 2026-02-18 14:20
Agent: codex | Validate: passed | Commit: abc1234
Result: completed
---
```

### T7: Update next init to create SPRINT.md and PROGRESS.md @claude ✅ (done: 2026-02-18, 28f59a0)
**Depends:** T6
**Artifacts:** src/next (modified)
**Commit:** `feat: init creates sprint and progress templates`

Update `cmd_init()` to create starter SPRINT.md and PROGRESS.md files
alongside the existing TASKS.md, AGENT.md, config, and LOG.md.

Implementation:
1. Add SPRINT.md creation (only if not exists) with a minimal template:
   - Sprint name placeholder
   - Goal section
   - Non-goals section
   - Acceptance criteria section
2. Add PROGRESS.md creation (only if not exists) with:
   - Purpose header
   - "Current State" section
   - Marker comment for runner-appended blocks
3. Follow the same pattern as existing init (check exists, create, print green message)
