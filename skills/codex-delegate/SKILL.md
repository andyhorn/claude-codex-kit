---
name: codex-delegate
description: Delegate spec'd implementation work to the Codex CLI so it uses the ChatGPT budget instead of Claude's. Use for implementing a spec chunk, writing test suites, build_runner/codegen fixes, migrations, renames, l10n, or when the user says "delegate" or "send to Codex".
---

# Delegating to Codex

## Preconditions
- A spec exists at `tasks/<feature>.md`. If not, write one first. Never
  delegate from a chat description.
- The working tree is clean (commit or stash). The script refuses otherwise.

## Run
```
$CLAUDE_PLUGIN_ROOT/skills/codex-delegate/scripts/delegate.sh tasks/<feature>.md ["<chunk>"] [effort]
```
- `<chunk>`: optional, names the row in the spec's Execution table.
- `effort`: low | medium | high. Default medium. Use high only for multi-file
  migrations.

The script prints only Codex's final summary and `git diff --stat`. The full
log goes to `tasks/.logs/`. Don't read the log unless the summary says Codex
got stuck.

## After it returns
1. Use the `verifier` agent.
2. If it fails: re-run delegate.sh with a follow-up chunk description that
   contains only the failing lines. Two failures means the spec is wrong. Stop and
   tell the user.
3. If it passes: review per CLAUDE.md budget rules, then commit.

## Don't
- Don't read Codex's full output or the full diff.
- Don't delegate decisions (see feature-workflow/references/routing.md).
- Don't run two delegations on the same working tree at once.
