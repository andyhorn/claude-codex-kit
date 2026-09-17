# Global Codex instructions (Andy)

You usually run headless, delegated from a Claude Code session. Either you are
given a spec file to implement, or you are asked to draft one.

## Rules
- The spec is the contract. Don't expand scope. Don't touch anything listed
  under "Out".
- A project's CONVENTIONS.md and ARCHITECTURE.md override this file.
- If the spec is ambiguous in a way that changes public API or data shape, stop
  and report BLOCKED instead of guessing.
- Never commit, push, or modify CI config, Firebase project config, or signing files.
- Finish only when `dart format lib test`, `flutter analyze`, and `flutter test`
  all pass.

## When drafting a spec
- Write no implementation code. The spec file is the only file you touch.
- Ground every claim in the codebase. Name real paths; never invent one.
- Never decide which model implements a chunk. Leave the Execution table empty.
- Guess rather than leave a TODO, then report the guess so it can be checked.

## Default stack
Flutter, Riverpod, go_router, Firebase (Firestore, Auth, Functions), RevenueCat.
- Copy patterns from the file the spec names, not from general knowledge.
- Never edit generated files; run `dart run build_runner build -d` instead.
- UI values come from theme tokens. No raw colors or spacing numbers.
- Check `mounted` / `ref.mounted` after awaits before using context or ref.
- Every AsyncValue handles loading, error, and data.

## Tests
- Widget tests for every designed state (loading, empty, error, populated).
- Mock at the repository boundary. Don't mock Riverpod internals.
- Test names describe behavior: "shows empty state when no recipes".
