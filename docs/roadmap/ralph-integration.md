# Ralph Integration

Roadmap for features inspired by the [Ralph Wiggum pattern](https://ghuntley.com/ralph/).

## Background

Ralph is a technique for autonomous AI coding:

```bash
while :; do cat PROMPT.md | claude-code ; done
```

**Key insight**: Files and git are memory, not context.

## What We've Implemented

- ✅ **`next loop`** — Continuous execution
- ✅ **Commit tracking** — Captures agent commits correctly
- ✅ **`next commit`** — Manual checkpoint command

## Proposed Features

### P1: Guardrails File

A file with learned lessons injected into every prompt:

```
.agent/guardrails.md
```

```markdown
## Guardrails
- Don't modify files in vendor/
- Always run `pnpm typecheck` before committing
```

### P2: Specs Directory

Separate detailed specs, one per feature:

```
specs/
├── auth.md
├── file-watcher.md
└── sync-protocol.md
```

### P2: Backpressure Config

Validation commands that must pass:

```yaml
validate:
  - pnpm typecheck
  - pnpm test --run
```

### P3: Planning Mode

Gap analysis that compares specs to code:

```bash
next plan    # Generate/update TASKS.md from specs
```

### P4: Subagent Support

For large tasks, spawn parallel subagents (Claude-only):

```markdown
### T5: Research API options @claude [use-subagents]
```

## Priority

| Feature | Value | Effort | Priority |
|---------|-------|--------|----------|
| Guardrails | High | Low | **P1** |
| Specs dir | Medium | Low | **P2** |
| Backpressure | High | Medium | **P2** |
| Planning mode | Medium | High | **P3** |
| Subagents | Low | Medium | **P4** |

## References

- [ghuntley.com/ralph](https://ghuntley.com/ralph/)
- [awesome-ralph](https://github.com/snwfdhmp/awesome-ralph)
- [how-to-ralph-wiggum](https://github.com/ghuntley/how-to-ralph-wiggum)
