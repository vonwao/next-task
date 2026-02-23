# AGENT.md — sprint

## Project
A CLI for running AI work in short, repeatable task loops.

## Key File
The entire implementation is in `src/sprint` — a single bash script (~1100 lines).

## Structure
```
src/sprint        # Main script (bash)
docs/             # Docsify documentation
BACKLOG.md        # Feature backlog
TASKS.md          # Current sprint tasks
SPRINT.md         # Current sprint scope (injected into prompt context)
PROGRESS.md       # Cross-iteration memory (runner appends blocks after each task)
```

## Prompt Context Order
```
AGENT.md → guardrails.md → SPRINT.md → task prompt → tail(PROGRESS.md)
```

## Commands to Verify
```bash
bash -n src/sprint         # Check syntax
sprint help                # Verify help works
sprint preview             # Test in demo project
```

## Code Patterns
- Functions named `cmd_<name>()` for commands
- `parse_task()` extracts metadata from TASKS.md
- `build_prompt()` constructs the agent prompt
- `run_agent()` executes codex or claude
- State in `.agent/state.json` (JSON via python3)
- Colors via ANSI escape codes (RED, GREEN, etc.)

## Rules
- Keep it bash — no external dependencies beyond git, python3
- Test syntax with `bash -n src/sprint` before committing
- Maintain backward compatibility with existing TASKS.md files
