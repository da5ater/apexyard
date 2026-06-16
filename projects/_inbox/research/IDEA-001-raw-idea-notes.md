# IDEA-001 — Raw Idea Notes

**Date captured**: 2026-06-15
**Source**: Initial scrambled idea dump before validation/PRD refinement.
**Status**: Reference material. Not all items are in first-proof scope.

## Core Theme

Build a self-development / self-management learning system centered on knowledge graphs, diagnostic interviews, first-class learning artifacts, and measurable progress.

The heart of the idea is a learner-facing LLM wiki that can turn sources into prerequisite-aware knowledge graphs, interview the learner about each node, update the graph and artifacts based on the learner's answers, and preserve the resulting understanding in an Obsidian-style vault.

## Learning System Ideas

- Track study time for users.
- Make the system game-like.
- Let students unlock levels and see visual achievements.
- Let a student prove they finished a book or learning resource.
- Use AI to judge evidence of completion before adding an achievement.
- Every achievement or learning task should have a measurable test.
- A lecture-completion task should include a quiz; passing adds XP or level progress.

## LLM Wiki / Knowledge Graph

- AI creates a knowledge graph from each entry.
- Student gets an intense interview about each node.
- The conversation is diagnostic.
- Conversation side effects can include:
  - new node added
  - zettel entries needing review
  - other generated system artifacts
- Student sees a visual representation of the conversation and artifacts.
- Student can intervene, change artifacts, or add missing nodes.
- Knowledge graph should record missing nodes for future study.
- The system should recommend books or resources that fill missing graph areas.
- Before turning a source into zettels, the user should be interviewed.
- After interview, the system checks whether the idea/zettel already exists in the vault.
- If it exists, user is redirected to the existing zettel.
- If not, a new zettel is created.
- Capture user misconceptions as part of the artifact.

## First-Class Artifacts

- Artifacts are first-class citizens, not examples or templates.
- They need their own module.
- Important artifact types include:
  - knowledge graph
  - node notes
  - zettels needing review
  - Anki cards
  - Anki-question analysis
  - artifacts that show whether something is puzzling the student but has no question attached
- Artifact quality needs attention.
- User flexibility to change artifacts helps internalize material.
- Artifacts should become the source of truth so the learner does not feel trapped by the AI.

## Anki / Spaced Repetition

- Every entry should have a set of Anki cards.
- Programmatically connect to Anki.
- Each Anki card should be connected directly to a node in the vault/zettelkasten.
- Query Anki questions to find concepts puzzling the learner but not represented as questions.
- Use SuperMemo / Anki-style card quality rules later.

## Agent Proxy / Project Learning Loop

- The learner can use the system as a proxy between them and a coding agent.
- Example: learner studied Node.js and wants to build a project.
- Instead of speaking directly to the coding agent, the learner speaks to "Shafeay" / the learning agent.
- The system creates the knowledge graph needed for the task.
- It explores the task node by node.
- It explains how each node translates into the project being built.
- It adds this learning back into the vault.
- This creates a self-fulfilling loop: project work produces knowledge artifacts, and knowledge artifacts improve project work.

## Knowledge Problem / AI Determinism

- The main problem is a knowledge problem, not only a skill problem.
- Need to know what a harness is.
- Need to systematize AI use.
- Need mechanical workflows and deterministic-ish gates for AI work.
- The system should make working with AI less ad hoc.

## Inspirations / References

- Math Academy:
  - prerequisite-aware knowledge graphs
  - node progression
- boot.dev:
  - project-shaped learning
  - learning by writing many commands naturally
- Obsidian:
  - nodes and links
  - vault as Markdown surface
  - improve link preview and graph use for creative writing
- Zettelkasten:
  - Ahmed Salem / zettelkasten practices
  - Andy Matuschak-style evergreen notes
- SuperMemo / Anki:
  - spaced repetition and card quality

## Obsidian Replacement / Vault Surface

- The new Obsidian-like system should be built around the knowledge graph.
- Anything that improves the graph should be central.
- There is no canvas as the core model.
- Obsidian can initially serve as the Markdown/HTML viewer.
- Later, a real app can organize artifacts beautifully so the user does not dig through Markdown trenches.

## Media / Content Ingestion

- System should eventually accept video.
- Video can be turned into audio, then transcript.
- Books can be shared between users.
- Users can share learning resources.
- These are later product surfaces, not first proof.

## Course / Project Mode

- For courses such as OSSU programming languages, start by deciding on a big project or goal.
- Go through each lesson and build the project step by step, like boot.dev.
- Course material and project goals should be tied into the knowledge graph.
- Learning should translate into concrete project work.

## First-Proof Refinement From Review

The refined first proof is narrower:

- one small bounded source, such as one tutorial/article or less
- pasted text or local Markdown file
- source for first validation: combined Redux Toolkit e-commerce course lectures
- generate prerequisite-aware tree/graph
- choose one branch
- run a node loop for every node in that branch
- explain, ask, judge, update graph, update notes
- preserve node notes as notions with first-class artifacts
- render graph/notes through Markdown/HTML
- run final open-ended branch test
- defer app shell, Anki sync, gamification, sharing, achievements, media ingestion, and course-platform ingestion
