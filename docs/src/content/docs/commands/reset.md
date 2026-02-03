---
title: next reset
description: Clear in-progress state
---

## Usage

```bash
next reset
```

## Description

Clears the in-progress task from state.json. Use this when:
- A task got stuck and you want to restart
- You interrupted a run and want a clean slate
- State is corrupted

## ⚠️ Warning

This only clears the in-progress marker. It does NOT:
- Undo any file changes
- Revert commits
- Mark tasks as not done

If you need to undo work, use git:

```bash
git reset --hard HEAD~1  # Undo last commit
git checkout .           # Discard uncommitted changes
```

## Output

```
Cleared in-progress state

📋 my-project — Task Status
Done: 2 | In Progress: 0 | Ready: 3 | Blocked: 1
```

## See Also

- [next skip](/commands/skip/) — Skip without losing progress tracking
- [next status](/commands/status/) — Check current state
