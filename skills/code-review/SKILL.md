---
name: code-review
description: Review checklist for Flutter/Riverpod/Firebase changes, plus cross-model review with Codex. Use when reviewing a diff, before merging, or when the reviewer agent runs.
---

# Code review

## Checklist (priority order)
**Correctness**
- Async gaps: `context` or `ref` used after `await` without a mounted check.
- Providers: right lifetime (autoDispose vs kept alive), no provider created
  inside build, no `ref.read` where `ref.watch` is needed in build.
- Error and loading states handled for every AsyncValue.
- Firestore: queries have matching indexes, writes are batched where they must
  be atomic, security rules updated with the data model.
- RevenueCat: entitlement checks come from one source; nothing is unlocked
  optimistically without a server check.

**API design**
- Public names read well at the call site.
- Repositories return domain models, not Firestore snapshots.
- Nothing exposed that the spec didn't require.

**Maintainability**
- Matches existing patterns (CONVENTIONS.md).
- No hardcoded colors, spacing, or strings meant for l10n.
- Tests assert behavior, not implementation details.

## Cross-model review
Run when the change touches billing, auth, security rules, migrations, or was
written mostly by Claude:
- With the plugin: `/codex:review --background`, then `/codex:result`.
- Without it: `codex review` in the repo (check `codex --help` if the
  subcommand name changed).

Treat Codex findings as input, not verdicts. Codex is stronger at correctness
nits; Claude is stronger at design and fit. Disagreements go to the user.
