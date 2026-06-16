<!-- Source: IDEA-001 · Created after approved PRD -->

# Technical Design: Gamified LLM Wiki for self-directed learning

**Status**: In Review
**Author**: Hisham (Tech Lead)
**Date**: 2026-06-15
**PRD**: [projects/_inbox/prds/IDEA-001-gamified-llm-wiki-prd.md](../prds/IDEA-001-gamified-llm-wiki-prd.md)
**Raw Notes**: [projects/_inbox/research/IDEA-001-raw-idea-notes.md](../research/IDEA-001-raw-idea-notes.md)
**Initiative**: [projects/initiatives/self-development-lifecycle.md](../../initiatives/self-development-lifecycle.md)
**Architecture Decision**: [docs/agdr/AgDR-0069-self-development-lifecycle-phase1-architecture.md](../../../docs/agdr/AgDR-0069-self-development-lifecycle-phase1-architecture.md)

---

## Overview

### Summary

Build an agent-first self-development lifecycle skill that ingests one small Markdown/text source, creates a prerequisite-aware knowledge tree/graph, guides the learner through one selected branch, updates graph and notes during live open-ended testing, and persists Obsidian-readable Markdown/HTML artifacts into the learner's vault.

This is a feature build, not a spike. The scope is already narrowed to the smallest real workflow that proves the product: one source, one selected branch, every node in that branch, live graph/note updates, notion artifacts, final test, and review.

The first implementation intentionally follows ApexYard's operating style: markdown-first, agent-first, lifecycle-driven, gate-based, and artifact-centered. A polished GUI/application surface is deferred until this workflow proves valuable in repeated personal use.

### Goals

- Keep the first proof agent-driven and file-based: pasted text or local Markdown in, Markdown/HTML artifacts out.
- Model graph, node loops, notions, artifacts, scoring, and final test as durable files, not ephemeral chat.
- Use a skill/orchestrator with specialized agent steps for graph creation, node loop, artifact generation, scoring, and gate checks.
- Treat the workflow as a self-development lifecycle, analogous to ApexYard's SDLC but for learning: source intake, graph design, branch walkthrough, artifact preservation, final test, review.
- Render the graph with current-position and user-placed markers through Obsidian-readable Markdown/HTML so the learner can orient and intervene.
- Create enough structure that later Anki, gamification, media ingestion, and app UI can attach without rewriting the core learning model.

### Non-Goals

- Building an Obsidian plugin or full custom app shell.
- Building the polished application surface that organizes all artifacts beautifully for non-technical navigation.
- Native Anki sync or spaced repetition scheduling.
- Automated ingestion of external reference systems, books, courses, or creator content.
- Video/audio transcription, course-platform ingestion, or transcript parsing.
- Multi-user sharing, achievements, levels, or social proof.
- Production authentication, hosted storage, billing, or collaboration.
- Throwaway prototype work that only exercises one or two nodes without completing the branch lifecycle.

### Phased Architecture

| Phase | Architecture | Exit Criteria |
|-------|--------------|---------------|
| Phase 1 — ApexYard-style workflow | Agent skill/workflow, local session folders, Markdown/HTML artifacts, Obsidian as viewer, lifecycle gates | The user's Redux Toolkit learning source produces useful graph, branch loop, notes, artifacts, final test, and review summary. |
| Phase 2 — GUI/app surface | Dedicated application shell over the same artifacts and lifecycle state | Begin only after Phase 1 shows repeated value and the artifact schema stabilizes. |

---

## Domain Model

### Entities

