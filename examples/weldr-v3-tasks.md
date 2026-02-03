# Tasks — weldr-v3

Local agent + jj + cloud sync for team collaboration.

## 🏁 Milestone 1: Project Foundation

### T1: Project scaffolding @codex
**Depends:** (none)
**Artifacts:** package.json, tsconfig.json, src/, vitest.config.ts
**Commit:** `chore: initialize weldr-v3 project`

Set up a TypeScript Node.js project:
- package.json with: typescript, vitest, chokidar, commander, ws
- tsconfig.json for Node.js (ES modules)
- src/ directory structure:
  - src/cli/
  - src/watcher/
  - src/jj/
  - src/sync/
  - src/types/
- vitest.config.ts
- .gitignore (node_modules, dist, .jj internal stuff)

### T2: Core types and interfaces @codex
**Depends:** T1
**Artifacts:** src/types/index.ts, src/types/events.ts, src/types/config.ts
**Commit:** `feat: core type definitions`

Define TypeScript types:
- WeldrConfig (project config)
- FileChange (add/modify/delete events)
- SyncStatus (connected/disconnected/syncing)
- JjStatus (clean/dirty/conflicts)

---
🎯 **Milestone 1 complete:** Project structure ready, types defined

## 🏁 Milestone 2: File Watching

### T3: FileWatcher class @codex
**Depends:** T2
**Artifacts:** src/watcher/FileWatcher.ts, src/watcher/FileWatcher.test.ts
**Commit:** `feat: file watcher with debouncing`

Create FileWatcher using chokidar:
- Watch project directory recursively
- Debounce changes (configurable, default 5s)
- Ignore patterns: node_modules, .git, .jj, dist
- Emit events: FileChange[]
- Methods: start(), stop(), onChanges(callback)

Include tests for:
- Detecting file add/change/delete
- Debouncing (multiple rapid changes → single event)
- Ignore patterns working

### T4: Watcher integration tests @codex
**Depends:** T3
**Artifacts:** src/watcher/FileWatcher.integration.test.ts
**Commit:** `test: watcher integration tests`

Integration tests that:
- Create temp directory
- Make actual file changes
- Verify events are emitted correctly
- Test debouncing with real timers

---
🎯 **Milestone 2 complete:** File watcher works reliably

## 🏁 Milestone 3: jj Integration

### T5: Research jj programmatic API @claude [research]
**Depends:** T1
**Artifacts:** docs/JJ-API.md
**Commit:** `docs: jj API research`

Figure out how to use jj from Node.js:
- Available CLI commands and their JSON outputs
- How to: init, status, commit, diff, log, undo
- How conflicts are represented
- How to detect if repo is jj-enabled
- colocate mode behavior
- Error handling patterns

Document findings with code examples.

### T6: JjClient class @codex
**Depends:** T5
**Artifacts:** src/jj/JjClient.ts, src/jj/types.ts, src/jj/JjClient.test.ts
**Commit:** `feat: jj client wrapper`

Implement JjClient based on research:
- exec() helper for running jj commands
- status() → JjStatus
- commit(message) → CommitResult
- log(limit) → Commit[]
- diff() → FileDiff[]
- undo() → void
- isJjRepo() → boolean

Use JSON output where available. Parse text output otherwise.

### T7: jj init and colocate handling @codex
**Depends:** T6
**Artifacts:** src/jj/init.ts
**Commit:** `feat: jj init with colocate support`

Handle project initialization:
- init(path, options) → creates jj repo
- Support colocate mode (jj + git together)
- Detect existing git repo and offer to colocate
- Handle already-initialized case gracefully

---
🎯 **Milestone 3 complete:** Can interact with jj programmatically

## 🏁 Milestone 4: CLI Foundation

### T8: CLI structure with commander @codex
**Depends:** T2
**Artifacts:** src/cli/index.ts, src/cli/commands/index.ts
**Commit:** `feat: CLI entry point`

Set up CLI using commander.js:
- Main entry point: src/cli/index.ts
- Commands loaded from src/cli/commands/
- --version, --help working
- Global options: --verbose, --config

### T9: weldr init command @codex
**Depends:** T7, T8
**Artifacts:** src/cli/commands/init.ts
**Commit:** `feat: weldr init command`

`weldr init` command:
- Initialize jj in current directory (colocate if git exists)
- Create .weldr/config.json with defaults
- Print success message with next steps

