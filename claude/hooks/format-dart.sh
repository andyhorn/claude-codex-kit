#!/usr/bin/env bash
# Formats the edited file if it's Dart. Silent on success so it costs no tokens.
file="$(jq -r '.tool_input.file_path // empty')"
[[ "$file" == *.dart && -f "$file" ]] || exit 0
[[ "$file" == *.g.dart || "$file" == *.freezed.dart ]] && exit 0
dart format "$file" >/dev/null 2>&1 || true
exit 0