```text
LearningSession
├── id: SessionId
├── source: SourceDocument
├── graph: KnowledgeGraph
├── selectedBranch: BranchPath
├── nodeLoops: NodeLoop[]
├── finalTest: FinalBranchTest
└── artifactsDir: Path

SourceDocument
├── id: SourceId
├── kind: pasted_text | markdown_file
├── title: string
├── contentPath: Path
└── readableScope: one_tutorial_or_article_or_less

KnowledgeGraph
├── id: GraphId
├── nodes: KnowledgeNode[]
├── edges: GraphEdge[]
├── currentNodeId: NodeId
├── userMarkers: UserMarker[]
└── revisions: GraphRevision[]

KnowledgeNode
├── id: NodeId
├── title: string
├── summary: string
├── kind: core | prerequisite | neighboring
├── status: pending | pass | partial | fail
├── sourceRefs: SourceRef[]
└── notePath: Path

NodeLoop
├── nodeId: NodeId
├── explanation: string
├── question: OpenEndedQuestion
├── answer: LearnerAnswer
├── judgment: pass | partial | fail
├── graphChanges: GraphChange[]
└── noteChanges: NoteChange[]

NodeNote
├── nodeId: NodeId
├── status: pass | partial | fail
├── notions: Notion[]
├── misconceptionOrBlindSpot: string
├── currentGraphPosition: string
├── interviewEvidence: Evidence[]
└── finalLearnerFacingNote: markdown

Notion
├── title: string
├── bullets: string[]
├── artifact: Artifact
└── artifactRationale: string

Artifact
├── kind: code | diagram | example | table | prompt | other
├── content: markdown
├── sourceGrounding: SourceRef[]
└── qualityStatus: pass | needs_user_choice | needs_revision
```

### Value Objects

| Value Object | Fields | Purpose |
|--------------|--------|---------|
| BranchPath | ordered node IDs | The selected graph branch to complete in the first proof. |
| SourceRef | source ID, optional line/section, excerpt | Grounds graph nodes, notes, and artifacts in the input source. |
| UserMarker | marker ID, target type, target ID, coordinates/selector, note | Captures user mouse placement in rendered graph/note HTML. |
| GraphChange | add_node, revise_node, add_edge, remove_edge, rationale | Records live graph mutation caused by learner answers. |
| ScoreResult | total nodes, pass count, partial count, fail count, score | Final branch test result. |

### Domain Events

| Event | Trigger | Data |
|-------|---------|------|
| SourceIngested | User provides pasted text or Markdown file | SourceDocument |
| GraphGenerated | Initial graph is created | KnowledgeGraph |
| BranchSelected | User chooses branch endpoint/path | BranchPath |
| NodeLoopCompleted | Node answer is judged | NodeLoop |
| GraphRevised | Node loop adds/revises nodes or edges | GraphChange |
| NoteUpdated | Node note changes after answer judgment | NoteChange |
| UserMarkerPlaced | User marks graph/note/artifact area | UserMarker |
| FinalTestCompleted | Learner completes final branch test | ScoreResult |

---

## Reference Corpus

The first proof should use external learning systems as design references, not as automated inputs. This means the references shape prompts, gates, rubrics, and evaluation examples, but the system does not yet ingest them as user-facing content.

| Reference | What to borrow | First-proof use |
|-----------|----------------|-----------------|
| Math Academy | Prerequisite-aware graph/tree structure | Graph quality heuristics and branch ordering. |
| boot.dev-style lessons | Project-shaped explainers and concrete implementation practice | Node explanations and programming artifacts. |
| SuperMemo / Anki rules | Atomic recall, card quality, review discipline | Future Anki/card generation criteria; not implemented yet. |
| Zettelkasten / Andy Matuschak-style notes | Durable linked notes, evergreen ideas, writing as thinking | Node note preservation model and link structure. |

If deeper reference ingestion is needed, file a separate research/spike task before implementation. Do not expand the first proof into a general reference-ingestion pipeline.

This reference-ingestion work is separate from the current feature. The current feature should still complete the full first-proof branch lifecycle.

---

## ApexYard Patterns To Borrow

The first proof should borrow ApexYard's operating model, not its software-specific vocabulary. ApexYard turns vague agent work into durable artifacts, explicit gates, and reviewable phase transitions. This system should do the same for learning.

| ApexYard pattern | Learning-system adaptation |
|------------------|----------------------------|
| `/idea` captures lightweight raw intent before spec work | Intake captures raw source, learner intent, and session scope before graph design. |
| `/validate-idea` asks a small set of questions before committing to a spec | Source scope check validates that the learning input is small enough and worth graphing. |
| `/write-spec` turns approved intent into a durable PRD | Graph Design turns source intent into a durable `graph.json`, `graph.md`, and `graph.html`. |
| Design artifacts are committed before build | Graph, branch, node-loop records, notes, and test records are persisted before moving phases. |
| Workflow gates stop progress until prerequisites exist | Learning gates stop progress until graph quality, artifact quality, and final-test readiness are satisfied. |
| Marker files/session state make invisible agent state inspectable | Session metadata, current node, branch path, user markers, and gate results make learning state inspectable. |
| Review role is separate from author role | Final Review should judge graph/notes/test evidence separately from generation steps, even if handled by the same agent in v1. |
| Templates keep artifacts consistent | Node note, notion artifact, graph, final test, and session summary templates should be versioned. |

