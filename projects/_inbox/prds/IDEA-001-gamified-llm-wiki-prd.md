<!-- Source: IDEA-001 · Created via /write-spec -->

# PRD: Gamified LLM Wiki for self-directed learning

**Status**: Approved
**Author**: Mariam (Product Manager)
**Created**: 2026-06-15
**Last Updated**: 2026-06-15
**Raw Notes**: [projects/_inbox/research/IDEA-001-raw-idea-notes.md](../research/IDEA-001-raw-idea-notes.md)
**Initiative**: [projects/initiatives/self-development-lifecycle.md](../../initiatives/self-development-lifecycle.md)

---

## Overview

### Problem Statement

Self-taught programming students currently stitch together tutorials, articles, Obsidian notes, Anki cards, ChatGPT conversations, and ad hoc project work. This creates a heavy self-management burden: they must infer prerequisites, decide what concepts matter, diagnose their own blind spots, and manually turn understanding into durable notes.

Math Academy demonstrates the power of prerequisite-aware learning graphs, but that model is not available for general programming knowledge, project tutorials, or personal knowledge work. The first version should prove that an LLM can take a small bounded learning source, turn it into a prerequisite-aware tree/graph, guide the learner through one complete branch, test each node with open-ended questions, adapt the graph and notes around misconceptions, and produce Markdown notes that reflect the learner's actual understanding.

The first version must be built in an ApexYard-style operating model: markdown-first, agent-first, lifecycle-driven, gate-based, and artifact-centered. It should prove that the learning workflow works for the user's own usage before any polished GUI or standalone app is built.

### Target User

**Primary**: Self-taught programming students who use Obsidian or Markdown notes while building portfolio projects from tutorials, courses, or technical articles.

**Secondary**: Solo builders, solo content creators, solopreneurs, and knowledge workers who handle text-heavy material and want an AI companion that converts sources into a structured, reviewable knowledge graph.

### Goals

1. Generate a prerequisite-aware tree/graph from one small bounded learning source in under 30 minutes; the source should be one tutorial, one article, or less, readable in roughly 5-15 minutes.
2. Let the learner choose one branch of the generated tree/graph and complete a node loop for every node on that branch: explanation note, open-ended test question, answer judging, and graph/note revision.
3. Detect blind spots during each node loop and add or revise prerequisite or neighboring nodes as needed before the branch is complete.
4. Produce living Markdown notes for the completed branch, updated from the learner's answers and the system's judgment.
5. Run a final open-ended test across the completed branch and pass the session when the learner scores at least 80%.
6. Preserve each completed node as a set of notions, where every notion has bullet-point explanation plus a first-class artifact that actualizes the idea.

### Non-Goals (Out of Scope)

- Native Anki integration, card sync, or AnkiConnect automation.
- Automated ingestion of external reference systems, books, courses, or creators as product features.
- Gamification, XP, levels, achievements, sharing, or public proof of learning.
- Video/audio ingestion, transcription, book sharing, or media pipeline work.
- Transcript parsing and course-platform ingestion.
- A custom Obsidian replacement, full web app, or proprietary note editor.
- A polished GUI/application surface. Build this only after the ApexYard-style agent workflow proves viable and valuable for real use.
- Multi-user collaboration, marketplaces, or social features.
- Long-term spaced repetition scheduling.

### Success Metrics

| Metric | Target | How Measured |
|--------|--------|--------------|
| Branch node comprehension | Learner scores at least 80% on final open-ended test questions for completed branch nodes | System judges answers against each node's main pain points and prerequisites |
| Note fidelity | Learner confirms final Markdown notes match their understanding | End-of-session review prompt per note |
| Dynamic prerequisite capture | Graph adds or revises missing prerequisite or neighboring nodes when blind spots appear on the selected branch | Compare initial graph to final graph and node-loop records |
| Workflow preference | Learner prefers this flow over manual Obsidian plus ChatGPT after one tutorial | Post-session forced-choice survey |
| Time to usable artifact | One small bounded source becomes usable graph plus branch Markdown notes in under 30 minutes | Session timer from source submission to final notes |

