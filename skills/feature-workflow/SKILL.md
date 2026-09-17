---
name: feature-workflow
description: End-to-end workflow for building a feature or screen in a Flutter project: design in Pencil, write a spec, route implementation to Codex or Claude, verify, review, and log decisions. Use when starting any feature larger than a few edits, or when the user says "build", "add feature", "new screen".
---

# Feature workflow

Run the phases in order. Stop and ask the user at each marked checkpoint.

## Phase 1: Design (skip for non-UI work)
Use the `pencil-design` skill. Output: named frames in the Pencil file plus a
list of any new tokens needed.
**Checkpoint:** user approves the design.

## Phase 2: Spec
Copy `references/spec-template.md` to `tasks/<feature>.md` and fill it in.
Use the `explorer` agent to find existing patterns to follow; don't read the
codebase yourself. Keep specs short. Public API signatures and acceptance
criteria matter most, prose matters least.
**Checkpoint:** user approves the spec. This is the cheapest place to catch
mistakes.

## Phase 3: Route the work
Use `references/routing.md` to pick an executor for each chunk. Write the
choice into the spec's "Execution" section.

## Phase 4: Implement
- Codex chunks: `codex-delegate` skill.
- Claude chunks: do them directly, or `design-to-flutter` for UI.
- Commit between chunks so each diff is reviewable on its own.

## Phase 5: Verify
Use the `verifier` agent. On failure:
- Delegated chunk: send it back to Codex with the failure lines. Don't debug it
  in the main session.
- Claude chunk: fix it.
Two failed rounds on the same chunk means the spec is wrong. Go back to Phase 2.

## Phase 6: Review
Use the `reviewer` agent. For anything touching billing, auth, Firestore rules,
or data migrations, also run the cross-model review in `code-review`.

## Phase 7: Close out
- Propose DECISIONS.md entries for any tradeoffs made.
- Tick acceptance criteria in the spec and move it to `tasks/done/`.
- Suggest `/clear` before the next feature.
