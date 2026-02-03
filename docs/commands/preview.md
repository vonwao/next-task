# next preview

Dry run — show what would happen without doing anything.

## Usage

```bash
next preview
next p
```

## Output

```
Would run next ready task:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Task:      T3: Add authentication @codex
Agent:     codex
Depends:   T1, T2
Artifacts: src/auth/
Commit:    feat: add auth
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Description:
Implement JWT-based authentication...

Run 'next' or 'next run' to execute this task.
```

## When to Use

- Before running unfamiliar tasks
- Verifying the right task will be picked
- Understanding what dependencies are satisfied
- Reviewing task details before execution
