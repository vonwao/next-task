# Ralph-Inspired Features: Analysis & Roadmap

> Research and implementation plan for integrating concepts from the [Ralph Wiggum pattern](https://ghuntley.com/ralph/) into next-task.

## Background

Ralph is a technique for autonomous AI coding created by Geoffrey Huntley. The core concept:

```bash
while :; do cat PROMPT.md | claude-code ; done
```

Key insight: **Files and git are memory, not context.** Each iteration starts fresh, reads state from disk, does work, commits, exits. The loop provides continuity.

## Current State: next-task vs Ralph

| Aspect | next-task | Ralph |
|--------|-----------|-------|
| Task selection | Explicit queue (T1→T2→T3) | Agent picks "most important" |
| Dependencies | Explicit (`Depends: T1`) | Implicit (agent figures out) |
| Loop behavior | One task, then stop | Continuous until spec fulfilled |
| Specifications | Inline in TASKS.md | Separate `specs/` directory |
| State tracking | `.agent/state.json` | `IMPLEMENTATION_PLAN.md` |
| Agent assignment | Per-task (@codex, @claude) | Single agent type per loop |
| Guardrails | None currently | `AGENTS.md` + prompt guardrails |
| Modes | Single mode | PLANNING vs BUILDING modes |

### What We've Already Implemented

- ✅ **`next loop`** — Continuous execution mode (Ralph-style looping)
- ✅ **Commit tracking** — Captures agent commits correctly
- ✅ **`next commit`** — Manual checkpoint command

---

## Proposed Features

### 1. Guardrails File (`guardrails.md`)

**What**: A file containing learned lessons that gets injected into every prompt.

**Ralph equivalent**: The "signs" concept — when Ralph fails a specific way, you add a sign to prevent it next time.

**Implementation**:
```
.agent/guardrails.md   # Project-specific learnings
```

**Loaded into prompt as**:
```markdown
## Guardrails (lessons learned)
- Don't modify files in vendor/ directory
- Always run `pnpm typecheck` before committing
- Use the existing logger utility, don't create new ones
```

**Complexity**: Easy (just append file contents to prompt if exists)

**Tradeoffs**:
| Pro | Con |
|-----|-----|
| Accumulates project wisdom | Can grow unbounded (context bloat) |
| Prevents repeat mistakes | Requires manual curation |
| Simple to implement | Not automatically learned |

**Gotchas**:
- Need to keep it brief (~60 lines max per Ralph guidance)
- Should be operational, not a changelog
- May want auto-truncation or size warning

---

### 2. Specs Directory Support

**What**: Separate detailed specification files, one per feature/JTBD.

**Ralph equivalent**: `specs/*.md` — one file per "Job To Be Done" topic.

**Implementation**:
```
specs/
├── auth.md           # Authentication system spec
├── file-watcher.md   # File watching requirements
└── sync-protocol.md  # Cloud sync spec
```

**TASKS.md references**:
```markdown
### T5: Implement auth flow @claude
**Spec:** specs/auth.md
**Artifacts:** src/auth/
```

**Complexity**: Easy-Medium (parse spec reference, include in prompt)

**Tradeoffs**:
| Pro | Con |
|-----|-----|
| Keeps TASKS.md clean | Another file to maintain |
| Detailed specs don't bloat task list | Specs can drift from reality |
| Reusable across tasks | More upfront planning required |

**Gotchas**:
- Spec might be large — need to summarize or chunk
- Specs need versioning/updating as implementation reveals issues
- Agent might ignore spec and do its own thing anyway

---

### 3. Planning Mode (`next plan`)

**What**: Gap analysis command that compares specs to code and generates/updates TASKS.md.

**Ralph equivalent**: PLANNING mode — runs loop with a different prompt focused on analysis, not implementation.

**Implementation**:
```bash
next plan                    # Analyze specs/ vs src/, update TASKS.md
next plan --from-scratch     # Regenerate TASKS.md completely
```

**How it works**:
1. Load all `specs/*.md`
2. Scan `src/` for existing implementation
3. Identify gaps (what's specified but not built)
4. Generate prioritized task list
5. Write to TASKS.md (or suggest changes)

**Complexity**: Hard (requires LLM call, careful prompting)

**Tradeoffs**:
| Pro | Con |
|-----|-----|
| Auto-generates task breakdown | LLM might miss nuance |
| Catches "thought it was done" issues | Expensive (needs smart model) |
| Aligns tasks to specs | May conflict with human-written tasks |

**Gotchas**:
- Should it overwrite or merge with existing TASKS.md?
- How to handle tasks that don't map to specs?
- Needs good prompting to avoid hallucinating features
- Gap analysis is genuinely hard — may need human review

---

### 4. Backpressure Configuration

**What**: Define validation commands that must pass before a task is considered done.

**Ralph equivalent**: Tests, lints, typechecks as "gates" that reject invalid work.

**Implementation** (in `.agent/config.yml`):
```yaml
validate:
  - pnpm typecheck
  - pnpm test --run
  - pnpm lint
```

**Behavior**:
- After agent finishes, run each validation command
- If any fail, don't mark task done
- In loop mode: retry or pause for human intervention

**Complexity**: Medium

**Tradeoffs**:
| Pro | Con |
|-----|-----|
| Ensures quality gates | Slows down iteration |
| Catches regressions | Flaky tests = pain |
| Automated QA | Agent might "fix" tests wrong |

**Gotchas**:
- What if validation is slow (full test suite)?
- How many retries before giving up?
- Agent might just delete failing tests 😅
- Need option to run subset (related tests only)

---

### 5. Subagent Support (Claude-specific)

**What**: For large tasks, spawn parallel subagents for research/implementation.

**Ralph equivalent**: "Use up to 500 Sonnet subagents for searches..."

**Implementation**:
```markdown
### T5: Research API options @claude [use-subagents]
```

**Prompt addition**:
```
Use parallel subagents for:
- Researching existing code patterns (up to 10 Sonnet subagents)
- Reading documentation
- Implementing independent files

Use only 1 subagent for build/test (backpressure).
```

**Complexity**: Medium (prompt engineering, Claude-specific)

**Tradeoffs**:
| Pro | Con |
|-----|-----|
| Massive parallelism | Only works with Claude |
| Preserves main context | Costs more (more tokens) |
| Faster for large tasks | Coordination complexity |

**Gotchas**:
- Codex doesn't have subagents — need fallback behavior
- Subagent results need coordination
- Can hit rate limits fast
- Not all tasks benefit from parallelism

---

## Implementation Priority

| Feature | Value | Effort | Priority |
|---------|-------|--------|----------|
| Guardrails file | High | Low | **P1** |
| Specs directory | Medium | Low | **P2** |
| Backpressure config | High | Medium | **P2** |
| Planning mode | Medium | High | **P3** |
| Subagent support | Low | Medium | **P4** |

### Recommended Order

1. **Guardrails** — Quick win, immediately useful
2. **Specs support** — Natural extension, helps large projects
3. **Backpressure** — Quality gates, important for loop mode
4. **Planning mode** — Nice to have, complex to get right
5. **Subagents** — Claude-only, niche benefit

---

## Open Questions

1. **Should guardrails be auto-learned?**
   - When agent fails, prompt: "What should we remember for next time?"
   - Auto-append to guardrails.md
   - Risk: garbage accumulation

2. **How to handle spec drift?**
   - Specs written early, implementation reveals issues
   - Should agent update specs? Or flag inconsistencies?

3. **Loop mode + planning mode interaction?**
   - `next loop --replan-every 5` — rerun planning every N iterations?
   - Or keep them separate?

4. **Multi-agent orchestration?**
   - Some tasks better for Codex (fast, simple)
   - Some better for Claude (complex reasoning)
   - Can loop mode switch agents based on task tags?

---

## References

- [Ralph Wiggum original post](https://ghuntley.com/ralph/)
- [Everything is a Ralph Loop](https://ghuntley.com/loop/)
- [Don't Waste Your Back Pressure](https://ghuntley.com/pressure/)
- [awesome-ralph](https://github.com/snwfdhmp/awesome-ralph) — curated resources
- [how-to-ralph-wiggum](https://github.com/ghuntley/how-to-ralph-wiggum) — official playbook
- [iannuttall/ralph](https://github.com/iannuttall/ralph) — minimal implementation
