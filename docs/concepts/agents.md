# Agents

next-task supports multiple AI coding agents.

## Supported Agents

| Agent | Tag | Best For |
|-------|-----|----------|
| **Codex** | `@codex` | Fast execution, boilerplate, well-defined tasks |
| **Claude Code** | `@claude` | Complex reasoning, architecture, research |

## Assigning Agents

```markdown
### T1: Generate boilerplate @codex
### T2: Design system architecture @claude
```

If no agent is specified, the default from `.agent/config.yml` is used.

## Codex (`@codex`)

**Strengths:**
- Fast execution
- Good at following patterns
- Strong TypeScript support

**Best for:** Scaffolding, CRUD, tests, boilerplate

## Claude Code (`@claude`)

**Strengths:**
- Deep reasoning
- Better at ambiguous tasks
- Can use subagents

**Best for:** Architecture, research, complex debugging, large refactors

## Configuration

Set the default in `.agent/config.yml`:

```yaml
agent: codex     # Default agent
yolo: true       # Auto-approve all actions
```

## Choosing the Right Agent

| Use Codex when... | Use Claude when... |
|-------------------|-------------------|
| Task is well-defined | Task requires reasoning |
| You want speed | Exploring options |
| Pattern already exists | Complex or ambiguous |
| Boilerplate/repetitive | Needs architectural guidance |

## Example Assignment

```markdown
## Milestone 1: Setup
### T1: Initialize project @codex        # Boilerplate
### T2: Design data model @claude        # Needs thinking

## Milestone 2: Implementation  
### T3: Implement CRUD @codex           # Repetitive
### T4: Add caching layer @claude       # Complex decision
```
