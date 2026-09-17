#!/usr/bin/env bash
# Usage: delegate.sh <spec.md> ["chunk description"] [low|medium|high]
set -euo pipefail

spec="${1:?spec path required}"
chunk="${2:-the whole spec}"
effort="${3:-medium}"
[ -f "$spec" ] || { echo "Spec not found: $spec"; exit 2; }
command -v codex >/dev/null || { echo "codex CLI not on PATH"; exit 2; }

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Not inside a git repository."; exit 2; }

if [ -n "$(git status --porcelain)" ] && [ "${ALLOW_DIRTY:-0}" != "1" ]; then
  echo "Working tree not clean. Commit or stash first (or ALLOW_DIRTY=1)."
  exit 2
fi

name="$(basename "$spec" .md)"
stamp="$(date +%Y%m%d-%H%M%S)"
mkdir -p tasks/.logs
result="tasks/.logs/$name-$stamp.result.md"
log="tasks/.logs/$name-$stamp.log"

prompt="Read $spec and implement: $chunk.
Follow AGENTS.md and the project's CONVENTIONS.md and ARCHITECTURE.md if present.
Do not change anything listed under 'Out' in the spec.
Loop until all pass: dart format lib test, flutter analyze, flutter test.
Do not commit.
Final message format, nothing else:
STATUS: done | blocked
SUMMARY: at most 5 lines
DEVIATIONS: spec deviations or 'none'
BLOCKERS: what stopped you or 'none'"

code=0
codex exec \
  --sandbox workspace-write \
  -c model_reasoning_effort="$effort" \
  --output-last-message "$result" \
  "$prompt" >"$log" 2>&1 || code=$?

echo "=== Codex result ($name) ==="
if [ -s "$result" ]; then cat "$result"; else echo "No result file. Last log lines:"; tail -n 15 "$log"; fi
echo
echo "=== git diff --stat ==="
git diff --stat
echo "(full log: $log)"
exit "$code"
