# <Project name>

Global workflow lives in ~/.claude. This file adds only project facts.

Read before generating code: ARCHITECTURE.md, CONVENTIONS.md.
Log real tradeoffs to DECISIONS.md.

## Project facts
- Theme/tokens live at: lib/app/theme/
- Pencil file: <path or name>
- Pattern reference feature (copy this): lib/features/<feature>/
- Codex delegation: allowed

## Commands
- Verify: ~/.claude/scripts/verify.sh
- Codegen: dart run build_runner build -d