### What Not To Borrow Yet

- GitHub PR/merge mechanics: first proof is local learning, not collaborative software delivery.
- Full role hierarchy: use specialized prompt steps first; introduce separate agents only when needed.
- Coverage thresholds: learning gates need artifact/test readiness, not code coverage.
- Hosted project registry: use local session folders until multiple learners/projects exist.

---

## Architecture

### Self-Development Lifecycle

The skill's core workflow is a self-development lifecycle, analogous to ApexYard's software development lifecycle but aimed at learning and knowledge preservation.

| Phase | Purpose | Primary Outputs | Gate |
|-------|---------|-----------------|------|
| Intake | Accept source, define scope, create session | `source.md`, session metadata | Source scope check |
| Graph Design | Generate prerequisite tree/graph and render it | `graph.json`, `graph.md`, `graph.html` | Graph Quality Gate |
| Branch Selection | Suggest branches and let user choose one | `branch.json` | Branch validity check |
| Node Loop | Explain, ask, judge, update graph/note/artifact | `node-loops/<node-id>.json`, updated notes/graph | Node judgment and graph revision checks |
| Artifact Preservation | Finalize notion-based Markdown notes and artifacts | `notes/*.md`, `artifacts/**/*.md` | Artifact Quality Gate |
| Final Test | Run open-ended branch test and score pass/partial/fail | `final-test.json` | Final Test Readiness Gate |
| Review | User reviews graph, notes, score, and next missing nodes | session summary, missing-node list | Review complete marker |

### Component Diagram

```text
[User]
  |
  v
[Self-Development Lifecycle Skill / Agent Orchestrator]
  |
  +--> [Intake Step]
  |
  +--> [Graph Builder Step]
  |       |
  |       v
  |    graph.json + graph.md + graph.html
  |
  +--> [Branch Planner Step]
  |
  +--> [Node Loop Step]
  |       |
  |       +--> [Scoring Step]
  |       +--> [Graph Revision Step]
  |       +--> [Note Writer Step]
  |       +--> [Artifact Writer Step]
  |
  +--> [Gate Runner Step]
  |       |
  |       +--> graph quality gate
  |       +--> artifact quality gate
  |       +--> final test readiness gate
  |
  v
[Local Vault / Workspace Files]
```

In v1 these are specialized prompt/workflow steps coordinated by one skill. They may become separate subagents later if context isolation or repeatability requires it.

### Clean Architecture Mapping

Implementation should follow ApexYard's clean architecture handbook: dependencies point inward from infrastructure to application to domain.

```text
domain/
  learning-session
  source-document
  knowledge-graph
  knowledge-node
  branch-path
  node-loop
  node-note
  notion
  artifact
  score-result
  gate-result

application/
  intake-source
  generate-graph
  select-branch
  run-node-loop
  revise-graph
  write-node-note
  write-notion-artifact
  run-gate
  run-final-test
  review-session

infrastructure/
  filesystem-session-store
  llm-structured-output-client
  markdown-renderer
  html-graph-renderer
  obsidian-link-writer
  replay-harness-runner
```

Domain modules must not call the LLM, filesystem, renderer, or Obsidian directly. Application use cases orchestrate ports; infrastructure implements those ports.

Design heuristic: when choosing between implementation structures, ask "would ApexYard do this for a governed agent workflow?" If yes, prefer that pattern unless it conflicts with the learning domain.

### Data Flow

1. Intake: user provides one pasted text input or local Markdown file, and the skill writes a canonical source artifact into the session directory.
2. Graph Design: Graph Builder Agent creates structured `graph.json`, human-readable `graph.md`, and simple rendered `graph.html`.
3. Branch Selection: Branch Planner suggests 2-4 labeled branches and lets the user select or override the branch endpoint.
4. Node Loop: Node Loop Agent walks every node on the selected branch.
5. Node Loop: for each node, the orchestrator renders the current graph position, presents a learner-facing note/explanation, asks an open-ended question, judges the answer, and records evidence.
6. Node Loop: if the answer reveals a blind spot, Graph Revision Agent proposes prerequisite or neighboring node changes; the user accepts, edits, or rejects.
7. Artifact Preservation: Note Writer Agent updates node Markdown; Artifact Writer Agent creates notion artifacts, preferring source-grounded code for programming concepts and diagrams for theoretical concepts.
8. Gate Checks: Gate Runner checks graph quality, artifact quality, and final test readiness at the relevant phase boundaries.
9. Final Test: Final Branch Test asks open-ended questions for completed branch nodes and scores pass/partial/fail.
10. Review: learner reviews graph, notes, score, and missing-node list before the session is considered complete.

