#!/usr/bin/env bash
# Installs the parts a Claude Code plugin can't deliver:
#   ~/.claude/CLAUDE.md   - merged into a marked block, never replaced
#   ~/.claude/settings.json - permissions merged in, everything else left alone
#   ~/.codex/AGENTS.md    - merged into a marked block (the plugin's SessionStart
#                           hook does this too; this is for pre-plugin setup)
# Agents, skills, hooks, and the session budget rules come from the plugin.
# Nothing here overwrites a file wholesale.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"

command -v jq >/dev/null || { echo "jq required (brew install jq)"; exit 1; }

"$here/scripts/merge-block.sh" "$here/reference/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
"$here/scripts/merge-block.sh" "$here/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"

# settings.json: union the kit's permission lists into whatever is already there.
# Never touch model, hooks, env, plugins, or anything else the user has set.
settings="$HOME/.claude/settings.json"
mkdir -p "$HOME/.claude"
[ -f "$settings" ] || echo '{}' >"$settings"
jq empty "$settings" 2>/dev/null || { echo "ERROR: $settings is not valid JSON. Fix it first."; exit 1; }

tmp="$(mktemp)"
jq -s '
  .[0] as $live | .[1] as $kit |
  $live
  | .permissions //= {}
  | .permissions.allow = (( ($live.permissions.allow // []) + ($kit.permissions.allow // []) ) | unique)
  | .permissions.deny  = (( ($live.permissions.deny  // []) + ($kit.permissions.deny  // []) ) | unique)
' "$settings" "$here/reference/settings.json" >"$tmp"

if jq -e --slurpfile a "$settings" '. == $a[0]' "$tmp" >/dev/null; then
  echo "claude-codex-kit: settings.json permissions already up to date"
  rm -f "$tmp"
else
  cp "$settings" "$settings.bak-$(date +%Y%m%d-%H%M%S)"
  mv "$tmp" "$settings"
  echo "claude-codex-kit: merged permissions into $settings (backup kept)"
fi

want_model="$(jq -r '.model // empty' "$here/reference/settings.json")"
have_model="$(jq -r '.model // "unset"' "$settings")"
[ -n "$want_model" ] && [ "$have_model" != "$want_model" ] && \
  echo "NOTE: settings.json model is \"$have_model\"; the kit assumes \"$want_model\". Change it yourself if you want to."

command -v codex >/dev/null || echo "WARN: codex not on PATH (npm i -g @openai/codex)"
echo
echo "Now add this repo as a Claude Code plugin for agents/skills/hooks. See README.md."
echo "See template/SETUP.md for the template repo."
