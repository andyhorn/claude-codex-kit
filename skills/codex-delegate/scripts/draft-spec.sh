#!/usr/bin/env bash
# Usage: draft-spec.sh <feature-name> "<brief>" [low|medium|high]
# Codex explores the codebase and drafts tasks/<feature-name>.md from the
# spec template. It writes no implementation code and leaves routing to Claude.
set -euo pipefail

name="${1:?feature name required}"
brief="${2:?brief required: one or two sentences on what to build}"
effort="${3:-medium}"

case "$name" in
  */*|.*) echo "Feature name must be a bare slug, e.g. recipe-import"; exit 2 ;;
esac

command -v codex >/dev/null || { echo "codex CLI not on PATH"; exit 2; }
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Not inside a git repository."; exit 2; }

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
template="$here/../../feature-workflow/references/spec-template.md"
[ -f "$template" ] || { echo "Spec template not found: $template"; exit 2; }

spec="tasks/$name.md"
[ -e "$spec" ] && { echo "$spec already exists. Edit it, or delete it first."; exit 2; }

stamp="$(date +%Y%m%d-%H%M%S)"
mkdir -p tasks/.logs
result="tasks/.logs/$name-$stamp.draft.md"
log="tasks/.logs/$name-$stamp.draft.log"

dirty() { git status --porcelain --untracked-files=all | cut -c4- | grep -v '^tasks/\.logs/' || true; }
before="$(dirty)"

prompt="Draft an implementation spec. Do not write any implementation code.

What to build: $brief

Steps:
1. Read the template at $template. Your output uses its exact section headings.
2. Explore this codebase to ground the spec in what already exists. Find the
   closest existing feature and name the specific file to copy patterns from.
   Follow AGENTS.md and the project's CONVENTIONS.md and ARCHITECTURE.md if present.
3. Write the filled-in spec to $spec. That is the ONLY file you may create or
   modify. Everything else is read-only.

Rules for the spec:
- Public API signatures and acceptance criteria carry the weight. Prose does not.
- 'Files' must name real paths that exist, or plausible new ones beside them.
- 'Out (do not touch)' must be filled in, not left blank.
- Leave the Execution table with its header row and no rows. Routing is not yours.
- Where you had to guess at a decision, still write your best guess into the
  spec, and list it under QUESTIONS below. Do not leave TODOs in the spec.

Final message format, nothing else:
STATUS: drafted | blocked
SPEC: $spec
PATTERNS: existing files this spec copies from, at most 5 lines
QUESTIONS: decisions you guessed at and Claude should confirm, at most 5 lines, or 'none'
BLOCKERS: what stopped you or 'none'"

code=0
codex exec \
  --sandbox workspace-write \
  -c model_reasoning_effort="$effort" \
  --output-last-message "$result" \
  "$prompt" >"$log" 2>&1 || code=$?

echo "=== Codex draft ($name) ==="
if [ -s "$result" ]; then cat "$result"; else echo "No result file. Last log lines:"; tail -n 15 "$log"; fi

echo
if [ -f "$spec" ]; then
  echo "=== $spec ($(wc -l <"$spec" | tr -d ' ') lines) ==="
else
  echo "!! $spec was not created."
  code=${code:-1}; [ "$code" -eq 0 ] && code=1
fi

stray="$(comm -13 <(printf '%s\n' "$before" | sort -u) <(dirty | sort -u) | grep -vxF "$spec" || true)"
if [ -n "$stray" ]; then
  echo
  echo "!! Codex touched files outside the spec. Review before trusting the draft:"
  printf '%s\n' "$stray" | sed 's/^/   /'
fi

echo "(full log: $log)"
exit "$code"