### Structured Output Mechanism

All LLM-producing steps must write through typed structured-output contracts. The application layer owns the target schemas; the infrastructure LLM client is responsible for model invocation, parsing, validation, and retry.

| Producer | Output Contract | Validation |
|----------|-----------------|------------|
| Graph Builder Step | `KnowledgeGraph` | Node IDs unique, edges reference existing nodes, source refs present, at least one branch candidate. |
| Branch Planner Step | `BranchCandidate[]` and `BranchPath` | Branch node IDs exist and path is connected. |
| Node Loop Step | `NodeLoop` | Question, learner answer, judgment, evidence, and status present. |
| Graph Revision Step | `GraphChange[]` | Changes are typed and include rationale; new nodes include source/evidence or user justification. |
| Note Writer Step | `NodeNote` | Required node note template fields present. |
| Artifact Writer Step | `Artifact` | Artifact kind, content, rationale, and source grounding or user choice present. |
| Scoring Step | `ScoreResult` | pass/partial/fail counts match judged answers; score calculation reproducible. |

Invalid structured output should not be silently repaired in prose. The client should retry with validation errors, then fail the current phase with a gate-readable error if validation still fails.

---

## API Design

This first proof is an agent skill/workflow backed by local files. No HTTP API and no standalone app shell are required.

### Skill Steps

| Step | Purpose |
|------|---------|
| Intake | Accept pasted text or a local Markdown file and create the session folder. |
| Graph Design | Generate `graph.json`, `graph.md`, and `graph.html`. |
| Branch Selection | Suggest 2-4 branches and let the learner choose or override the endpoint. |
| Node Loop | Explain, ask, judge, update graph, update notes, and preserve evidence for one node. |
| Artifact Preservation | Create notion artifacts, preferring source-grounded code or diagrams. |
| Gate Checks | Run graph quality, artifact quality, and final test readiness gates. |
| Final Test | Ask open-ended questions across the completed branch and score pass/partial/fail. |
| Review | Present graph, notes, score, missing nodes, and next recommended learning actions. |

### File Interfaces

```text
sessions/<session-id>/
├── source.md
├── graph.json
├── graph.md
├── graph.html
├── branch.json
├── node-loops/
│   └── <node-id>.json
├── notes/
│   └── <node-slug>.md
├── artifacts/
│   └── <node-slug>/<artifact-slug>.md
├── gates/
│   ├── graph-quality.json
│   ├── artifact-quality.json
│   └── final-test-readiness.json
└── final-test.json
```

### Error Responses

| Code | When | Recovery |
|------|------|----------|
| SOURCE_TOO_LARGE | Source is more than one tutorial/article or not readable in 5-15 minutes | Ask user to narrow source. |
| GRAPH_LOW_CONFIDENCE | Graph has weak grounding or unclear prerequisites | Ask user to revise source scope or regenerate. |
| BRANCH_NOT_SELECTABLE | Selected node cannot form a valid branch | Show candidate branches again. |
| ARTIFACT_AMBIGUOUS | System cannot infer the right artifact | Offer artifact choices to the user. |
| FINAL_TEST_NOT_READY | Branch nodes lack notes/questions/artifacts | Run readiness gate and list missing artifacts. |

---

## Data Model

### Persistent Files

| File | Type | Purpose |
|------|------|---------|
| `source.md` | Markdown | Canonical bounded source. |
| `graph.json` | JSON | Canonical machine-readable source of truth for graph, edges, statuses, markers, revisions, and deterministic replay. |
| `graph.md` | Markdown | Obsidian-readable graph/navigation artifact for normal vault browsing. |
| `graph.html` | HTML | Generated rendered graph/note view with current-position and user markers. |
| `branch.json` | JSON | Selected branch path and candidate branch labels. |
| `node-loops/<node-id>.json` | JSON | Explanation, question, answer, judgment, graph changes, note changes. |
| `notes/<node-slug>.md` | Markdown | Preserved node note with notions and artifacts. |
| `artifacts/<node-slug>/*.md` | Markdown | First-class code/diagram/example artifacts. |
| `final-test.json` | JSON | Final branch test questions, answers, judgments, score. |

