## claude-codex-kit: budget rules (Claude Pro, tight)

Volume work goes to Codex (ChatGPT budget), not to Claude subagents.

- Implementation from a spec, test suites, codegen fallout, migrations, renames,
  l10n -> `codex-delegate` skill. **This takes precedence over the global
  Delegation section's `builder` agent.** Use `builder` only when Codex is out
  of quota, and limit it to the files the spec names.
- Anything bigger than a few edits needs a spec first, and Codex drafts it:
  `draft-spec.sh <slug> "<brief>"`, then critique it. Never explore the codebase
  by hand to write a spec.
- "Where is X" / "how does Y work" -> `explorer` agent.
- analyze/test runs -> `verifier` agent or `scripts/verify.sh`. Never paste raw
  test output into context.
- Never read: full diffs of delegated work (start at `git diff --stat`),
  generated files (`*.g.dart`, `*.freezed.dart`, `*.gr.dart`).
- Before opening a third file in one turn, stop and dispatch instead.