### Reference Inputs

The first proof should be informed by admired learning systems and knowledge-work practices, but should not try to automate ingestion of those references yet. Reference inputs include:

- Math Academy for prerequisite-aware knowledge graph structure.
- boot.dev-style explainers and project-shaped learning.
- SuperMemo and Anki rules for future spaced-repetition/card generation.
- Zettelkasten and knowledge-work practices from Andy Matuschak and related writers.

These references should shape evaluation criteria, prompts, artifacts, and later roadmap decisions. They are not first-proof product surfaces.

### Product Phasing

| Phase | Scope | Success Condition |
|-------|-------|-------------------|
| Phase 1 — ApexYard-style workflow | Agent skill, Markdown/HTML artifacts, local files, lifecycle phases, gates, and Obsidian as the viewing surface | The workflow is valuable for the user's own Redux Toolkit learning source and produces useful graph, notes, artifacts, and test evidence. |
| Phase 2 — GUI/app surface | Dedicated application UI that organizes graph, notes, markers, artifacts, progress, and later integrations | Start only after Phase 1 proves repeated personal value and the artifact model stabilizes. |

---

## User Stories

### US-1: Generate prerequisite graph
>
> As a self-taught programming student, I want to give the system one small bounded source and receive a prerequisite-aware knowledge tree/graph, so that I can see what concepts I need to understand before building from the material.

**Acceptance Criteria**:

- [ ] User can provide one small bounded text source: one tutorial, one article, or less, readable in roughly 5-15 minutes.
- [ ] System generates a tree/graph of concept nodes with prerequisite relationships.
- [ ] Each node includes a short label, plain-language description, and why it matters for the source.
- [ ] Graph distinguishes core nodes from supporting prerequisite nodes.
- [ ] User can review the graph before starting the interview and choose one branch to complete.

---

### US-2: Complete a node learning loop through one branch
>
> As a learner, I want the system to guide me through every node on one selected branch, so that each explanation, question, answer, and correction improves the graph and the final notes.

**Acceptance Criteria**:

- [ ] System walks through every node on the selected branch in prerequisite-aware order.
- [ ] For each branch node, system presents a learner-facing note/explanation before testing.
- [ ] For each branch node, system asks at least one open-ended question designed to expose the node's main pain points.
- [ ] System judges the learner's answer as pass, partial, or fail using the required scoring rubric.
- [ ] System records learner confidence, correct understanding, misconceptions, and missing prerequisites.
- [ ] System can mark each branch node as pass, partial, or fail.
- [ ] User can correct the system's interpretation during the interview.

---

### US-3: Adapt the graph around blind spots
>
> As a learner, I want the graph to expand when my blind spots appear during a branch interview, so that missing prerequisites become visible instead of staying hidden.

**Acceptance Criteria**:

- [ ] System identifies missing prerequisites or neighboring nodes when the learner cannot answer a branch-node question well.
- [ ] System can add a new prerequisite node during the session.
- [ ] System can revise an existing node description when the learner's misconception reveals ambiguity.
- [ ] System updates the knowledge graph live when prerequisite or neighboring nodes are added or revised.
- [ ] System preserves a visible before/after record of graph changes using Markdown or HTML graph artifacts.
- [ ] System renders the live knowledge graph to the learner so they can see where they currently are in the branch.
- [ ] The rendered graph includes a current-position marker for the active node.
- [ ] User can place or move a marker in the rendered HTML/Markdown view to indicate the note, notion, or graph area they want to focus on.
- [ ] User can accept, reject, or edit a proposed graph change.

---

### US-4: Write Markdown notes into the vault
>
> As a learner using Obsidian or Markdown files, I want the final graph and branch node notes written as Markdown, so that the learning artifact becomes part of my existing vault.

**Acceptance Criteria**:

