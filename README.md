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
On first session start after install, a `SessionStart` hook copies
`codex/AGENTS.md` to `~/.codex/AGENTS.md` (idempotent — only touches it when
the bundled copy changed).

**Manual extras** (global `CLAUDE.md`, `settings.json` model/permissions,
and a `~/.codex/AGENTS.md` seed if you're not using the plugin yet):
```
./install.sh
```

## Layout
```
.claude-plugin/plugin.json  plugin manifest
agents/
  explorer.md                haiku, read-only codebase search
  verifier.md                 haiku, runs verify.sh, reports failures only
  reviewer.md                 sonnet, reviews a diff against conventions
skills/
  feature-workflow/          the end-to-end loop: design -> spec -> build -> verify -> review
  codex-delegate/            hands spec'd work to Codex, returns a summary only
  pencil-design/             design work in Pencil via MCP
  design-to-flutter/         turns Pencil frames into widgets using theme tokens
  code-review/               review checklist + cross-model review
hooks/
  hooks.json                 registers format-dart.sh (PostToolUse) and sync-codex.sh (SessionStart)
  format-dart.sh              auto-formats edited .dart files
  sync-codex.sh                syncs codex/AGENTS.md -> ~/.codex/AGENTS.md
scripts/verify.sh            format + analyze + test, token-bounded output
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
| Small edits, glue, orchestration | Main session (Sonnet) | Claude, medium |
| Search, "where is X", verify runs | Haiku subagents | Claude, low |
| Diff review | Sonnet reviewer subagent | Claude, medium |
| Implementation from a spec, tests, codegen fallout | Codex | ChatGPT, zero Claude |
| Second-opinion review | `codex review` / plugin | ChatGPT, zero Claude |

## Things to verify after install
- `claude` -> `/model`: confirm `opusplan` is available on your plan. If not, set `"model": "sonnet"`.
- `codex exec --help`: confirm `--sandbox` and `--output-last-message` flags.
- Pencil MCP tool names: the pencil skill is tool-name-agnostic on purpose. Merge in your existing Pencil skill.
- `jq` must be installed for the format hook (`brew install jq`).