### T10: weldr status command @codex
**Depends:** T6, T8
**Artifacts:** src/cli/commands/status.ts
**Commit:** `feat: weldr status command`

`weldr status` command:
- Show jj status (clean/dirty/conflicts)
- Show sync status (connected/disconnected)
- Show pending changes count
- Show last sync time

### T11: weldr daemon command @codex
**Depends:** T3, T6, T8
**Artifacts:** src/cli/commands/daemon.ts, src/daemon/index.ts
**Commit:** `feat: weldr daemon command`

`weldr daemon` command:
- Start file watcher
- On changes: create jj commit (auto-commit)
- Run in foreground (background mode later)
- Graceful shutdown on SIGINT/SIGTERM

---
🎯 **Milestone 4 complete:** Local CLI works (init, status, daemon)

## 🏁 Milestone 5: Local Testing

### T12: End-to-end local tests @claude
**Depends:** T9, T10, T11
**Artifacts:** tests/e2e/local.test.ts
**Commit:** `test: local e2e tests`

Integration tests for local workflow:
1. weldr init in temp directory
2. Create files, verify jj tracks them
3. Start daemon, make changes
4. Verify auto-commits happen
5. weldr status shows correct state

### T13: Documentation for local usage @claude [research]
**Depends:** T11
**Artifacts:** docs/LOCAL-USAGE.md, README.md
**Commit:** `docs: local usage guide`

Document how to use weldr locally:
- Installation
- Initializing a project
- Running the daemon
- Checking status
- How auto-commits work

---
🎯 **Milestone 5 complete:** Local agent fully functional and documented

## 🏁 Milestone 6: Cloud Sync Protocol

### T14: Design sync protocol @claude [research]
**Depends:** T13
**Artifacts:** docs/SYNC-PROTOCOL.md
**Commit:** `docs: sync protocol design`

Design the sync protocol:
- WebSocket or HTTP? (recommend WebSocket)
- Message format (JSON)
- Authentication flow
- Change format (diffs? full files? jj native?)
- Conflict handling at protocol level
- Reconnection strategy

### T15: SyncClient class @codex
**Depends:** T14
**Artifacts:** src/sync/SyncClient.ts, src/sync/types.ts, src/sync/SyncClient.test.ts
**Commit:** `feat: sync client`

Implement SyncClient based on protocol design:
- connect(url, token) → WebSocket connection
- send(changes) → void
- onReceive(callback) → void
- disconnect() → void
- Automatic reconnection with backoff
- Event emitter for status changes

### T16: Integrate sync into daemon @codex
**Depends:** T11, T15
**Artifacts:** src/daemon/sync-integration.ts
**Commit:** `feat: daemon sync integration`

Connect SyncClient to daemon:
- On file change → commit → send to cloud
- On receive from cloud → apply changes locally
- Handle offline queueing (store pending, send on reconnect)

---
🎯 **Milestone 6 complete:** Client can sync with cloud (cloud not built yet)

## 🏁 Milestone 7: Mock Cloud Server

### T17: Mock sync server @claude [use-subagents]
**Depends:** T15
**Artifacts:** src/server/index.ts, src/server/handlers.ts, src/server/store.ts
**Commit:** `feat: mock sync server`

Build a simple WebSocket server for testing:
- Accept connections
- Receive changes, store in memory
- Broadcast to other connected clients
- No persistence (mock only)

**Parallel sub-tasks:**
- WebSocket server setup
- Message handlers
- In-memory state store
- Client tracking

### T18: Multi-client sync test @claude
**Depends:** T16, T17
**Artifacts:** tests/e2e/sync.test.ts
**Commit:** `test: multi-client sync e2e`

Test two clients syncing through mock server:
1. Start mock server
2. Client A connects, makes change
3. Client B connects, receives change
4. Client B makes change
5. Client A receives change
6. Verify both have same state

---
🎯 **Milestone 7 complete:** Basic sync working between clients

## Future Milestones (Not Detailed Yet)

## 🏁 Milestone 8: Conflict Handling
- Detect jj conflicts
- Surface in CLI
- Resolution helpers

## 🏁 Milestone 9: Real Cloud Service
- Persistent storage
- Authentication
- Project management

## 🏁 Milestone 10: Web Dashboard
- Project view
- Team activity
- Conflict resolution UI

## 🏁 Milestone 11: AI Integration
- Task queue
- AI worker service
- Review/accept/revert flow

---

## In Progress

## Done

