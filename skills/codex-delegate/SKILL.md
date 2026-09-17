---
name: codex-delegate
description: Hand work to the Codex CLI so it uses the ChatGPT budget instead of Claude's. Two modes: drafting a spec from a brief, and implementing a spec chunk. Use for writing a spec for a new feature, implementing a spec chunk, test suites, build_runner/codegen fixes, migrations, renames, l10n, or when the user says "delegate", "draft a spec", or "send to Codex".
---

# Delegating to Codex

Two modes. Drafting comes first in the workflow; implementing needs a spec that
already exists.

## Mode 1: draft a spec

Codex explores the codebase and fills in the spec template. The exploration is
the expensive part, and it lands on the ChatGPT budget instead of yours.

```
$CLAUDE_PLUGIN_ROOT/skills/codex-delegate/scripts/draft-spec.sh <feature-slug> "<brief>" [effort]
```
- `<feature-slug>`: bare slug, no slashes. Becomes `tasks/<slug>.md`.
- `<brief>`: one or two sentences of user intent. Include the approved Pencil
  frame names if there was a design phase.
- Refuses to overwrite an existing spec.

Codex writes only the spec file and leaves the Execution table empty — routing
is a Claude decision. It reports `QUESTIONS`: the decisions it had to guess at.

### After it returns
1. Read the spec. It is short, and you have to read it to critique it — this is
   the one delegated output you always read in full.
2. Critique it against `QUESTIONS` first, then the rest. Usual failures: invented
   file paths, an empty or careless "Out" list, acceptance criteria that aren't
   testable, public API that doesn't match existing conventions.
3. Fix it yourself. Don't send it back for a second draft — editing a short spec
   is cheaper than another round trip.
4. Take it to the user for approval (`feature-workflow` Phase 2 checkpoint).

## Mode 2: implement a spec chunk

### Preconditions
- A spec exists at `tasks/<feature>.md` and the user has approved it. Never
  delegate from a chat description.
- The working tree is clean (commit or stash). The script refuses otherwise.

### Run
```
$CLAUDE_PLUGIN_ROOT/skills/codex-delegate/scripts/delegate.sh tasks/<feature>.md ["<chunk>"] [effort]
```
- `<chunk>`: optional, names the row in the spec's Execution table.
- `effort`: low | medium | high. Default medium. Use high only for multi-file
  migrations.

The script prints only Codex's final summary and `git diff --stat`. The full
log goes to `tasks/.logs/`. Don't read the log unless the summary says Codex
got stuck.

### After it returns
1. Use the `verifier` agent.
2. If it fails: re-run delegate.sh with a follow-up chunk description that
   contains only the failing lines. Two failures means the spec is wrong. Stop and
   tell the user.
3. If it passes: review per CLAUDE.md budget rules, then commit.

## Don't
- Don't read Codex's full implementation output or the full diff. (A drafted
  spec is the exception — see Mode 1.)
- Don't let Codex fill in the Execution table or make routing calls.
- Don't delegate decisions (see feature-workflow/references/routing.md).
- Don't run two delegations on the same working tree at once.
