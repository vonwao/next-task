---
title: Agents
description: Configuring Codex, Claude, and other AI agents
---

## Supported Agents

next-task supports multiple AI coding agents:

| Agent | Tag | Best For |
|-------|-----|----------|
| **Codex** | `@codex` | Fast execution, boilerplate, well-defined tasks |
| **Claude Code** | `@claude` | Complex reasoning, architecture, research |

## Assigning Agents

Add the agent tag to the task header:

```markdown
### T1: Generate boilerplate @codex
### T2: Design system architecture @claude
### T3: Quick fix @codex
```

If no agent is specified, the default from `.agent/config.yml` is used.

## Agent Characteristics

### Codex (`@codex`)

**Strengths:**
- Fast execution
- Good at following patterns
- Excellent for repetitive tasks
- Strong TypeScript support

**Best for:**
- Project scaffolding
- CRUD implementations
- Test writing
- Boilerplate generation
- Well-specified tasks

**Command used:**
```bash
codex exec --dangerously-bypass-approvals-and-sandbox "prompt"
```

### Claude Code (`@claude`)

**Strengths:**
- Deep reasoning
- Better at ambiguous tasks
- Handles complex refactors
- Can use subagents for parallelism

**Best for:**
- Architecture decisions
- Research tasks
- Complex debugging
- Large refactors
- Tasks requiring judgment

**Command used:**
```bash
claude --print --dangerously-skip-permissions "prompt"
```

## Configuration

Set the default agent in `.agent/config.yml`:

```yaml
agent: codex     # Default agent if not specified
yolo: true       # Auto-approve all actions
```

## Choosing the Right Agent

### Use Codex when:
- Task is well-defined with clear inputs/outputs
- You want speed over deliberation
- The pattern already exists in the codebase
- It's boilerplate or repetitive work

### Use Claude when:
- Task requires reasoning about tradeoffs
- You're exploring options (research)
- The task is complex or ambiguous
- You need architectural guidance

### Example Assignment

```markdown
## Milestone 1: Setup
### T1: Initialize project @codex        # Boilerplate
### T2: Design data model @claude        # Needs thinking

## Milestone 2: Implementation  
### T3: Implement CRUD @codex           # Repetitive
### T4: Add caching layer @claude       # Complex decision
### T5: Write tests @codex              # Pattern-based
```

## Mixed Workflows

next-task excels at mixed agent workflows:

1. **Claude plans** — T1: "Design the API schema" `@claude [research]`
2. **Codex executes** — T2-T10: Implement each endpoint `@codex`
3. **Claude reviews** — T11: "Review for edge cases" `@claude`

This leverages each agent's strengths while maintaining explicit control.
