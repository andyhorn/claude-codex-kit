# Claude Pro + Codex dev kit (Ember City / hobby work)

This repo is a **Claude Code plugin**. Add it as a plugin marketplace to get
the agents, skills, and hooks; run `install.sh` for the parts a plugin can't
deliver (global `CLAUDE.md`, `settings.json`, and Codex's `AGENTS.md`).

## Install

**As a plugin** (agents, skills, hooks, and the Claude<->Codex sync):
```
/plugin marketplace add andyhorn/claude-codex-kit
/plugin install claude-codex-kit@claude-codex-kit
```
On first session start after install, a `SessionStart` hook merges
`codex/AGENTS.md` into `~/.codex/AGENTS.md` inside a marked block, leaving
any existing content above it untouched. Re-running it after an update
replaces only that block, in place, idempotently.

## Updating the plugin

Claude Code caches an installed plugin by its `plugin.json` `version`, so a
content change alone won't be picked up — bump the version:
```
/plugin marketplace update claude-codex-kit
/reload-plugins
```
(Bump `version` in `.claude-plugin/plugin.json`, commit, and push before
running this — without a version bump the cached copy is reused as-is.)

**Manual extras** (global `CLAUDE.md`, `settings.json` permissions, and a
`~/.codex/AGENTS.md` seed if you're not using the plugin yet):
```
./install.sh
```
It never overwrites a file wholesale: `CLAUDE.md` and `AGENTS.md` are merged
into a marked block, and `settings.json` gets its permission lists unioned in
with `model`, `hooks`, `env`, and everything else left alone. Requires `jq`.

Routing and budget rules are *not* installed this way — the plugin's
`SessionStart` hook injects `context/budget-rules.md` every session, so they
stay versioned with the plugin and apply to ad-hoc work, not just to
`feature-workflow`. That includes the precedence rule that volume work goes to
Codex before any Claude-side `builder` agent.

## Layout
```
.claude-plugin/plugin.json  plugin manifest
agents/
  explorer.md                haiku, read-only codebase search
  verifier.md                 haiku, runs verify.sh, reports failures only
  reviewer.md                 sonnet, reviews a diff against conventions
skills/
  feature-workflow/          the end-to-end loop: design -> spec -> build -> verify -> review
  codex-delegate/            draft-spec.sh (Codex drafts a spec) and
                             delegate.sh (Codex implements a chunk, summary only)
  pencil-design/             design work in Pencil via MCP
  design-to-flutter/         turns Pencil frames into widgets using theme tokens
  code-review/               review checklist + cross-model review
context/budget-rules.md      routing + budget rules, injected every session by the hook
hooks/
  hooks.json                 registers the PostToolUse and SessionStart hooks
  format-dart.sh              auto-formats edited .dart files
  sync-codex.sh                syncs codex/AGENTS.md -> ~/.codex/AGENTS.md
  budget-rules.sh              injects context/budget-rules.md as ambient context
scripts/
  verify.sh                  format + analyze + test, token-bounded output
  merge-block.sh              idempotent marked-block merge into a file you don't own
codex/AGENTS.md              shared stack rules for Codex; synced by the plugin's SessionStart hook
reference/
  CLAUDE.md                  global instructions; plugins can't set this, merge manually via install.sh
  settings.json               model + permissions; plugins can't set this, merge manually via install.sh
template/                    files to add to your Flutter template repo
install.sh                   installs reference/ and codex/ (the non-plugin-deliverable parts)
```

## Cost model
| Work | Who | Budget hit |
|---|---|---|
| Planning, API design, final judgment | Main session (Opus in plan mode) | Claude, high |
| Drafting a spec (codebase exploration) | Codex | ChatGPT, zero Claude |
| Critiquing and approving that spec | Main session | Claude, low |
| Small edits, glue, orchestration | Main session (Sonnet) | Claude, medium |
| Search, "where is X", verify runs | Haiku subagents | Claude, low |
| Diff review | Sonnet reviewer subagent | Claude, medium |
| Implementation from a spec, tests, codegen fallout | Codex | ChatGPT, zero Claude |
| Second-opinion review | `codex review` / plugin | ChatGPT, zero Claude |

## Things to verify after install
- `claude` -> `/model`: confirm `opusplan` is available on your plan. If not, set `"model": "sonnet"`.
- `codex exec --help`: confirm `--sandbox` and `--output-last-message` flags.
- Pencil MCP tool names: the pencil skill is tool-name-agnostic on purpose. Merge in your existing Pencil skill.
- `jq` must be installed for the format hook and `install.sh` (`brew install jq`).
