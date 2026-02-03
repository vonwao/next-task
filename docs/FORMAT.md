# Task Format Specification

This document defines the TASKS.md format used by `next-task`.

## File Structure

```markdown
# Tasks — Project Name

## 🏁 Milestone 1: Milestone Name

### T1: Task title @agent
**Depends:** (none)
**Artifacts:** file1.ts, file2.ts
**Commit:** `type: commit message`

Description of what needs to be done.
Can be multiple lines.

### T2: Another task @agent
**Depends:** T1
**Artifacts:** file3.ts
**Commit:** `type: another commit`

Description here.

---
🎯 **Milestone 1 complete:** Summary of what's achieved

## 🏁 Milestone 2: Next Milestone
...

## In Progress

(Tasks currently being worked on - managed by `next`)

## Done

(Completed tasks - managed by `next done`)
```

## Task Syntax

### Task Header

```markdown
### T1: Task title @agent [flags]
```

| Part | Required | Description |
|------|----------|-------------|
| `T1` | Yes | Task ID (T1, T2, etc. or descriptive like `setup-project`) |
| `Task title` | Yes | Brief description |
| `@agent` | Yes | `@claude` or `@codex` |
| `[flags]` | No | Optional flags like `[use-subagents]` |

### Metadata Fields

All fields are optional but recommended:

```markdown
**Depends:** T1, T2
**Artifacts:** src/foo.ts, src/bar.ts, docs/DESIGN.md
**Commit:** `feat: add feature X`
```

| Field | Purpose |
|-------|---------|
| `**Depends:**` | Task IDs that must be complete first |
| `**Artifacts:**` | Files/directories that must exist when done |
| `**Commit:**` | Git commit message to use |

### Task Body

Everything after the metadata until the next `###` is the task description.

```markdown
### T3: Implement file watcher @codex
**Depends:** T1
**Artifacts:** src/watcher/FileWatcher.ts
**Commit:** `feat: add file watcher`

Create a file watcher using chokidar that:
- Watches the project directory recursively
- Debounces changes (5 second delay)
- Ignores node_modules, .git, .jj
- Emits events for add/change/delete

Use the FileWatcher class pattern from the project conventions.
```

## Agent Tags

| Tag | Agent | Best For |
|-----|-------|----------|
| `@claude` | Claude Code | Architecture, multi-file refactors, complex reasoning, research |
| `@codex` | Codex CLI | Focused implementation, algorithms, TypeScript wizardry |

See [AGENT-SELECTION.md](AGENT-SELECTION.md) for detailed guidance.

## Flags

| Flag | Meaning |
|------|---------|
| `[use-subagents]` | Claude should spawn sub-agents for parallel work |
| `[research]` | Output is documentation/findings, not code |
| `[manual]` | Don't auto-run; human should do this |

### Parallel Sub-tasks

When using `[use-subagents]`:

```markdown
### T5: Build CLI commands @claude [use-subagents]
**Depends:** T2, T4
**Artifacts:** src/cli/commands/*.ts
**Commit:** `feat: CLI commands`

**Parallel sub-tasks:**
- `init` command — initialize project with jj
- `status` command — show sync state  
- `sync` command — trigger manual sync

Each command should be in its own file under src/cli/commands/.
Use commander.js for CLI parsing.
```

The `**Parallel sub-tasks:**` block tells Claude exactly what to parallelize.

## Dependencies

### Simple Dependencies

```markdown
### T2: Task two @codex
**Depends:** T1
```

T2 won't be picked by `next` until T1 is in Done.

### Multiple Dependencies

```markdown
### T5: Task five @claude
**Depends:** T2, T3, T4
```

All three must be complete before T5 is ready.

### No Dependencies

```markdown
### T1: Task one @codex
**Depends:** (none)
```

Or simply omit the Depends field.

## Milestones

Milestones group related tasks and create natural review points.

```markdown
## 🏁 Milestone 1: Foundation

### T1: ... 
### T2: ...
### T3: ...

---
🎯 **Milestone 1 complete:** Project scaffolded, file watcher works, jj integrated

## 🏁 Milestone 2: Cloud Sync

### T4: ...
```

### Milestone Behavior

- `next` will pause at milestone boundaries and prompt for review
- Use `next continue` to proceed to next milestone
- Milestones are documentation only; dependencies still control actual flow

## Artifacts

### File Artifacts

```markdown
**Artifacts:** src/watcher/FileWatcher.ts, src/watcher/index.ts
```

### Directory Artifacts

```markdown
**Artifacts:** src/cli/commands/
```

### Documentation Artifacts

```markdown
**Artifacts:** docs/JJ-API.md
```

### Artifact Verification

When running `next done`:
- If artifacts are specified, optionally verify they exist
- Missing artifacts = warning (not blocking by default)
- Use `next done --strict` to require all artifacts

## Commit Messages

Follow conventional commits:

```markdown
**Commit:** `feat: add file watcher with debouncing`
**Commit:** `docs: jj API research findings`
**Commit:** `chore: project scaffolding`
**Commit:** `fix: handle edge case in sync`
**Commit:** `refactor: extract FileWatcher class`
**Commit:** `test: add watcher unit tests`
```

`next done` will run:
```bash
git add -A
git commit -m "feat: add file watcher with debouncing"
```

## State Management

### In Progress Section

When `next` starts a task, it moves it here:

```markdown
## In Progress

### T3: Implement file watcher @codex
**Started:** 2026-02-03 11:45
...
```

Only one task can be in progress at a time.

### Done Section

When `next done` completes a task:

```markdown
## Done

### T1: Project scaffolding @codex ✅
**Completed:** 2026-02-03 10:30
**Commit:** abc1234
```

## Full Example

See [examples/weldr-v3-tasks.md](../examples/weldr-v3-tasks.md) for a complete real-world example.
