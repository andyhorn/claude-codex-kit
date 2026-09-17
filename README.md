# Claude Pro + Codex dev kit (Ember City / hobby work)

## Layout
```
claude/                     -> ~/.claude
  CLAUDE.md                 always loaded; keep it short
  settings.json             model, permissions, hooks
  hooks/format-dart.sh      auto-formats edited .dart files
  scripts/verify.sh         format + analyze + test, token-bounded output
  agents/
    explorer.md             haiku, read-only codebase search
    verifier.md             haiku, runs verify.sh, reports failures only
    reviewer.md             sonnet, reviews a diff against conventions
  skills/
    feature-workflow/       the end-to-end loop: design -> spec -> build -> verify -> review
    codex-delegate/         hands spec'd work to Codex, returns a summary only
    pencil-design/          design work in Pencil via MCP
    design-to-flutter/      turns Pencil frames into widgets using theme tokens
    code-review/            review checklist + cross-model review
codex/AGENTS.md             -> ~/.codex/AGENTS.md (shared stack rules for Codex)
template/                   files to add to your Flutter template repo
install.sh                  backs up and installs claude/ and codex/
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
