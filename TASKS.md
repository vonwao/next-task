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

### T3: Task templates @codex
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