- [ ] System writes one Markdown file per completed branch node or a clearly structured Markdown bundle.
- [ ] Each note includes concept explanation, prerequisites, learner-specific misconceptions, and links to related nodes.
- [ ] Notes are updated live from the learner's answers, system judgments, corrections, and graph changes.
- [ ] Notes use normal Markdown links compatible with Obsidian.
- [ ] The graph visualization is represented through Markdown links, a Markdown-renderable graph artifact, or a simple HTML view generated from the Markdown files.
- [ ] Each completed branch node note follows the required node note template.
- [ ] Each completed branch node note is organized as notions, with each notion containing bullet-point explanation and an artifact.
- [ ] Artifacts are treated as first-class preservation objects, not decorative examples.
- [ ] Notes are understandable without rereading the full interview transcript.
- [ ] User can review and edit final notes after generation.

---

### US-5: Compare with manual workflow
>
> As a product tester, I want to compare this workflow to manual Obsidian plus ChatGPT, so that we know whether the graph/interview loop is actually better.

**Acceptance Criteria**:

- [ ] After one session, user answers whether they prefer this flow or their manual workflow.
- [ ] User identifies which artifact was most valuable: graph, interview, graph updates, or final notes.
- [ ] User identifies any artifact that felt wrong, noisy, or untrustworthy.
- [ ] Session records time from source submission to usable final notes.

---

### US-6: Run final branch test
>
> As a learner, I want a final open-ended test after the branch notes are created, so that I can verify whether I actually understand the branch.

**Acceptance Criteria**:

- [ ] After branch notes are created, system asks whether the learner is ready for the final test.
- [ ] Final test includes open-ended questions for each completed branch node.
- [ ] Questions are designed around each node's main pain points, prerequisites, and prior misconceptions.
- [ ] System scores the learner's collected answers and reports pass, partial, or fail.
- [ ] Session passes when the score is at least 80%.

---

### Edge Cases

| Scenario | Expected Behavior |
|----------|-------------------|
| Source is too long or unfocused | Ask user to narrow the source before graph generation. |
| Source contains many unrelated topics | Generate a proposed scope summary and ask user to narrow the source or choose one path. |
| Generated graph is obviously wrong | Let user edit, remove, or regenerate nodes before interview. |
| Learner cannot answer a node question | Add or propose prerequisite nodes instead of pushing forward blindly. |
| Learner disagrees with generated notes | Capture correction and revise the note before marking it complete. |
| Interview becomes too long | Complete the current branch only and defer other branches into a later review list. |

---

## Requirements

### Functional Requirements

| ID | Requirement | Priority | Notes |
|----|-------------|----------|-------|
| FR-1 | Accept one small bounded text source as input. | Must | First version can use pasted text or a local Markdown file. Source should be one tutorial, one article, or less, readable in roughly 5-15 minutes. |
| FR-2 | Generate prerequisite-aware concept tree/graph from the source. | Must | Graph must include nodes and dependency edges. |
| FR-3 | Present graph for user review before interview starts. | Must | User must be able to reject obvious errors. |
| FR-4 | Let the user select one branch and run a node learning loop for every node on that branch. | Must | Loop includes explanation note, open-ended question, answer judgment, and updates. |
| FR-5 | Detect misconceptions and missing prerequisites from learner answers. | Must | This is the core differentiator. |
| FR-6 | Add or revise graph nodes during the branch interview. | Must | User can accept, reject, or edit changes. |
| FR-7 | Generate final Markdown notes from the completed branch and interview. | Must | Notes should be vault-ready, linkable, and follow the required node note template. |
| FR-8 | Run a final open-ended test across completed branch nodes. | Must | Pass threshold is at least 80%. |
| FR-9 | Generate or select a first-class artifact for each notion in a completed node note. | Must | Programming artifacts should prefer code from the source; theoretical artifacts should prefer diagrams when no better artifact is present. |
| FR-10 | Record final graph, notes, node-loop records, answer judgments, misconceptions, and notion artifacts as first-class artifacts. | Should | Artifact quality matters as much as chat quality. |
| FR-11 | Produce a session summary with comprehension and artifact-quality checks. | Should | Supports validation metrics. |
| FR-12 | Generate Anki card candidates from nodes. | Could | Deferred until graph/note loop proves value. |

**Priority Key**: Must (required for launch) | Should (important) | Could (nice to have)

