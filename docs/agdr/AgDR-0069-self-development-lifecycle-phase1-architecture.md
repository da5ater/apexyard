---
id: AgDR-0069
timestamp: 2026-06-16T00:00:00Z
agent: codex
model: gpt-5
session: unknown
trigger: user-prompt
status: executed
category: architecture
projects: [apexyard]
---

# Self-Development Lifecycle Phase 1 Architecture

> In the context of building the first self-development lifecycle proof from IDEA-001, facing the risk of prematurely building a GUI or losing learning state inside chat, I decided to build Phase 1 as an ApexYard-style agent skill/workflow with local artifact persistence, canonical graph JSON, Markdown/HTML projections, and explicit learning gates to achieve deterministic, reviewable learning sessions, accepting that the first version is less polished for non-technical users.

## Context

- The product goal is to prove an agent-first learning workflow before building a polished GUI or app shell.
- The first validation sources are the user's Redux Toolkit course notes and later UBC Systematic Program Design sections.
- The core risk is not UI polish; it is whether the knowledge graph can identify prerequisites, missing nodes, and misconceptions, then preserve useful notes/artifacts/test evidence.
- The design intentionally borrows ApexYard's operating model: durable markdown artifacts, lifecycle phases, explicit gates, and reviewable state.
- The user confirmed the subordinate architecture decisions: strict structured outputs for machine state, deterministic replay harness, clean architecture layering, Mermaid-by-default diagram artifacts, and `graph.json`/`graph.md`/`graph.html` graph projections.

## Options Considered

| Option | Pros | Cons |
|--------|------|------|
| Build a polished app first | Best eventual UX; direct graph and marker interactions | High implementation cost; risks hiding whether the learning loop works; artifact model may churn under UI code |
| Build a throwaway spike for one or two nodes | Fastest signal; low commitment | Too small to test the actual product loop; does not prove full branch lifecycle or artifact preservation |
| Build an ApexYard-style agent workflow with local artifacts | Tests the real learning lifecycle; keeps state inspectable; supports deterministic replay; Obsidian can view Markdown/HTML | Less polished; requires the user to tolerate file-based workflow in Phase 1 |
| Build only prompt templates without persisted artifacts | Fast to iterate prompts | Repeats the original chat-only failure mode; no deterministic replay, gates, or durable evidence |

## Decision

Chosen: **Build an ApexYard-style agent workflow with local artifacts**, because the project must prove the graph/node-loop/artifact/test lifecycle before investing in a GUI, and local durable artifacts make the AI workflow inspectable, replayable, and gateable.

The Phase 1 architecture uses:

- an agent skill/workflow as the runtime surface
- local session folders as the persistence boundary
- `graph.json` as the canonical machine-readable graph source of truth
- `graph.md` as the Obsidian-readable graph/navigation artifact
- `graph.html` as the rendered view with current-position and user markers
- self-development lifecycle phases: Intake, Graph Design, Branch Selection, Node Loop, Artifact Preservation, Final Test, Review
- mechanical gates for graph quality, artifact quality, and final-test readiness

## Consequences

- The first implementation should not build a GUI, Obsidian plugin, hosted backend, or Anki sync.
- All important learning state must be written to files, not only carried in chat context.
- The technical design must define schema, gates, and replay harness before build.
- Future GUI work should sit over the same artifacts after Phase 1 proves repeated personal value.
- The approach may feel less smooth initially, but that is an explicit trade-off to learn faster and keep the workflow deterministic.

## Artifacts

- `projects/ideas-backlog.md`
- `projects/_inbox/research/IDEA-001-raw-idea-notes.md`
- `projects/_inbox/validation/IDEA-001-validation.md`
- `projects/_inbox/prds/IDEA-001-gamified-llm-wiki-prd.md`
- `projects/_inbox/technical-designs/IDEA-001-gamified-llm-wiki-technical-design.md`
- `projects/initiatives/self-development-lifecycle.md`
- GitHub issues: `da5ater/apexyard#1`, `da5ater/apexyard#2`
