# Sprint 08 — Memory & Sprint Awareness

**Date:** 2026-02-18
**Principle:** Queue-first. TASKS.md is human-curated. No agent self-direction.

## Goal

Make next-task smarter over time without changing the core model:
- Cross-iteration memory via PROGRESS.md (the Ralph idea, done right)
- Sprint scoping via SPRINT.md injection
- Deterministic runner-written progress blocks (not agent-dependent)
- Backward compatible: repos without these files work exactly as before

## Non-goals

- No agent writing/amending TASKS.md during execution
- No beads integration
- No new commands
- No new config knobs
- No parallel agent orchestration

## Acceptance Criteria

1. If `PROGRESS.md` exists, `build_prompt()` includes a tail of it (last ~50 lines) at the end of the prompt
2. If `SPRINT.md` exists, it is included in the effective prompt context before the task body (implementation may occur in `build_prompt()` and/or `run_agent()`)
3. `next init` creates starter `SPRINT.md` and `PROGRESS.md` templates (without overwriting existing)
4. After every task attempt or manual task-state action, the runner appends a structured progress block to `PROGRESS.md`:
   - `cmd_run()` and `cmd_loop()` attempts (success/failure)
   - `cmd_done()`, `cmd_skip()`, and `cmd_retry()` actions
5. `bash -n src/next` passes
6. Existing repos without SPRINT.md/PROGRESS.md behave identically to before

## Prompt Context Order

```
AGENT.md              (project brain — stable context)
.agent/guardrails.md  (if present — project rules)
SPRINT.md             (if present — current sprint scope)
--- task prompt ---   (task title + description + spec + artifacts + commit hint)
tail(PROGRESS.md)     (if present — last ~50 lines of iteration memory)
```

## Progress Block Format

Each runner-appended block looks like:

```
---
**[T4]** Add PROGRESS.md injection — 2026-02-18 14:20
Agent: codex | Validate: passed | Commit: abc1234
Result: completed
Notes: Added tail injection to build_prompt(), 50 line default
---
```
