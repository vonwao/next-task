# Guardrails

Project-specific rules injected into every agent prompt.

## Location

```
.agent/guardrails.md
```

## Purpose

When agents repeatedly make the same mistake, add a guardrail:

```markdown
## Guardrails

- Don't modify files in vendor/
- Always run `pnpm typecheck` before committing
- Use the existing logger from src/utils/logger.ts
- Don't add new dependencies without noting it
```

## How It Works

When `next run` or `next loop` executes a task:

1. Load AGENT.md (if exists)
2. Load .agent/guardrails.md (if exists)
3. Append task description
4. Send to agent

The agent sees guardrails as part of its context.

## Best Practices

### Keep It Short
~20-30 lines max. Too many rules dilute the important ones.

### Be Specific
```markdown
# ❌ Too vague
- Write good code

# ✅ Specific
- Use async/await, not callbacks
- All API routes need error handling
```

### Add Rules Reactively
Don't preemptively add every rule. When an agent makes a mistake:
1. Fix the issue
2. Add a guardrail to prevent it next time
3. Run `next retry`

This is the "tuning like a guitar" approach from the Ralph methodology.
