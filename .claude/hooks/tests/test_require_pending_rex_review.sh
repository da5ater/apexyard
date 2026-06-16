#!/bin/bash
set -u

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
HOOK_DIR="$(cd "$(dirname "$0")/.." && pwd)"
HOOK="$HOOK_DIR/require-pending-rex-review.sh"

case "$HOOK_DIR" in
  */.codex/hooks)
    SESSION_DIR="$ROOT/.codex/session"
    ;;
  *)
    SESSION_DIR="$ROOT/.claude/session"
    ;;
esac

PENDING_DIR="$SESSION_DIR/pending-reviews"
REVIEW_DIR="$SESSION_DIR/reviews"
PENDING="$PENDING_DIR/999"
REX="$REVIEW_DIR/da5ater__apexyard__999-rex.approved"
HEAD_SHA="aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

TMP_BIN=$(mktemp -d)
PASS=0
FAIL=0

pass() { printf 'PASS [%s]\n' "$1"; PASS=$((PASS+1)); }
fail() { printf 'FAIL [%s] %s\n' "$1" "$2" >&2; FAIL=$((FAIL+1)); }

cleanup() {
  rm -f "$PENDING" "$REX"
  rmdir "$PENDING_DIR" "$REVIEW_DIR" 2>/dev/null || true
  rm -rf "$TMP_BIN"
}
trap cleanup EXIT

mkdir -p "$TMP_BIN" "$PENDING_DIR" "$REVIEW_DIR"
cat > "$TMP_BIN/gh" <<EOF_GH
#!/bin/sh
if [ "\$1" = "pr" ] && [ "\$2" = "view" ]; then
  printf '%s\n' "$HEAD_SHA"
  exit 0
fi
exit 0
EOF_GH
chmod +x "$TMP_BIN/gh"

run_hook() {
  PATH="$TMP_BIN:$PATH" printf '%s' "$1" | PATH="$TMP_BIN:$PATH" "$HOOK" 2>&1
}

echo "https://github.com/da5ater/apexyard/pull/999" > "$PENDING"

payload_edit=$(jq -n '{tool_name:"Write", tool_input:{file_path:"src/example.ts"}}')
set +e
out=$(run_hook "$payload_edit")
rc=$?
set -e
if [ "$rc" = "2" ] && printf '%s' "$out" | grep -q "Rex review is still pending"; then
  pass "edit blocked while Rex pending"
else
  fail "edit blocked while Rex pending" "rc=$rc output=[$out]"
fi

payload_commit=$(jq -n '{tool_name:"Bash", tool_input:{command:"git commit -m test"}}')
set +e
out=$(run_hook "$payload_commit")
rc=$?
set -e
if [ "$rc" = "2" ] && printf '%s' "$out" | grep -q "Rex review is still pending"; then
  pass "commit blocked while Rex pending"
else
  fail "commit blocked while Rex pending" "rc=$rc output=[$out]"
fi

payload_review=$(jq -n '{tool_name:"Bash", tool_input:{command:"gh pr review 999 --comment --body ok"}}')
set +e
out=$(run_hook "$payload_review")
rc=$?
set -e
if [ "$rc" = "0" ]; then
  pass "gh pr review allowed while Rex pending"
else
  fail "gh pr review allowed while Rex pending" "rc=$rc output=[$out]"
fi

printf '%s\n' "$HEAD_SHA" > "$REX"
set +e
out=$(run_hook "$payload_edit")
rc=$?
set -e
if [ "$rc" = "0" ] && [ ! -f "$PENDING" ]; then
  pass "matching Rex marker clears pending review"
else
  fail "matching Rex marker clears pending review" "rc=$rc pending_exists=$([ -f "$PENDING" ] && echo yes || echo no) output=[$out]"
fi

echo
echo "===== test_require_pending_rex_review.sh ====="
echo "Passed: $PASS"
echo "Failed: $FAIL"
[ "$FAIL" -eq 0 ]
