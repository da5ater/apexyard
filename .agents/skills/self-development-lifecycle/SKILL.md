---
name: self-development-lifecycle
description: Turn one bounded learning source into a local knowledge-graph learning session with Markdown/HTML artifacts.
argument-hint: "<source.md> [--session-id <id>] [--sessions-dir <dir>]"
allowed-tools: Bash, Read, Grep, Glob, Write, Edit
---

# /self-development-lifecycle — Learning Graph Session

Create an ApexYard-style self-development lifecycle session from one bounded learning source. Phase 1 is local-first and artifact-first: one Markdown source becomes a session folder with canonical graph JSON, Obsidian-readable Markdown, static HTML, branch candidates, event log, and graph-quality gate output.

This skill implements the first build slice for `GH-2`. It does not yet run the full live LLM node interview. It establishes the file contract that later node-loop, note-writing, artifact, final-test, and replay steps build on.

## Usage

```bash
python3 .agents/skills/self-development-lifecycle/run.py path/to/source.md
.agents/skills/self-development-lifecycle/run.py path/to/source.md --session-id redux-toolkit-api-slice
python3 .agents/skills/self-development-lifecycle/run.py path/to/source.md --sessions-dir /path/to/vault/sessions
```

## Outputs

```text
sessions/self-development-lifecycle/<session-id>/
├── source.md
├── graph.json
├── graph.md
├── graph.html
├── branch.json
├── events.jsonl
└── gates/
    └── graph-quality.json
```

## Process

1. Validate the source exists, is Markdown/text, and is small enough for a first session.
2. Copy the source to `source.md`.
3. Generate a deterministic initial graph from Markdown headings, code terms, and source sections.
4. Write `graph.json` as canonical machine state.
5. Write `graph.md` as Obsidian-readable navigation.
6. Write `graph.html` as a static rendered graph with current-node styling and marker capture affordance.
7. Write `branch.json` with 2-4 branch candidates.
8. Run the Graph Quality Gate and write `gates/graph-quality.json`.
9. Append lifecycle events to `events.jsonl`.

## Current Limits

- Graph generation is deterministic and heuristic. It is a scaffold for the later structured-output Graph Builder step.
- HTML marker placement is local/browser-side only in this slice. The generated page exposes marker JSON that can be copied into a future graph revision.
- Node loop, answer scoring, notion notes, artifact generation, final test, and replay mode are follow-up slices.

## Gate

The first slice passes when:

- `graph.json`, `graph.md`, `graph.html`, `branch.json`, `source.md`, and `events.jsonl` exist.
- Every graph node has an ID, title, summary, kind, status, and source reference.
- Every edge references existing nodes.
- At least one branch candidate exists.
- `gates/graph-quality.json` reports `pass: true`.

---

*Part of [ApexYard](https://github.com/me2resh/apexyard) — multi-project SDLC framework for Codex · MIT.*
