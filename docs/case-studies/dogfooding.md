# Dogfooding: Building next-task with next-task

*Using the tool to build itself — the ultimate test.*

## The Setup

We wanted to add P2 features to next-task:
- **T1:** Specs directory support
- **T2:** Progress notifications
- **T3:** Task templates

Instead of building these manually, we used next-task itself to orchestrate the work. Here's how it went.

## Creating the Task File

```markdown
# Tasks — next-task

Dogfooding: using next-task to build next-task.

## P2: Medium Priority Features

### T1: Specs directory support @codex
**Artifacts:** src/next (modified)
**Commit:** `feat: add specs directory support`

Add support for external spec files referenced in tasks.
When a task has `**Spec:** specs/foo.md`, load that file's content 
and include it in the prompt sent to the agent.

Implementation:
1. In `parse_task()`, extract TASK_SPEC from the task body
2. In `build_prompt()`, if TASK_SPEC is set, append its contents
3. Handle missing spec files gracefully (warn but continue)

### T2: Progress notifications @codex
**Depends:** T1
**Artifacts:** src/next (modified)
**Commit:** `feat: add progress notifications`

Add desktop notifications when tasks complete or fail.
On macOS, use osascript. On Linux, use notify-send.

### T3: Task templates @codex
**Depends:** T2
...
```

## Running It

```bash
cd ~/dev/next-task
next init
next run
```

## What Happened

### T1: Specs Directory Support (~3 minutes)

Codex:
1. Searched for existing patterns (`parse_task`, `build_prompt`)
2. Read relevant code sections
3. Tested bash escaping edge cases (thorough!)
4. Added `TASK_SPEC` parsing
5. Modified `build_prompt()` to include spec content
6. Created temporary test files, ran `next preview`
7. Cleaned up test files
8. Committed with the specified message

**Result:** Clean implementation, proper testing, correct commit.

### T2: Progress Notifications

Codex started implementing:
1. Added `notify()` function
2. Added `NOTIFICATIONS` config option
3. Updated default config template

Then the process was killed (signal 9 — possibly OOM or timeout).

**Recovery:** We completed the task manually by adding `notify()` calls to the completion and failure handlers, then committed.

## Observations

### What Worked Well

✅ **Task isolation** — Each task was self-contained with clear artifacts  
✅ **Commit messages** — Codex used the exact messages we specified  
✅ **Testing** — Codex created temp files, tested, then cleaned up  
✅ **Code patterns** — AGENT.md helped Codex understand conventions  
✅ **Dependencies** — T2 correctly waited for T1 to complete  

### What Could Be Better

⚠️ **Process stability** — T2 was killed mid-task, required manual recovery  
⚠️ **State recovery** — After kill, state file needed manual cleanup  
⚠️ **Run vs Loop** — `next run` seemed to continue to T2 (unexpected)  

### Metrics

| Task | Agent | Time | Tokens | Result |
|------|-------|------|--------|--------|
| T1 | Codex | ~3 min | ~59k | ✅ Clean |
| T2 | Codex | ~2 min | ~30k | ⚠️ Killed |

## Tips for Dogfooding

1. **Tag a stable version first**
   ```bash
   git tag v2.1-stable -m "Pre-dogfood stable"
   ```

2. **Use preview before running**
   ```bash
   next preview  # See what would happen
   ```

3. **Keep tasks small** — Easier to recover if something fails

4. **Include AGENT.md** — Helps the agent understand your codebase patterns

5. **Specify exact commit messages** — Keeps history clean

## The Meta Result

After dogfooding, next-task now has:
- ✅ Spec file support (`**Spec:** specs/foo.md`)
- ✅ Desktop notifications (macOS/Linux)
- 🔜 Task templates (T3 ready to run)

*The tool successfully improved itself.* 🐕
