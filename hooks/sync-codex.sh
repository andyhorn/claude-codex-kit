#!/usr/bin/env bash
set -euo pipefail

src="${CLAUDE_PLUGIN_ROOT}/codex/AGENTS.md"
dest="$HOME/.codex/AGENTS.md"

[ -f "$src" ] || exit 0

if [ ! -f "$dest" ] || ! cmp -s "$src" "$dest"; then
  mkdir -p "$HOME/.codex"
  if [ -f "$dest" ]; then
    cp "$dest" "$dest.bak-$(date +%Y%m%d-%H%M%S)"
  fi
  cp "$src" "$dest"
  echo "codex-kit: synced AGENTS.md to ~/.codex/AGENTS.md"
fi