### Access Patterns

| Access Pattern | Query |
|----------------|-------|
| Resume session | Load `sessions/<session-id>/graph.json` and `branch.json`. |
| Render current position | Read graph current node and selected branch path. |
| Review node history | Load `node-loops/<node-id>.json` and `notes/<node-slug>.md`. |
| Diff graph changes | Compare graph revisions in `graph.json`. |
| Validate test readiness | Ensure every branch node has note, question, artifact, and judgment. |

### Diagram Artifact Format

When a theoretical notion needs a diagram and the source does not provide a stronger artifact, the default diagram artifact should be Mermaid embedded in Markdown. This keeps diagrams local, diffable, Obsidian/GitHub-friendly, and consistent with ApexYard's existing documentation style. Custom HTML/SVG diagrams can be added later only when Mermaid cannot express the needed idea.

### Deterministic Replay Harness

The replay harness makes agent work inspectable and less random. Every important LLM boundary and user interaction should be recorded as an event so future review can answer: what did the agent see, what did it output, why did it change the graph, and why did it judge an answer as pass, partial, or fail?

This is not a user-facing feature in v1. It is the engineering safety mechanism that makes the ApexYard-style learning workflow auditable.

```text
sessions/<session-id>/
├── events.jsonl
├── prompts/
│   └── <event-id>.md
├── llm-outputs/
│   └── <event-id>.json
├── user-inputs/
│   └── <event-id>.md
└── replay-report.json
```

Each event records:

- event ID
- lifecycle phase
- input artifact paths
- prompt path when applicable
- structured output path when applicable
- user input path when applicable
- validation result
- resulting artifact paths

Replay mode should read recorded structured outputs and user inputs, re-run schema validation and gates, regenerate derived artifacts, and compare them to stored outputs. This proves schema/gate determinism even when LLM text generation is nondeterministic.

---

## Mechanical Gates

| Gate | When | Checks | Output |
|------|------|--------|--------|
| Graph Quality Gate | After initial graph generation and after graph revisions | Nodes have titles, source grounding, prerequisite edges, no orphan selected-branch nodes, and branch candidates exist | `gates/graph-quality.json` |
| Artifact Quality Gate | Before final branch notes are accepted | Each notion has an artifact, artifact rationale, and source grounding or explicit user choice | `gates/artifact-quality.json` |
| Final Test Readiness Gate | Before final test starts | Every completed branch node has a note, open-ended question, answer judgment, artifact, and pass/partial/fail status | `gates/final-test-readiness.json` |

Gate failures should stop the workflow and show the smallest corrective action: narrow source, edit graph, choose artifact, complete missing node loop, or regenerate final question.

---

## Implementation Plan

### Feature Scope

Build the first self-development lifecycle skill for one Redux Toolkit Markdown source and one selected graph branch.

The feature is complete only when it can:

- intake a local Markdown source
- generate graph files
- render the graph
- let the learner select one branch
- run the full node loop for every node in that branch
- update the graph live
- write notion-based Markdown notes
- generate first-class artifacts, especially code artifacts for programming concepts
- run the final open-ended branch test
- produce a session summary
- persist gate results and session artifacts

### Tasks

| # | Task | Estimate | Dependencies |
|---|------|----------|--------------|
| 1 | Define session file schema and sample fixtures | 3h | - |
| 2 | Define domain/application/infrastructure module boundaries and ports | 4h | 1 |
| 3 | Implement source intake step for pasted text and local Markdown file | 2h | 1, 2 |
| 4 | Implement structured-output schemas and validation/retry wrapper | 6h | 1, 2 |
| 5 | Implement graph design prompt/schema producing `graph.json` and `graph.md` | 5h | 3, 4 |
| 6 | Implement simple Obsidian-readable `graph.html` renderer with current-position and user markers | 5h | 5 |
| 7 | Implement branch candidate selection and manual endpoint override | 3h | 5 |
| 8 | Implement node loop state machine | 6h | 5, 7 |
| 9 | Implement scoring rubric for pass/partial/fail | 3h | 8 |
| 10 | Implement graph revision proposals and user accept/edit/reject flow | 5h | 8 |
| 11 | Implement notion-based Markdown note writer | 5h | 8 |
| 12 | Implement artifact writer with code/diagram/user-choice paths | 5h | 11 |
| 13 | Implement graph, artifact, and final-test readiness gates | 4h | 8, 11, 12 |
| 14 | Implement deterministic replay harness over recorded events and structured outputs | 6h | 4, 13 |
| 15 | Implement final branch test and score report | 4h | 9, 13 |
| 16 | Run first validation on combined Redux Toolkit e-commerce Markdown source | 4h | all |

