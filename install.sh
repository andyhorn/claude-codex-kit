#!/usr/bin/env bash
# Installs the parts a Claude Code plugin can't deliver: global CLAUDE.md,
# settings.json (model/permissions), and codex/ -> ~/.codex.
# Agents, skills, and hooks are installed by adding this repo as a Claude
# Code plugin instead (see README.md).
# Existing files are never deleted; any file that gets overwritten is kept
# next to the new one as <file>.bak-<timestamp>.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
stamp="$(date +%Y%m%d-%H%M%S)"
command -v rsync >/dev/null || { echo "rsync required"; exit 1; }

mkdir -p "$HOME/.claude" "$HOME/.codex"
rsync -a --backup --suffix=".bak-$stamp" "$here/reference/" "$HOME/.claude/"
rsync -a --backup --suffix=".bak-$stamp" "$here/codex/" "$HOME/.codex/"

backups="$(find "$HOME/.claude" "$HOME/.codex" -name "*.bak-$stamp" 2>/dev/null || true)"
if [ -n "$backups" ]; then
  echo "Overwrote these (backups kept). Merge anything you still need:"
  echo "$backups"
fi
command -v jq >/dev/null || echo "WARN: jq not found; the dart format hook needs it"
command -v codex >/dev/null || echo "WARN: codex not on PATH (npm i -g @openai/codex)"
echo "Installed CLAUDE.md, settings.json, and codex/AGENTS.md."
echo "Now add this repo as a Claude Code plugin for agents/skills/hooks. See README.md."
echo "See template/SETUP.md for the template repo."
