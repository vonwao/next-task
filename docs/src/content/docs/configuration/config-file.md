---
title: Config File
description: .agent/config.yml reference
---

## Location

```
.agent/config.yml
```

Created by `next init`. Project-specific configuration.

## Options

```yaml
# Default agent if not specified in task header
agent: codex    # codex | claude

# Auto-approve all agent actions (no prompts)
yolo: true      # true | false

# Validation command (run before marking done)
# validate: pnpm test
```

## Fields

### agent

Default agent for tasks without an `@agent` tag.

```yaml
agent: codex   # Fast, good for well-defined tasks
agent: claude  # Better reasoning, good for complex tasks
```

### yolo

Whether to run agents in fully autonomous mode:

- `true` — No approval prompts, agents run freely
- `false` — May pause for approvals (breaks loop mode)

```yaml
yolo: true   # Recommended for loop mode
yolo: false  # More cautious, interactive
```

### validate (coming soon)

Command to run before marking a task done:

```yaml
validate: pnpm test --run
```

If validation fails, the task won't be marked complete.

## Example

```yaml
# .agent/config.yml

agent: codex
yolo: true

# Future: backpressure validation
# validate: pnpm typecheck && pnpm test
```

## See Also

- [AGENT.md](/configuration/agent-md/) — Context injected into prompts
- [Agents](/concepts/agents/) — Choosing between Codex and Claude