### Non-Functional Requirements

| Category | Requirement | Target |
|----------|-------------|--------|
| Performance | Small bounded source to usable graph plus completed-branch notes | Under 30 minutes end to end |
| Reliability | Artifact traceability | Every final note references the node and interview evidence that shaped it |
| Privacy | Local-first learning data | First version stores artifacts in the user's local vault or workspace |
| Usability | User agency over artifacts | User can correct graph and notes before accepting them |
| Portability | Markdown output | Notes remain usable in Obsidian or any Markdown viewer |

### Required Node Note Template

Each completed branch node note must include:

- `title`
- `status`: pass, partial, or fail
- `source`
- `prerequisites`
- `related nodes`
- `notions`
- `learner misconception or blind spot`
- `current graph position`
- `interview evidence`
- `final learner-facing note`

Each `notion` must include:

- notion title
- bullet-point explanation
- artifact
- artifact rationale

Artifacts should actualize the notion so the learner can return to the note later without replaying the full interview. For programming material, the preferred artifact is code, ideally taken from or closely grounded in the source material. For theoretical material, the preferred artifact is a diagram when the source does not provide a better concrete representation. If the system cannot infer the right artifact, it should offer artifact choices to the user.

### Understanding vs Preservation

The live node loop is responsible for understanding: explaining the node, asking open-ended questions, judging answers, giving direct feedback, and updating the graph or note when the learner's understanding changes.

The Markdown note is responsible for preservation: retaining the final structure of the node as notions, bullet explanations, artifacts, misconceptions, evidence, and graph position. The preserved note should support later review, future Anki generation, and quick return to the concrete artifact the learner needs, such as Redux Toolkit API slice boilerplate code.

### Required Scoring Rubric

Open-ended node answers and final test answers must use this rubric:

- `pass`: the learner answers the note correctly and demonstrates the core understanding.
- `partial`: the learner has the basic premise, but their understanding is foggy, cluttered, incomplete, or poorly connected to prerequisites.
- `fail`: the learner answers completely wrong or understands the node in a substantially different way.

---

## Design

### User Flow

```text
[Start]
    |
    v
[User provides one small bounded source]
    |
    v
[System summarizes scope and generates prerequisite tree/graph]
    |
    v
[User reviews graph]
    |
    +---> [Graph rejected or too broad] --> [Revise source/scope] --> [Regenerate graph]
    |
    v
[User chooses one branch]
    |
    v
[System interviews learner through every node on selected branch]
    |
    +---> [For each node: show note/explanation -> ask open-ended question -> judge answer]
    |
    +---> [Blind spot detected] --> [Propose prerequisite/neighbor node or note change] --> [User accepts/edits/rejects]
    |
    v
[System writes final Markdown notes for completed branch]
    |
    v
[System asks if learner is ready for final branch test]
    |
    v
[Learner answers open-ended test questions for each completed branch node]
    |
    v
[System scores final test: pass / partial / fail]
    |
    v
[User reviews notes and answers success checks]
    |
    v
[End: final graph, completed branch notes, session summary]
```

### Wireframes / Mockups

No polished visual design is required for the first PRD. The first usable shape can be CLI, chat, or a simple local workflow as long as it produces reviewable graph artifacts and Markdown notes. The only required visual layer is a Markdown-linked graph, a Markdown-renderable graph artifact, or a simple HTML view generated from the Markdown files. A later design phase should decide whether the graph, interview state, and artifact changes need a richer interface.

The first HTML/Markdown-rendered view should support direct user interaction through markers. The system owns the current-position marker for the active node, and the user can place a marker with the mouse on a rendered note, notion, artifact, or graph area to show what they want to discuss, correct, or focus on.

---

## Technical Notes

### Dependencies

| Dependency | Type | Status | Owner |
|------------|------|--------|-------|
| Obsidian-compatible Markdown vault | External/local surface | Assumed available | User |
| LLM with structured output support | External model dependency | Open | Tech Lead |
| Graph artifact format | Internal | Open | Tech Lead |
| Local file write access | Internal/local | Open | Tech Lead |
| QMD-style search/connection tooling | Internal or local tool | Future candidate | Tech Lead |

