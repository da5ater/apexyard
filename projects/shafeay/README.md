# Shafeay

Shafeay is the separate product project for the self-development lifecycle idea. ApexYard governs this project, but the implementation belongs in `workspace/shafeay`, not in the ApexYard framework skill library.

## Boundary

- ApexYard is the SDLC harness: tickets, PRD, technical design, gates, reviews, and portfolio governance.
- Shafeay is the product: the learning graph runner, local artifacts, learner interview loop, notes, artifacts, tests, and future GUI.
- Do not add Shafeay implementation under ApexYard framework paths such as `.claude/skills/self-development-lifecycle`.

## Product Core

The core product problem is the knowledge graph:

- ingest one bounded learning source
- create a concept/prerequisite graph
- select one branch through the graph
- interview the learner node by node
- detect misconceptions and missing prerequisites
- update the graph dynamically
- write notes and artifacts that match the learner's actual understanding
- later produce open-ended tests with pass, partial, and fail scoring

## First Build Target

The first useful slice should run locally:

1. Ingest one Markdown source.
2. Produce `graph.json`, `graph.md`, and `graph.html`.
3. Select one branch.
4. Run a persisted node interview loop for every node in that branch.
5. Add missing prerequisite nodes when blind spots appear.
6. Write per-node interview records and note drafts.

The slice can be small by source size and by limiting work to one branch, but it should exercise the real learning loop.
