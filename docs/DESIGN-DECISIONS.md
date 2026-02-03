# Design Decisions

Why `next-task` works the way it does.

---

## Decision 1: Markdown for Task Files

**Choice:** Use TASKS.md (Markdown) rather than JSON/YAML/database.

**Why:**
- Human-readable and editable
- Works with any editor
- Version-controlled with the project
- AI agents can read and understand it naturally
- Easy to review in GitHub/GitLab

**Trade-off:** Parsing is slightly harder, but worth it for readability.

---

## Decision 2: Per-Task Agent Selection

**Choice:** Each task specifies its agent (`@claude` or `@codex`).

**Why:**
- Different tasks have different characteristics
- Claude is better for broad reasoning, Codex for focused implementation
- Allows mixing agents in a single project
- Makes task granularity decisions explicit

**Alternative considered:** Auto-detect based on task description.

**Why we didn't:** Too magical, hard to predict, better to be explicit.

---

## Decision 3: Dependencies as Task IDs

**Choice:** `**Depends:** T1, T2` using task IDs.

**Why:**
- Simple and unambiguous
- Easy to parse
- Clear visual reference in the file
- Supports multiple dependencies

**Alternative considered:** Implicit ordering (task 3 depends on task 2).

**Why we didn't:** Real projects have non-linear dependencies.

---

## Decision 4: Artifacts Are Documentation, Not Enforcement

**Choice:** Artifacts are listed for clarity; verification is optional.

**Why:**
- AI agents are generally good at producing what's asked
- Strict enforcement adds friction
- Sometimes tasks produce unexpected but valid outputs
- `--strict` mode available for those who want it

**Trade-off:** May miss incomplete tasks, but review catches this.

---

## Decision 5: Single Task In Progress

**Choice:** Only one task can be "In Progress" at a time.

**Why:**
- Simpler mental model
- Prevents context switching
- Clear "what am I working on?" answer
- Sub-agents handle parallelism within a task

**Alternative considered:** Multiple in-progress tasks.

**Why we didn't:** Creates confusion, defeats focused work.

---

## Decision 6: Milestones as Review Points

**Choice:** Milestones are markers, not hard gates.

**Why:**
- Natural stopping points for human review
- Don't block automation unnecessarily
- Dependencies still control actual task flow
- Flexible: can skip review if confident

**How it works:**
- `next` pauses at milestone boundaries
- `next continue` proceeds
- `next --no-pause` skips milestone pauses

---

## Decision 7: Git Commit Per Task

**Choice:** Each task completion triggers a git commit.

**Why:**
- Clear history of what each task produced
- Easy to revert a single task's changes
- Commit message is documented in task spec
- Atomic units of work

**Trade-off:** Many small commits. But that's actually good for AI-driven development where you want fine-grained rollback.

---

## Decision 8: AGENT.md as Universal Context

**Choice:** Projects use AGENT.md (not CLAUDE.md) for context.

**Why:**
- Works with both Claude Code and Codex
- Single source of truth for project conventions
- Includes task completion protocol (what to verify)
- Symlinked to CLAUDE.md for Claude Code compatibility

**Contents:**
- Project description
- Validation command
- Key directories
- Coding conventions

---

## Decision 9: Task Granularity is Explicit

**Choice:** Task writers decide granularity based on agent.

**Guidelines:**
- `@claude` tasks can be larger (uses sub-agents)
- `@codex` tasks should be focused (1-2 files)
- Both produce commits

**Why not auto-split:** AI task splitting is unreliable. Human judgment is better for deciding scope.

---

## Decision 10: Research Tasks Are First-Class

**Choice:** `[research]` flag for tasks that produce docs, not code.

**Why:**
- Some tasks need exploration before implementation
- Research artifacts inform later implementation tasks
- Separates "figure out" from "build"
- Claude is better at research; Codex at implementation

**Pattern:**
```markdown
### T3: Research X @claude [research]
**Artifacts:** docs/X-FINDINGS.md

### T4: Implement X @codex
**Depends:** T3
```

---

## Decision 11: Flags Over Configuration

**Choice:** Use inline flags like `[use-subagents]` rather than config.

**Why:**
- Self-documenting in the task file
- No separate config to maintain
- Easy to read and understand
- Can vary per-task

**Available flags:**
- `[use-subagents]` — Claude should parallelize
- `[research]` — Output is documentation
- `[manual]` — Human should do this, not agent

---

## Decision 12: Minimal Config File

**Choice:** `.agent/config.yml` only has defaults and validation.

```yaml
agent: claude        # Default if task has no @tag
validate: pnpm test  # Run before marking done
yolo: true           # Skip confirmation prompts
```

**Why:**
- Most config is in TASKS.md where it's visible
- Config file is just for project-wide defaults
- Keeps things simple

---

## Open Questions (Not Yet Decided)

### Auto-Detection of Agent

Should we try to auto-detect the right agent based on task keywords?

**Pro:** Less burden on task writer.
**Con:** Unpredictable, magical.

**Current stance:** No, be explicit. May revisit.

### Task Priority

Should tasks have priority levels (P0, P1, P2)?

**Pro:** Could influence order.
**Con:** Dependencies already define order. Adds complexity.

**Current stance:** Not yet. Milestones handle importance.

### Rollback Automation

Should `next rollback` undo the last task (git revert + move back to Ready)?

**Pro:** Easy recovery.
**Con:** May cause issues with dependent tasks.

**Current stance:** Implement if needed, not in MVP.
