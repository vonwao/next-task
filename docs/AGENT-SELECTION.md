# Agent Selection Guide

How to decide whether a task should use Claude Code or Codex CLI.

## TL;DR

| Task Type | Agent | Why |
|-----------|-------|-----|
| Architecture, design decisions | `@claude` | Needs broad reasoning |
| Multi-file refactors | `@claude` | 200k context, sees everything |
| Research, documentation | `@claude` | Exploratory, explanatory |
| Parallel sub-tasks | `@claude` | Can spawn sub-agents |
| Focused single-file impl | `@codex` | Fast, precise |
| Complex algorithms | `@codex` | PhD-level CS patterns |
| TypeScript type gymnastics | `@codex` | Excellent at advanced types |
| Boilerplate, CRUD | `@codex` | Quick, mechanical |
| Bug fixes (localized) | `@codex` | Surgical precision |

## Claude Code Strengths

### 1. Long Context (200k tokens)

Claude can hold entire codebases in context. Use for:
- Understanding existing code before modifying
- Refactors that touch many files
- Tasks requiring "know the whole picture"

```markdown
### T5: Refactor auth module to use dependency injection @claude
```

### 2. Architectural Reasoning

Claude excels at thinking through trade-offs. Use for:
- Design decisions
- API design
- System architecture
- "Should we do X or Y?" questions

```markdown
### T3: Design sync protocol (WebSocket vs HTTP) @claude [research]
**Artifacts:** docs/SYNC-PROTOCOL.md
```

### 3. Multi-File Coordination

When changes need to be consistent across files:

```markdown
### T7: Add error handling throughout CLI @claude
Needs to update 8 files with consistent patterns.
```

### 4. Sub-Agent Parallelization

Claude can spawn sub-agents for independent work:

```markdown
### T6: Build all CLI commands @claude [use-subagents]
**Parallel sub-tasks:**
- init command
- status command
- sync command
```

### 5. Research & Documentation

When output is understanding, not just code:

```markdown
### T2: Research jj programmatic API @claude [research]
**Artifacts:** docs/JJ-API.md

Figure out:
- How to call jj from Node.js
- Available commands and their outputs
- Error handling patterns
- Edge cases (conflicts, colocate mode)
```

### 6. Matching Existing Style

Claude is good at reading existing code and matching patterns:

```markdown
### T8: Add new endpoint following existing patterns @claude
Look at src/api/users.ts and create similar for src/api/projects.ts
```

## Codex CLI Strengths

### 1. Advanced Algorithms

Codex excels at computer science fundamentals:
- Data structures
- Graph algorithms
- Dynamic programming
- Complex state machines

```markdown
### T4: Implement AST-aware merge algorithm @codex
```

### 2. TypeScript Mastery

For advanced type-level programming:
- Generics
- Conditional types
- Mapped types
- Type inference

```markdown
### T3: Create type-safe event emitter with inferred handlers @codex
```

### 3. Focused, Scoped Tasks

When you know exactly what you want:

```markdown
### T2: Add debounce utility function @codex
**Artifacts:** src/utils/debounce.ts, src/utils/debounce.test.ts
```

### 4. Speed

Codex is typically faster for straightforward tasks:

```markdown
### T1: Create package.json with dependencies @codex
### T2: Set up vitest config @codex
```

### 5. Boilerplate Generation

Mechanical, pattern-based code:

```markdown
### T6: Create CRUD endpoints for projects @codex
```

### 6. Bug Fixes (Localized)

When the fix is in one place:

```markdown
### T9: Fix off-by-one error in pagination @codex
```

## Decision Flowchart

```
Start
  │
  ├─ Does it need 5+ files of context? ──────────────► @claude
  │
  ├─ Is it a design/architecture question? ──────────► @claude
  │
  ├─ Can it be parallelized into sub-tasks? ─────────► @claude [use-subagents]
  │
  ├─ Is it research/documentation? ──────────────────► @claude [research]
  │
  ├─ Is it a complex algorithm? ─────────────────────► @codex
  │
  ├─ Is it advanced TypeScript types? ───────────────► @codex
  │
  ├─ Is it focused on 1-2 files? ────────────────────► @codex
  │
  └─ Default (simple implementation) ────────────────► @codex
```

## Hybrid Patterns

### Research Then Implement

```markdown
### T3: Research jj API @claude [research]
**Artifacts:** docs/JJ-API.md

### T4: Implement JjClient based on research @codex
**Depends:** T3
**Artifacts:** src/jj/JjClient.ts
```

Claude does the exploration, Codex does the focused implementation.

### Design Then Build

```markdown
### T5: Design FileWatcher architecture @claude
**Artifacts:** docs/FILE-WATCHER-DESIGN.md

### T6: Implement FileWatcher @codex
**Depends:** T5
**Artifacts:** src/watcher/FileWatcher.ts
```

### Parallel Build, Then Integrate

```markdown
### T7: Build individual CLI commands @claude [use-subagents]
**Parallel sub-tasks:**
- init, status, sync commands

### T8: Wire up CLI entry point @codex
**Depends:** T7
**Artifacts:** src/cli/index.ts
```

## Anti-Patterns

### ❌ Don't Use Claude For

- Simple one-file implementations (too slow)
- Pure algorithmic problems (Codex is better)
- Tasks that don't need broad context

### ❌ Don't Use Codex For

- Tasks requiring understanding of 10+ files
- Architectural decisions
- Tasks that say "figure out how to..."
- Refactors touching many files

## When In Doubt

**Default to `@codex`** for implementation tasks.

**Use `@claude`** when:
- The task description uses words like "design", "research", "refactor", "understand"
- You'd want to "think out loud" about the approach
- Multiple files need coordinated changes

## Examples From Real Projects

### weldr-v3

```markdown
### T1: Project scaffolding @codex
Basic setup, known pattern.

### T2: File watcher @codex  
Focused implementation, one module.

### T3: Research jj API @claude [research]
Exploratory, needs documentation.

### T4: JjClient wrapper @codex
**Depends:** T3
Focused implementation based on research.

### T5: CLI commands @claude [use-subagents]
Multiple commands, good for parallelization.

### T6: Sync protocol design @claude [research]
Architecture decision.

### T7: Implement sync client @codex
**Depends:** T6
Focused implementation based on design.
```
