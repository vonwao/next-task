# Changelog

## v2.0.0 (2026-02-03)

Major rewrite with reliability improvements.

### Breaking Changes

- State is now stored in `.agent/state.json` (not parsed from TASKS.md sections)
- Tasks are marked done in-place (not moved to Done section)
- New `LOG.md` file for completion history

### New Features

- **Separate state file** (`.agent/state.json`)
  - Reliable tracking of done/in-progress tasks
  - No more parsing markdown for state
  - JSON format, easy to inspect

- **In-place task marking**
  - Tasks stay in their milestone when completed
  - Just adds ✅ and completion info to the header
  - Original task spec preserved

- **LOG.md completion log**
  - Append-only history of completions
  - Grouped by date
  - Includes commit hashes

- **Cleaner prompts**
  - Only current task sent to agent
  - No more future tasks leaking into prompts
  - Reduced token waste

- **Better status display**
  - Shows recent log entries
  - Task IDs displayed with titles
  - Cleaner formatting

### Bug Fixes

- Fixed metadata extraction grabbing from all tasks
- Fixed task body extraction including subsequent tasks
- Fixed commit messages concatenating multiple task messages

### Migration

For existing projects:
1. Tasks already in "Done" section won't be recognized as done
2. Run `next reset` to clear any stuck in-progress state
3. Manually add task IDs to `.agent/state.json` if needed:
   ```json
   {"done":["T1","T2","T3"],"inProgress":null,"log":[]}
   ```

---

## v1.0.0 (2026-02-02)

Initial release.

- Basic task queue functionality
- Claude and Codex support
- Dependency tracking
- Auto-commit on completion
