#!/usr/bin/env bash
# /self-development-lifecycle smoke test.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TMPROOT=$(mktemp -d -t self-development-lifecycle-XXXXXX)
trap 'rm -rf "$TMPROOT"' EXIT

SOURCE="$TMPROOT/redux-toolkit.md"
OUT="$TMPROOT/sessions"

cat > "$SOURCE" <<'MD'
# Redux Toolkit API Slice

An API slice declares how Redux Toolkit Query talks to a server.

## Store setup

The Redux store needs the API reducer and middleware.

```ts
configureStore({
  reducer: { [api.reducerPath]: api.reducer },
  middleware: (getDefaultMiddleware) => getDefaultMiddleware().concat(api.middleware)
})
```

## createApi

`createApi` defines endpoints and cache behavior.

## baseQuery

`fetchBaseQuery` wraps the HTTP client details.
MD

session_path=$(python3 "$SKILL_DIR/run.py" "$SOURCE" --session-id redux-api-slice --sessions-dir "$OUT")
"$SKILL_DIR/run.py" --help >/dev/null

required=(
  source.md
  graph.json
  graph.md
  graph.html
  branch.json
  events.jsonl
  gates/graph-quality.json
)

for rel in "${required[@]}"; do
  test -s "$session_path/$rel"
  echo "PASS: $rel exists"
done

python3 - "$session_path" <<'PY'
import json
import pathlib
import sys

root = pathlib.Path(sys.argv[1])
graph = json.loads((root / "graph.json").read_text())
branch = json.loads((root / "branch.json").read_text())
gate = json.loads((root / "gates/graph-quality.json").read_text())
events = (root / "events.jsonl").read_text().strip().splitlines()

assert graph["schemaVersion"] == 1
assert graph["source"]["contentPath"] == "source.md"
assert graph["currentNodeId"] in {node["id"] for node in graph["nodes"]}
assert len(graph["nodes"]) >= 4
assert branch["branchCandidates"]
assert gate["pass"] is True, gate
assert len(events) == 3
print("PASS: graph contract valid")
PY

grep -q "Marker Capture" "$session_path/graph.html"
grep -q "Branch Candidates" "$session_path/graph.md"
echo "PASS: rendered artifacts contain expected sections"
