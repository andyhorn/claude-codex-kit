#!/usr/bin/env bash
# Merges claude/ into ~/.claude and codex/ into ~/.codex.
# Existing files are never deleted; any file that gets overwritten is kept
# next to the new one as <file>.bak-<timestamp>.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
stamp="$(date +%Y%m%d-%H%M%S)"
command -v rsync >/dev/null || { echo "rsync required"; exit 1; }

mkdir -p "$HOME/.claude" "$HOME/.codex"
rsync -a --backup --suffix=".bak-$stamp" "$here/claude/" "$HOME/.claude/"
rsync -a --backup --suffix=".bak-$stamp" "$here/codex/" "$HOME/.codex/"
chmod +x "$HOME"/.claude/hooks/*.sh "$HOME"/.claude/scripts/*.sh \
  "$HOME"/.claude/skills/codex-delegate/scripts/*.sh

backups="$(find "$HOME/.claude" "$HOME/.codex" -name "*.bak-$stamp" 2>/dev/null || true)"
if [ -n "$backups" ]; then
  echo "Overwrote these (backups kept). Merge anything you still need:"
  echo "$backups"
fi
command -v jq >/dev/null || echo "WARN: jq not found; the dart format hook needs it"
command -v codex >/dev/null || echo "WARN: codex not on PATH (npm i -g @openai/codex)"
echo "Installed. See template/SETUP.md for the template repo."