### Technical Constraints

- First version should use direct Markdown files instead of building an Obsidian plugin or custom editor.
- Graph output must be structured enough to diff initial vs final graph.
- Interview state, graph changes, misconceptions, and final notes must be persisted as artifacts, not lost in chat.
- Source input should be deliberately small and bounded to keep generation, branch node loops, and final testing measurable: one tutorial, one article, or less, readable in roughly 5-15 minutes.
- Every node loop should persist its explanation, open-ended question, learner answer, judgment, graph changes, and note changes.
- The live graph should render the learner's current position in the selected branch and update when nodes are added or revised.
- User-placed markers in the rendered HTML/Markdown view should be captured as interaction context for the live node loop.
- Artifact generation should be content-sensitive: code for programming concepts, diagrams for theoretical concepts when no source artifact exists, and user choice when the best artifact is ambiguous.
- The system should avoid pretending the graph is correct; user correction is part of the product loop.

---

## Launch Plan

### Rollout Strategy

- [ ] All users at once
- [ ] Phased rollout
- [x] Beta program first

Run with a small set of self-taught programming learners using one small tutorial/article-sized source each. Treat every session as a qualitative product test before adding broader content types, full-graph interviews, or automation.

---

## Open Questions

| Question | Owner | Status | Resolution |
|----------|-------|--------|------------|
| What exact file format represents the graph: Markdown links, JSON, Mermaid, QMD-backed notes, or a hybrid? | Tech Lead | Open | |
| What agent/orchestrator structure should run the graph, node loop, artifact generation, scoring, and mechanical gates? | Tech Lead | Open | |
| What is the first source type: pasted tutorial text, Markdown article, transcript, or course lesson? | Product Manager | Resolved | First proof accepts pasted text or a local Markdown file only. Transcript parsing and course-platform ingestion are out of scope. |
| What practical size limit defines a small bounded source for the first proof? | Product Manager | Resolved | One tutorial, one article, or less, readable in roughly 5-15 minutes. |
| How should the user choose the first branch to interview? | UX Designer | Resolved | System renders the graph, suggests 2-4 labeled candidate branches, user chooses manually, and user can override by selecting any node as the branch endpoint. |
| How should user corrections be represented in the final artifacts? | Product Manager | Resolved | Corrections are captured in the node note template through status, misconception/blind spot, interview evidence, and final learner-facing note fields. |
| How should the final test score distinguish pass, partial, and fail beyond the 80% pass threshold? | Product Manager | Resolved | Pass means correct core understanding; partial means basic premise with foggy/cluttered understanding; fail means completely wrong or substantially different understanding. |
| Should the first validation run happen on a programming tutorial, a boot.dev-style lesson, or OSSU programming languages material? | Product Manager | Resolved | First validation source is one local Markdown file created by combining the user's six small Redux Toolkit e-commerce course lectures. |
| Which pieces of the original idea stay explicitly deferred: Anki sync, gamification, sharing, achievements, video/audio ingestion, and custom app UI? | Head of Product | Resolved | Defer Anki sync, gamification, sharing, achievements, video/audio ingestion, transcript parsing, course-platform ingestion, and custom app UI until the graph/node-loop/Markdown-artifact proof works. |
| Which ApexYard-style mechanical gates should the learning workflow adopt for graph quality, artifact quality, and final test readiness? | Tech Lead | Open | |

---

## Timeline

| Milestone | Target Date | Status |
|-----------|-------------|--------|
| PRD Approved | 2026-06-15 | Complete |
| Design Complete | TBD | Not started |
| Dev Complete | TBD | Not started |
| QA Complete | TBD | Not started |
| Launch | TBD | Not started |

---

## Approvals

| Role | Name | Date | Status |
|------|------|------|--------|
| Product Manager | Mariam | 2026-06-15 | Author |
| Head of Product | MohamedKH | 2026-06-15 | Approved |
| Tech Lead | | | Pending |
| Head of Design | | | Pending |
