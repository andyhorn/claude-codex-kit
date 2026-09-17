# Global instructions (Andy)

Flutter developer. Ember City Studio and hobby projects. Default stack: Flutter,
Riverpod, go_router, Firebase, RevenueCat. A project's own CONVENTIONS.md,
ARCHITECTURE.md, and DECISIONS.md override anything here.

## Budget rules (Claude Pro, tight)
- Claude is for judgment: planning, architecture, API design, review.
- Codex is for volume: implementation from a spec, tests, codegen fallout,
  migrations, renames, l10n. Use the `codex-delegate` skill.
- Search and "where is X used" questions go to the `explorer` agent, not the
  main session.
- Running analyze/tests goes to the `verifier` agent or
  `~/.claude/scripts/verify.sh`. Never paste full test output into context.
- Never read full diffs of delegated work. Start with `git diff --stat`, then
  read only files that touch public API, state, or navigation.
- Never read generated files (*.g.dart, *.freezed.dart, *.gr.dart).
- If a task is bigger than a few edits and has no spec, write one first
  (`feature-workflow` skill).

## Working style
- Ask before making design or architecture decisions the spec doesn't cover.
- Propose entries for DECISIONS.md when a real tradeoff is made.
- Be direct. Say when something is a bad idea and why.
