# next reset

Clear in-progress state.

## Usage

```bash
next reset
```

## When to Use

- A task got stuck
- State is corrupted
- You want a clean slate

## ⚠️ Warning

This only clears the in-progress marker. It does NOT:
- Undo file changes
- Revert commits
- Mark tasks as not done

For that, use git:

```bash
git reset --hard HEAD~1  # Undo last commit
git checkout .           # Discard uncommitted changes
```
