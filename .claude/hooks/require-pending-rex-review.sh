#!/bin/bash
# Fail-closed guard for the auto-code-review handoff.
#
# auto-code-review.sh runs after `gh pr create` and writes:
#   .claude/session/pending-reviews/<pr>
#
# Hooks cannot directly launch an AI sub-agent in every runtime. This hook
# makes the handoff mechanical anyway: while a pending Rex review exists, block
# normal write/commit/push/merge work until the matching Rex marker exists for
# the PR's current HEAD.

set -u

INPUT=$(cat)
TOOL_NAME=$(printf '%s' "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)
COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

HOOK_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || true)

if [ -f "$HOOK_DIR/_lib-ops-root.sh" ]; then
  # shellcheck source=/dev/null
  . "$HOOK_DIR/_lib-ops-root.sh"
  OPS_ROOT=$(resolve_ops_root "${REPO_ROOT:-$PWD}")
else
  OPS_ROOT="${REPO_ROOT:-$PWD}"
fi

MARKER_HOME="${OPS_ROOT:-${REPO_ROOT:-.}}"
PENDING_DIR="$MARKER_HOME/.claude/session/pending-reviews"

[ -d "$PENDING_DIR" ] || exit 0

# shellcheck source=/dev/null
. "$HOOK_DIR/_lib-review-markers.sh"

origin_repo() {
  git -C "${REPO_ROOT:-$PWD}" remote get-url origin 2>/dev/null \
    | sed -nE 's|.*[:/]([^/:]+/[^/]+)\.git$|\1|p; s|.*[:/]([^/:]+/[^/]+)$|\1|p' \
    | head -1
}

repo_from_url() {
  printf '%s' "$1" | sed -nE 's|^https://github\.com/([^/]+/[^/]+)/pull/[0-9]+.*|\1|p'
}

pr_from_url() {
  printf '%s' "$1" | sed -nE 's|^https://github\.com/[^/]+/[^/]+/pull/([0-9]+).*|\1|p'
}

command_is_allowed_while_pending() {
  case "$TOOL_NAME" in
    Bash) ;;
    apply_patch|Edit|Write|MultiEdit) return 1 ;;
    *) return 0 ;;
  esac

  # Let Rex do the review and record the result. These commands are review
  # workflow, not implementation work.
  if printf '%s' "$COMMAND" | grep -qE '\bgh[[:space:]]+pr[[:space:]]+(view|diff|checks|review|comment)\b'; then
    return 0
  fi
  if printf '%s' "$COMMAND" | grep -qE '\bcodex[[:space:]]+exec([[:space:]].*)?[[:space:]]+review\b'; then
    return 0
  fi

  # Block common state-changing commands while Rex is pending.
  if printf '%s' "$COMMAND" | grep -qE '\bgit[[:space:]]+(add|commit|push|merge|rebase|cherry-pick|tag)\b'; then
    return 1
  fi
  if printf '%s' "$COMMAND" | grep -qE '\bgh[[:space:]]+pr[[:space:]]+(create|merge)\b'; then
    return 1
  fi

  # Block Bash file writes, except the Rex review marker write itself.
  if [ -f "$HOOK_DIR/_lib-detect-bash-write.sh" ]; then
    # shellcheck source=/dev/null
    . "$HOOK_DIR/_lib-detect-bash-write.sh"
    if bash_command_appears_to_write "$COMMAND" &&
       ! printf '%s' "$COMMAND" | grep -qE '\.claude/session/reviews/.*-rex\.approved'; then
      return 1
    fi
  fi

  return 0
}

blocked=""
for pending in "$PENDING_DIR"/*; do
  [ -f "$pending" ] || continue

  pr=$(basename "$pending")
  url=$(cat "$pending" 2>/dev/null || true)
  url_pr=$(pr_from_url "$url")
  [ -n "$url_pr" ] && pr="$url_pr"

  repo=$(repo_from_url "$url")
  [ -n "$repo" ] || repo=$(origin_repo)
  [ -n "$repo" ] || repo="unknown"

  head=$(gh pr view "$pr" --repo "$repo" --json headRefOid -q '.headRefOid' 2>/dev/null || true)
  [ -n "$head" ] || continue

  rex_marker=$(review_marker_path "$repo" "$pr" rex "$MARKER_HOME")
  if [ -f "$rex_marker" ] && [ "$(tr -d '[:space:]' < "$rex_marker")" = "$head" ]; then
    rm -f "$pending"
    continue
  fi

  blocked="${blocked}${repo}#${pr} @ ${head}
"
done

[ -n "$blocked" ] || exit 0

if command_is_allowed_while_pending; then
  exit 0
fi

cat >&2 <<MSG
BLOCKED: Rex review is still pending.

ApexYard created a pending Rex marker after PR creation. Before continuing with
normal implementation, commit, push, PR-create, or merge work, run Rex and let it
write the matching approval marker for the current PR HEAD.

Pending:
${blocked}
Allowed next actions:
  - run the code-reviewer/Rex workflow for the pending PR
  - inspect the PR with gh pr view/diff/checks
  - post the Rex review with gh pr review

This is a mechanical guard, not a reminder. It exists because Codex hooks cannot
reliably spawn a custom agent themselves.
MSG
exit 2
