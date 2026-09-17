#!/usr/bin/env bash
set -euo pipefail
exec "${CLAUDE_PLUGIN_ROOT}/scripts/merge-block.sh" \
  "${CLAUDE_PLUGIN_ROOT}/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
