#!/bin/bash
set -u

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
HOOK_DIR="$(cd "$(dirname "$0")/.." && pwd)"
HOOK="$HOOK_DIR/auto-code-review.sh"

case "$HOOK_DIR" in
  */.codex/hooks)
    SESSION_DIR="$ROOT/.codex/session"
    EXPECTED_INSTRUCTION="agent: code-reviewer"
    ;;
  *)
    SESSION_DIR="$ROOT/.claude/session"
    EXPECTED_INSTRUCTION="subagent_type: code-reviewer"
    ;;
esac

MARKER="$SESSION_DIR/pending-reviews/999"

PASS=0
FAIL=0

pass() { printf 'PASS [%s]\n' "$1"; PASS=$((PASS+1)); }
fail() { printf 'FAIL [%s] %s\n' "$1" "$2" >&2; FAIL=$((FAIL+1)); }

cleanup() {
  rm -f "$MARKER"
  rmdir "$SESSION_DIR/pending-reviews" 2>/dev/null || true
}
trap cleanup EXIT
cleanup

payload=$(jq -n '{
  tool_name: "Bash",
  tool_input: {command: "gh pr create --title test --body test"},
  tool_response: {stdout: "https://github.com/da5ater/apexyard/pull/999"}
}')

set +e
output=$(printf '%s' "$payload" | "$HOOK" 2>&1)
rc=$?
set -e

if [ "$rc" = "2" ]; then
  pass "post-pr-create exits 2 to force visible Rex follow-up"
else
  fail "post-pr-create exit" "expected rc=2, got rc=$rc; output=[$output]"
fi

if printf '%s' "$output" | grep -q "AUTO CODE REVIEW REQUIRED"; then
  pass "Rex reminder banner emitted"
else
  fail "Rex reminder banner" "missing AUTO CODE REVIEW REQUIRED; output=[$output]"
fi

if printf '%s' "$output" | grep -q "$EXPECTED_INSTRUCTION"; then
  pass "runtime-specific Rex instruction emitted"
else
  fail "runtime-specific Rex instruction" "missing $EXPECTED_INSTRUCTION; output=[$output]"
fi

if [ -f "$MARKER" ] && [ "$(cat "$MARKER")" = "https://github.com/da5ater/apexyard/pull/999" ]; then
  pass "pending review marker written"
else
  fail "pending review marker" "marker missing or wrong"
fi

echo
echo "===== test_auto_code_review.sh ====="
echo "Passed: $PASS"
echo "Failed: $FAIL"
[ "$FAIL" -eq 0 ]
