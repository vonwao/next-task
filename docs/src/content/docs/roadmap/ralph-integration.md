---
title: Ralph Integration
description: Roadmap for Ralph-inspired features in next-task
---

import { Aside } from '@astrojs/starlight/components';

<Aside type="note">
This is a living document tracking potential features inspired by the [Ralph Wiggum pattern](https://ghuntley.com/ralph/).
</Aside>

## Background

Ralph is a technique for autonomous AI coding created by Geoffrey Huntley. The core concept:

```bash
while :; do cat PROMPT.md | claude-code ; done
```

**Key insight**: Files and git are memory, not context. Each iteration starts fresh, reads state from disk, does work, commits, exits. The loop provides continuity.

## Current State

### What We've Implemented

- ✅ **`next loop`** — Continuous execution (Ralph-style looping)
- ✅ **Commit tracking** — Captures agent commits correctly
- ✅ **`next commit`** — Manual checkpoint command

### next-task vs Ralph

| Aspect | next-task | Ralph |
|--------|-----------|-------|
| Task selection | Explicit queue (T1→T2→T3) | Agent picks "most important" |
| Dependencies | Explicit (`Depends: T1`) | Implicit (agent figures out) |
| Loop behavior | Queue-based | Continuous until spec fulfilled |
| Specifications | Inline in TASKS.md | Separate `specs/` directory |
| Guardrails | AGENT.md | AGENTS.md + prompt guardrails |
| Modes | Single mode | PLANNING vs BUILDING modes |

---

## Proposed Features

### P1: Guardrails File

**What**: A file containing learned lessons injected into every prompt.

**Ralph equivalent**: The "signs" concept — when Ralph fails a specific way, you add a sign to prevent it.

```
.agent/guardrails.md
```

**Example content**:
```markdown
## Guardrails (lessons learned)
- Don't modify files in vendor/
- Always run `pnpm typecheck` before committing
- Use the existing logger utility
```

| Pro | Con |
|-----|-----|
| Accumulates project wisdom | Can grow unbounded |
| Prevents repeat mistakes | Requires curation |
| Simple to implement | Not auto-learned |

**Gotchas**: Keep brief (~60 lines). May need size warnings.

---

### P2: Specs Directory

**What**: Separate detailed specification files, one per feature.

```
specs/
├── auth.md
├── file-watcher.md
└── sync-protocol.md
```

**TASKS.md references**:
```markdown
### T5: Implement auth @claude
**Spec:** specs/auth.md
```

| Pro | Con |
|-----|-----|
| Keeps TASKS.md clean | Another file to maintain |
| Reusable across tasks | Specs can drift from reality |

**Gotchas**: Large specs need chunking. Agent might ignore spec anyway.

---

### P2: Backpressure Config

**What**: Validation commands that must pass before task completion.

```yaml
# .agent/config.yml
validate:
  - pnpm typecheck
  - pnpm test --run
  - pnpm lint
```

| Pro | Con |
|-----|-----|
| Quality gates | Slows iteration |
| Catches regressions | Flaky tests = pain |

**Gotchas**: Agent might "fix" tests by deleting them 😅

---

### P3: Planning Mode

**What**: Gap analysis command that compares specs to code and generates tasks.

```bash
next plan                    # Analyze specs/ vs src/
next plan --from-scratch     # Regenerate TASKS.md
```

| Pro | Con |
|-----|-----|
| Auto-generates task breakdown | LLM might miss nuance |
| Catches "thought it was done" | Expensive (needs smart model) |

**Gotchas**: Gap analysis is genuinely hard. May need human review.

---

### P4: Subagent Support

**What**: For large tasks, spawn parallel subagents (Claude-specific).

```markdown
### T5: Research API options @claude [use-subagents]
```

| Pro | Con |
|-----|-----|
| Massive parallelism | Only works with Claude |
| Preserves main context | Costs more tokens |

**Gotchas**: Codex has no subagents. Can hit rate limits.

---

## Implementation Priority

| Feature | Value | Effort | Priority |
|---------|-------|--------|----------|
| Guardrails file | High | Low | **P1** |
| Specs directory | Medium | Low | **P2** |
| Backpressure config | High | Medium | **P2** |
| Planning mode | Medium | High | **P3** |
| Subagent support | Low | Medium | **P4** |

---

## Open Questions

1. **Should guardrails be auto-learned?** When agent fails, prompt for learnings?
2. **Spec drift?** Should agent update specs when implementation reveals issues?
3. **Loop + planning interaction?** `next loop --replan-every 5`?
4. **Multi-agent orchestration?** Switch agents based on task complexity?

---

## References

- [Ralph Wiggum original post](https://ghuntley.com/ralph/)
- [Everything is a Ralph Loop](https://ghuntley.com/loop/)
- [Don't Waste Your Back Pressure](https://ghuntley.com/pressure/)
- [awesome-ralph](https://github.com/snwfdhmp/awesome-ralph)
- [how-to-ralph-wiggum](https://github.com/ghuntley/how-to-ralph-wiggum)
