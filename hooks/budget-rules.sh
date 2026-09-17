#!/usr/bin/env bash
# SessionStart: injects the kit's budget rules as ambient context, so routing
# discipline applies to ad-hoc requests and not only inside feature-workflow.
# Must use hookSpecificOutput.additionalContext — plain stdout on SessionStart
# renders as a status line and never reaches the model.
set -euo pipefail
src="${CLAUDE_PLUGIN_ROOT}/context/budget-rules.md"
[ -f "$src" ] || exit 0

SRC="$src" python3 -c '
import json, os, sys
with open(os.environ["SRC"]) as f:
    rules = f.read()
json.dump({"hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": rules,
}}, sys.stdout)
'