**Total Estimate**: 70h

---

## Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Graph generation invents weak prerequisites | High | High | Require source grounding per node and Graph Quality Gate before branch selection. |
| Node loop becomes too long | Med | High | Limit first proof to one selected branch and persist resumeable session state. |
| Artifact quality is poor or generic | High | High | Artifact Quality Gate; prefer source code for programming concepts; ask user when ambiguous. |
| LLM scoring is inconsistent | Med | High | Use explicit rubric, store scoring evidence, and allow user correction. |
| HTML marker interaction adds UI complexity | Med | Med | Keep first renderer simple: Obsidian-readable static HTML plus target IDs/coordinates captured into `graph.json`. |
| Session file schema churns during first proof | High | Med | Use versioned JSON schemas and sample fixtures before implementation. |

---

## Security Considerations

- [ ] Do not send unrelated vault files to the LLM; only the selected source and session artifacts are in scope.
- [ ] Keep local paths out of generated artifacts unless user explicitly permits them.
- [ ] Avoid storing secrets from pasted code snippets in logs.
- [ ] Make session artifacts local-first by default.
- [ ] If a hosted version is built later, add auth, authorization, privacy, and retention design before launch.

---

## Testing Strategy

| Type | Coverage | Notes |
|------|----------|-------|
| Schema tests | Session files, graph, branch, node loop, notes, final test | Validate required fields and status transitions. |
| Golden fixture tests | Redux Toolkit sample source | Assert graph nodes, branch selection, note template, and artifact shape. |
| Gate tests | Graph quality, artifact quality, final test readiness | Gate failures should identify corrective action. |
| Scoring tests | pass/partial/fail examples | Use fixed answer fixtures for deterministic scoring checks. |
| Manual validation | First learner session | Use combined Redux Toolkit e-commerce Markdown source. |

---

## Open Questions

| Question | Owner | Status |
|----------|-------|--------|
| Should graph rendering use Mermaid, custom HTML, or both? | Tech Lead + User | Resolved: `graph.json` is canonical machine state, `graph.md` is Obsidian-readable navigation, and `graph.html` is the rendered interactive view with current node marker and user marker placement. |
| What LLM/provider and structured-output mechanism should run the agents? | Tech Lead + User | Resolved: strict structured outputs for machine state (`graph.json`, `node-loop.json`, `final-test.json`) and Markdown for human artifacts (`graph.md`, notes, artifacts). Application-owned schemas validate LLM outputs; invalid output retries then fails the phase with a gate-readable error. |
| Should the first implementation be a CLI, a local web page, or an Obsidian-adjacent script? | Tech Lead | Resolved: agent skill/workflow first; Obsidian-readable Markdown/HTML as the viewing surface; polished app deferred. |
| Which deterministic harness should replay a session for testing? | Tech Lead + User | Resolved: record `events.jsonl`, prompts, user inputs, LLM structured outputs, validation results, and generated artifacts so sessions can be inspected and replayed without model calls. This is the engineering safety mechanism for deterministic-ish AI work. |
| Should artifact writer output diagrams as Mermaid by default? | Tech Lead + User | Resolved: default to Mermaid embedded in Markdown because it matches ApexYard's markdown-first diagram pattern; use custom HTML/SVG only when Mermaid cannot express the artifact. |
| Which AgDR records the Phase 1 architecture decisions? | Tech Lead | Resolved: [AgDR-0069](../../../docs/agdr/AgDR-0069-self-development-lifecycle-phase1-architecture.md). |
| Should implementation follow clean architecture layering? | Tech Lead + User | Resolved: yes. Use domain/application/infrastructure boundaries, following ApexYard-style governed workflow patterns where applicable. |

---

## Approvals

| Role | Name | Date | Status |
|------|------|------|--------|
| Tech Lead | Hisham | 2026-06-15 | Author |
| Head of Engineering | | | Pending |
| Security (if needed) | | | Pending |
