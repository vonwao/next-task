# next-task Backlog

> Prioritized feature backlog for next-task development.

---

## ✅ Shipped

| Feature | Description | Commit |
|---------|-------------|--------|
| Core task runner | Parse TASKS.md, run agents, track state | v1 |
| `next loop` | Ralph-style continuous execution | cfd1899 |
| `next commit` | Manual checkpoint command | fca715a |
| `next preview` | Dry run mode | 1c1a2e4 |
| Commit tracking fix | Capture agent commits correctly | 7114331 |
| Codex exit fix | Use correct bypass flag | 7114331 |
| Docsify docs | Zero-build documentation | ddfee86 |
| Demo repo | 2-minute quick start | next-task-demo |

---

## 🔥 P0: Critical / Next Up

### Windows Support
**Problem:** Shell script only works on Mac/Linux. Windows users bounce.
**Options:**
1. Document WSL requirement (easy cop-out)
2. Node.js rewrite (portable, more work)
3. Go binary (fast, single binary)

**Recommendation:** Start with WSL docs, evaluate Node rewrite later.
**Effort:** Low (docs) / High (rewrite)

---

## 🎯 P1: High Value, Low Effort

### Guardrails File
**What:** `.agent/guardrails.md` injected into every prompt.
**Why:** Prevents repeat mistakes, accumulates project wisdom.
**Implementation:** 
```bash
# In build_prompt(), append guardrails if exists
if [ -f ".agent/guardrails.md" ]; then
  cat .agent/guardrails.md >> "$TEMP_PROMPT"
fi
```
**Effort:** 30 min

### Validation / Backpressure
**What:** Run commands before marking task done.
```yaml
# .agent/config.yml
validate: pnpm test --run
```
**Why:** Quality gates, catch regressions.
**Effort:** 1-2 hours

### Better Error Messages
**What:** When agent fails, show helpful next steps.
**Current:** "Task may have failed (exit: 1, no commit)"
**Better:** Show last 20 lines of output, suggest `next skip` or retry.
**Effort:** 1 hour

---

## 🎯 P2: High Value, Medium Effort

### Specs Directory Support
**What:** Reference external spec files in tasks.
```markdown
### T5: Implement auth @claude
**Spec:** specs/auth.md
```
**Why:** Keeps TASKS.md clean, detailed specs in separate files.
**Effort:** 2-3 hours

### Task Templates
**What:** `next add "Add user auth" @claude` generates task from template.
**Why:** Faster task creation, consistent format.
**Effort:** 2-3 hours

### Progress Notifications
**What:** Desktop notification when task completes (or fails).
```bash
# After task completes
osascript -e 'display notification "T5 complete" with title "next-task"'
```
**Why:** Know when to check back on long-running loops.
**Effort:** 1 hour

### `next retry`
**What:** Re-run the last failed task.
**Why:** Common workflow after fixing an issue.
**Effort:** 1 hour

---

## 🔮 P3: Medium Value, Higher Effort

### Planning Mode
**What:** `next plan` — gap analysis between specs and code.
```bash
next plan              # Compare specs/ to src/, suggest tasks
next plan --apply      # Auto-update TASKS.md
```
**Why:** Auto-generate task breakdowns from specs.
**Risk:** LLM might miss nuance, needs human review.
**Effort:** 4-6 hours

### Multi-Project Support
**What:** Run next-task across multiple repos.
```bash
next --project ~/dev/api status
next --project ~/dev/frontend loop
```
**Why:** Monorepo / multi-service workflows.
**Effort:** 3-4 hours

### Web Dashboard
**What:** Local web UI showing task status, logs, history.
**Why:** Better visibility than terminal output.
**Effort:** 8+ hours

---

## 🧪 P4: Experimental / Nice to Have

### Subagent Hints
**What:** `[use-subagents]` flag tells Claude to parallelize.
**Why:** Faster for large research tasks.
**Complexity:** Prompt engineering only, Claude-specific.
**Effort:** 1 hour (just prompt changes)

### Cost Tracking
**What:** Estimate/track token usage per task.
**Why:** Know how much a project costs.
**Effort:** 4+ hours

### Task Dependencies Graph
**What:** `next graph` — visualize task dependencies.
**Why:** Understand blocked/ready at a glance.
**Effort:** 2-3 hours

### Auto-Retry with Backoff
**What:** In loop mode, exponential backoff on failures.
**Why:** Handle transient errors (rate limits, network).
**Effort:** 1-2 hours

---

## ❌ Won't Do (For Now)

| Idea | Reason |
|------|--------|
| Cloud sync | Out of scope, use git |
| Team features | Single-user tool for now |
| IDE plugin | CLI-first, maybe later |
| Custom agents | Codex + Claude cover 99% of cases |

---

## Suggested Next Sprint

**If we have 4 hours:**
1. ✅ Guardrails file (30 min)
2. ✅ Validation config (2 hours)
3. ✅ Better error messages (1 hour)
4. ✅ `next retry` (30 min)

**If we have 8 hours:**
- All of the above, plus:
5. ✅ Specs directory support (2 hours)
6. ✅ Progress notifications (1 hour)

---

## How to Contribute

Pick an item, implement it, PR it. Keep the shell script simple. If it needs Node.js, that's a sign we should consider the rewrite.
