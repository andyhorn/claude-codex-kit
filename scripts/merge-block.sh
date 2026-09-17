#!/usr/bin/env bash
# Usage: merge-block.sh <src> <dest> [label]
# Idempotently maintains src's contents inside a marked block in dest, leaving
# everything outside the block untouched. Creates dest if missing.
set -euo pipefail

src="${1:?src required}"
dest="${2:?dest required}"
label="${3:-claude-codex-kit}"
begin="<!-- $label:begin -->"
end="<!-- $label:end -->"

[ -f "$src" ] || exit 0
mkdir -p "$(dirname "$dest")"

if [ ! -f "$dest" ]; then
  { printf '%s\n' "$begin"; cat "$src"; printf '%s\n' "$end"; } >"$dest"
  echo "$label: added block to $dest"
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
  echo "$label: updated block in $dest"
else
  cp "$dest" "$dest.bak-$(date +%Y%m%d-%H%M%S)"
  { cat "$dest"; printf '\n%s\n' "$new"; } >"$dest.tmp"
  mv "$dest.tmp" "$dest"
  echo "$label: added block to $dest"
fi
