#!/usr/bin/env bash
# Usage: verify.sh [test path]   (defaults to all tests)
set -uo pipefail
log_dir=".dart_tool/verify"; mkdir -p "$log_dir"
max_lines="${VERIFY_MAX_LINES:-60}"

dart format lib test >/dev/null 2>&1

if ! flutter analyze >"$log_dir/analyze.log" 2>&1; then
  echo "ANALYZE FAILED ($(grep -cE '^\s*(error|warning|info) ' "$log_dir/analyze.log") issues)"
  grep -E '^\s*(error|warning) ' "$log_dir/analyze.log" | head -n "$max_lines"
  echo "full log: $log_dir/analyze.log"
  exit 1
fi

test_args=()
[ -n "${1:-}" ] && test_args=("$1")

if ! flutter test --reporter expanded "${test_args[@]}" >"$log_dir/test.log" 2>&1; then
  echo "TESTS FAILED"
  grep -E '\[E\]|Expected:|Actual:|Error:|^\s+test/.*\.dart [0-9]+:[0-9]+' "$log_dir/test.log" | head -n "$max_lines"
  tail -n 3 "$log_dir/test.log"
  echo "full log: $log_dir/test.log"
  exit 1
fi

echo "PASS: format, analyze, test ($(tail -n 1 "$log_dir/test.log"))"
