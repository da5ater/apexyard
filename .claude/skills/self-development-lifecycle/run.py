#!/usr/bin/env python3
"""Create a local self-development lifecycle session from one Markdown source."""

from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import html
import json
import re
import shutil
import sys
from pathlib import Path


MAX_SOURCE_BYTES = 120_000
STOP_WORDS = {
    "about",
    "after",
    "also",
    "from",
    "have",
    "into",
    "that",
    "their",
    "there",
    "this",
    "with",
    "your",
}


def slugify(value: str, fallback: str = "item") -> str:
    value = re.sub(r"([a-z0-9])([A-Z])", r"\1-\2", value)
    slug = re.sub(r"[^a-z0-9]+", "-", value.lower()).strip("-")
    return slug or fallback


def utc_now() -> str:
    return dt.datetime.now(dt.timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def read_source(path: Path) -> str:
    if not path.exists() or not path.is_file():
        raise SystemExit(f"SOURCE_NOT_FOUND: {path}")
    size = path.stat().st_size
    if size > MAX_SOURCE_BYTES:
        raise SystemExit(
            f"SOURCE_TOO_LARGE: {path} is {size} bytes; keep the first proof to one article/tutorial."
        )
    return path.read_text(encoding="utf-8")


def source_title(path: Path, text: str) -> str:
    for line in text.splitlines():
        match = re.match(r"^\s*#\s+(.+?)\s*$", line)
        if match:
            return match.group(1).strip()
    return path.stem.replace("-", " ").replace("_", " ").title()


def sections_from_markdown(text: str) -> list[dict]:
    sections: list[dict] = []
    current = {"title": "", "level": 0, "start_line": 1, "lines": []}
    for line_no, line in enumerate(text.splitlines(), start=1):
        heading = re.match(r"^(#{1,4})\s+(.+?)\s*$", line)
        if heading:
            if current["title"] or current["lines"]:
                sections.append(current)
            current = {
                "title": heading.group(2).strip(),
                "level": len(heading.group(1)),
                "start_line": line_no,
                "lines": [],
            }
        else:
            current["lines"].append(line)
    if current["title"] or current["lines"]:
        sections.append(current)
    return [s for s in sections if s["title"] or any(line.strip() for line in s["lines"])]


def first_sentence(lines: list[str], fallback: str) -> str:
    body = " ".join(line.strip() for line in lines if line.strip() and not line.strip().startswith("```"))
    body = re.sub(r"\s+", " ", body).strip()
    if not body:
        return fallback
    sentence = re.split(r"(?<=[.!?])\s+", body)[0]
    return sentence[:240]


def code_terms(text: str) -> list[str]:
    terms = re.findall(r"`([^`\n]{3,48})`", text)
    cleaned = []
    seen = set()
    for term in terms:
        value = term.strip()
        key = value.lower()
        if key in seen or key in STOP_WORDS:
            continue
        if re.search(r"\s{3,}", value):
            continue
        seen.add(key)
        cleaned.append(value)
    return cleaned[:6]


def build_graph(path: Path, text: str, session_id: str) -> tuple[dict, list[dict]]:
    title = source_title(path, text)
    sections = sections_from_markdown(text)
    if not sections:
        sections = [{"title": title, "level": 1, "start_line": 1, "lines": text.splitlines()}]

    nodes = []
    used_ids = set()
    for index, section in enumerate(sections[:10], start=1):
        title_text = section["title"] or f"{title} concept {index}"
        base_id = slugify(title_text, f"node-{index}")
        node_id = base_id
        suffix = 2
        while node_id in used_ids:
            node_id = f"{base_id}-{suffix}"
            suffix += 1
        used_ids.add(node_id)
        nodes.append(
            {
                "id": node_id,
                "title": title_text,
                "summary": first_sentence(section["lines"], f"Understand {title_text} from the source."),
                "kind": "core" if index <= 4 else "neighboring",
                "status": "pending",
                "sourceRefs": [{"sourceId": "source", "line": section["start_line"], "excerpt": title_text}],
                "notePath": f"notes/{node_id}.md",
            }
        )

    for term in code_terms(text):
        node_id = slugify(term, "code-term")
        if node_id in used_ids:
            continue
        used_ids.add(node_id)
        nodes.append(
            {
                "id": node_id,
                "title": term,
                "summary": f"Clarify how `{term}` is used in the source.",
                "kind": "prerequisite",
                "status": "pending",
                "sourceRefs": [{"sourceId": "source", "line": None, "excerpt": f"`{term}`"}],
                "notePath": f"notes/{node_id}.md",
            }
        )

    edges = []
    for index in range(len(nodes) - 1):
        edges.append(
            {
                "from": nodes[index]["id"],
                "to": nodes[index + 1]["id"],
                "kind": "prerequisite",
                "rationale": "Initial deterministic ordering from source structure.",
            }
        )

    branch_nodes = nodes[: min(5, len(nodes))]
    branches = [
        {
            "id": "main-source-branch",
            "label": f"Main path through {title}",
            "nodeIds": [node["id"] for node in branch_nodes],
            "rationale": "Follows the first concepts in source order for the initial learning pass.",
        }
    ]
    if len(nodes) > 3:
        branches.append(
            {
                "id": "core-concepts",
                "label": "Core concepts only",
                "nodeIds": [node["id"] for node in nodes if node["kind"] == "core"][:4],
                "rationale": "Focuses the first interview on the core nodes before neighboring details.",
            }
        )

    graph = {
        "schemaVersion": 1,
        "sessionId": session_id,
        "source": {"id": "source", "title": title, "kind": "markdown_file", "contentPath": "source.md"},
        "currentNodeId": nodes[0]["id"] if nodes else None,
        "nodes": nodes,
        "edges": edges,
        "userMarkers": [],
        "revisions": [
            {
                "id": "rev-001",
                "createdAt": utc_now(),
                "kind": "initial_graph",
                "rationale": "Initial deterministic graph scaffold from Markdown structure.",
            }
        ],
    }
    return graph, branches[:4]


def graph_quality(graph: dict, branches: list[dict]) -> dict:
    errors = []
    node_ids = {node.get("id") for node in graph.get("nodes", [])}
    for node in graph.get("nodes", []):
        for key in ("id", "title", "summary", "kind", "status", "sourceRefs"):
            if not node.get(key):
                errors.append(f"node {node.get('id', '<missing>')} missing {key}")
    for edge in graph.get("edges", []):
        if edge.get("from") not in node_ids or edge.get("to") not in node_ids:
            errors.append(f"edge references unknown node: {edge}")
    if not branches:
        errors.append("no branch candidates")
    if graph.get("currentNodeId") not in node_ids:
        errors.append("currentNodeId does not reference a node")
    return {
        "gate": "graph-quality",
        "pass": not errors,
        "checkedAt": utc_now(),
        "errors": errors,
        "summary": "Graph has grounded nodes, valid edges, current node, and branch candidates."
        if not errors
        else "Graph quality gate failed.",
    }


def write_json(path: Path, data: dict) -> None:
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def write_graph_md(path: Path, graph: dict, branches: list[dict]) -> None:
    lines = [
        f"# {graph['source']['title']} Knowledge Graph",
        "",
        f"Session: `{graph['sessionId']}`",
        f"Current node: [[{graph['currentNodeId']}]]",
        "",
        "## Branch Candidates",
        "",
    ]
    for branch in branches:
        node_links = " -> ".join(f"[[{node_id}]]" for node_id in branch["nodeIds"])
        lines.append(f"- **{branch['label']}** (`{branch['id']}`): {node_links}")
    lines.extend(["", "## Nodes", ""])
    for node in graph["nodes"]:
        marker = " (current)" if node["id"] == graph["currentNodeId"] else ""
        lines.extend(
            [
                f"### {node['title']}{marker}",
                "",
                f"- ID: `{node['id']}`",
                f"- Kind: `{node['kind']}`",
                f"- Status: `{node['status']}`",
                f"- Summary: {node['summary']}",
                f"- Note: `{node['notePath']}`",
                "",
            ]
        )
    path.write_text("\n".join(lines), encoding="utf-8")


def write_graph_html(path: Path, graph: dict, branches: list[dict]) -> None:
    nodes = graph["nodes"]
    node_cards = []
    for node in nodes:
        classes = "node current" if node["id"] == graph["currentNodeId"] else "node"
        node_cards.append(
            f'<button class="{classes}" data-node-id="{html.escape(node["id"])}">'
            f'<span>{html.escape(node["title"])}</span>'
            f'<small>{html.escape(node["kind"])} · {html.escape(node["status"])}</small>'
            "</button>"
        )
    branch_items = "".join(
        f"<li><strong>{html.escape(branch['label'])}</strong>: "
        f"{html.escape(' -> '.join(branch['nodeIds']))}</li>"
        for branch in branches
    )
    content = f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{html.escape(graph['source']['title'])} Knowledge Graph</title>
  <style>
    body {{ font: 15px/1.45 system-ui, sans-serif; margin: 0; color: #17202a; background: #f7f7f4; }}
    main {{ max-width: 980px; margin: 0 auto; padding: 24px; }}
    .graph {{ display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 10px; }}
    .node {{ text-align: left; border: 1px solid #ccd2d6; background: white; border-radius: 6px; padding: 12px; min-height: 86px; cursor: crosshair; }}
    .node span {{ display: block; font-weight: 700; margin-bottom: 8px; }}
    .node small {{ color: #59656f; }}
    .current {{ border-color: #0f766e; box-shadow: inset 4px 0 0 #0f766e; }}
    textarea {{ width: 100%; min-height: 120px; margin-top: 14px; font: 13px/1.4 ui-monospace, monospace; }}
  </style>
</head>
<body>
<main>
  <h1>{html.escape(graph['source']['title'])} Knowledge Graph</h1>
  <p>Session <code>{html.escape(graph['sessionId'])}</code>. Current node: <code>{html.escape(str(graph['currentNodeId']))}</code>.</p>
  <section class="graph" aria-label="Knowledge graph nodes">
    {''.join(node_cards)}
  </section>
  <h2>Branch Candidates</h2>
  <ul>{branch_items}</ul>
  <h2>Marker Capture</h2>
  <p>Click a node to create marker JSON for the next graph revision.</p>
  <textarea id="marker" aria-label="Marker JSON" readonly></textarea>
</main>
<script>
document.querySelectorAll('.node').forEach((node) => {{
  node.addEventListener('click', () => {{
    const marker = {{
      markerId: 'marker-' + Date.now(),
      targetType: 'node',
      targetId: node.dataset.nodeId,
      note: 'Learner placed marker on graph node'
    }};
    document.getElementById('marker').value = JSON.stringify(marker, null, 2);
  }});
}});
</script>
</body>
</html>
"""
    path.write_text(content, encoding="utf-8")


def append_event(events_path: Path, phase: str, outputs: list[str], validation: str = "pass") -> None:
    event = {
        "eventId": hashlib.sha1(f"{phase}:{utc_now()}:{outputs}".encode()).hexdigest()[:12],
        "createdAt": utc_now(),
        "phase": phase,
        "outputArtifacts": outputs,
        "validation": validation,
    }
    with events_path.open("a", encoding="utf-8") as handle:
        handle.write(json.dumps(event, ensure_ascii=False) + "\n")


def create_session(args: argparse.Namespace) -> Path:
    source_path = Path(args.source).resolve()
    source_text = read_source(source_path)
    session_id = args.session_id or f"{slugify(source_title(source_path, source_text))}-{utc_now()[:10]}"
    sessions_dir = Path(args.sessions_dir)
    session_dir = sessions_dir / session_id
    if session_dir.exists() and not args.force:
        raise SystemExit(f"SESSION_EXISTS: {session_dir} (use --force to replace)")
    if session_dir.exists():
        shutil.rmtree(session_dir)
    (session_dir / "gates").mkdir(parents=True, exist_ok=True)

    shutil.copyfile(source_path, session_dir / "source.md")
    append_event(session_dir / "events.jsonl", "intake", ["source.md"])

    graph, branches = build_graph(source_path, source_text, session_id)
    write_json(session_dir / "graph.json", graph)
    write_json(
        session_dir / "branch.json",
        {
            "schemaVersion": 1,
            "sessionId": session_id,
            "selectedBranchId": branches[0]["id"] if branches else None,
            "branchCandidates": branches,
        },
    )
    write_graph_md(session_dir / "graph.md", graph, branches)
    write_graph_html(session_dir / "graph.html", graph, branches)
    append_event(session_dir / "events.jsonl", "graph-design", ["graph.json", "graph.md", "graph.html", "branch.json"])

    gate = graph_quality(graph, branches)
    write_json(session_dir / "gates" / "graph-quality.json", gate)
    append_event(session_dir / "events.jsonl", "graph-quality-gate", ["gates/graph-quality.json"], "pass" if gate["pass"] else "fail")

    if not gate["pass"]:
        raise SystemExit(f"GRAPH_LOW_CONFIDENCE: {session_dir / 'gates' / 'graph-quality.json'}")
    return session_dir


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", help="Path to one bounded Markdown/text source")
    parser.add_argument("--session-id", help="Stable session ID to use for output folder")
    parser.add_argument("--sessions-dir", default="sessions/self-development-lifecycle", help="Directory where session folders are written")
    parser.add_argument("--force", action="store_true", help="Replace an existing session folder")
    args = parser.parse_args()

    session_dir = create_session(args)
    print(session_dir)
    return 0


if __name__ == "__main__":
    sys.exit(main())
