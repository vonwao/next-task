# next run

Run a single task.

## Usage

```bash
next run
next        # Same as 'next run'
```

## Behavior

1. Checks for in-progress task (resumes if found)
2. Finds first task with satisfied dependencies
3. Builds prompt from task + AGENT.md
4. Runs the assigned agent
5. Tracks commits
6. Marks task done

## Output

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task: T3: Implement user service @codex
Agent: codex
Artifacts: src/services/user.ts
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

▶ Running Codex (non-interactive)
...
✅ Completed: T3: Implement user service
```

## If a Task is In Progress

```
Task already in progress: T3: Implement user service
Run 'next done' to complete it, or 'next skip' to skip.
```
