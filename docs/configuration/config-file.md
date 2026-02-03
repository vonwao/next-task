# Config File

Configuration lives in `.agent/config.yml`.

## Options

```yaml
# Default agent if not specified in task header
agent: codex    # codex | claude

# Auto-approve all agent actions
yolo: true      # true | false

# Validation command (coming soon)
# validate: pnpm test
```

## Fields

### agent

Default agent for tasks without an `@agent` tag:

```yaml
agent: codex   # Fast, well-defined tasks
agent: claude  # Complex reasoning tasks
```

### yolo

Run agents in fully autonomous mode:

- `true` — No approval prompts (recommended for loop mode)
- `false` — May pause for approvals

### validate (coming soon)

Command to run before marking a task done:

```yaml
validate: pnpm test --run
```
