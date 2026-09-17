#!/usr/bin/env bash
set -euo pipefail

src="${CLAUDE_PLUGIN_ROOT}/codex/AGENTS.md"
dest="$HOME/.codex/AGENTS.md"
begin="<!-- claude-codex-kit:begin -->"
end="<!-- claude-codex-kit:end -->"

[ -f "$src" ] || exit 0

mkdir -p "$HOME/.codex"

if [ ! -f "$dest" ]; then
  { printf '%s\n' "$begin"; cat "$src"; printf '%s\n' "$end"; } >"$dest"
  echo "codex-kit: added AGENTS.md block to ~/.codex/AGENTS.md"
  exit 0
fi

begin_line="$(grep -nF "$begin" "$dest" | head -1 | cut -d: -f1 || true)"
end_line="$(grep -nF "$end" "$dest" | head -1 | cut -d: -f1 || true)"
new="$(printf '%s\n' "$begin"; cat "$src"; printf '%s\n' "$end")"

if [ -n "$begin_line" ] && [ -n "$end_line" ]; then
  current="$(sed -n "${begin_line},${end_line}p" "$dest")"
  [ "$current" = "$new" ] && exit 0

  cp "$dest" "$dest.bak-$(date +%Y%m%d-%H%M%S)"
  {
    [ "$begin_line" -gt 1 ] && sed -n "1,$((begin_line - 1))p" "$dest"
    printf '%s\n' "$new"
    tail -n "+$((end_line + 1))" "$dest"
  } >"$dest.tmp"
  mv "$dest.tmp" "$dest"
  echo "codex-kit: updated AGENTS.md block in ~/.codex/AGENTS.md"
else
  cp "$dest" "$dest.bak-$(date +%Y%m%d-%H%M%S)"
  { cat "$dest"; printf '\n%s\n' "$new"; } >"$dest.tmp"
  mv "$dest.tmp" "$dest"
  echo "codex-kit: added AGENTS.md block to ~/.codex/AGENTS.md"
fi
