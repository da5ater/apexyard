# Gamified LLM Wiki for self-directed learning — Validation

**Date**: 2026-06-15
**Source**: IDEA-001
**Verdict**: **GREEN** — The idea has a concrete first wedge, a painful current workaround, and a differentiating graph/interview loop worth speccing, as long as the first version stays narrow.

## Starting context

IDEA-001 — Gamified LLM Wiki for self-directed learning.

A gamified LLM-powered knowledge graph and study system that interviews students, manages first-class learning artifacts, connects Anki and vault notes, and measures progress through evidence-based achievements. (GH#1)

## Q1. Target user

Self-taught programming students are the first wedge, especially those using Obsidian and Anki while building portfolio projects. The broader audience could expand to solo builders, solo creators, knowledge workers, solopreneurs, and self-development learners who deal with text-heavy knowledge work and want an AI companion that maps prerequisites, knowledge graph nodes, and learning progress.

## Q2. Current alternative

Today they stitch together Obsidian, Anki, ChatGPT, traditional courses/tutorials, and sometimes Notion. Math Academy is the closest reference for prerequisite graphs, but only in math. For general knowledge and project tutorials, there is no clear alternative that turns material into a prerequisite-aware graph, interviews the learner node by node, and links notes/cards/tasks into one learning loop. The current workaround is too open-ended and exhausting.

## Q3. Smallest version

Smallest testable slice is a local Obsidian-vault flow: take one bounded source input, generate a prerequisite-aware knowledge graph, interview the learner node by node, use the conversation to identify misconceptions/prerequisites, dynamically adjust the graph, explain each node, and write the resulting node notes as Markdown in the vault. The assumption is that this can fit in 1-2 days because the artifact output is direct Markdown, not a separate export or integration layer.

## Q4. Kill criteria

Park the idea if the generated graph and final Markdown notes do not reflect the learner's actual understanding after the interview. Concrete failure signs: nodes explain concepts poorly, the graph does not expand around blind spots, misconceptions are not captured, prerequisites are missed, or the resulting zettels/notes feel disconnected from what the user manually understood during the conversation.

## Q5. Build / buy / rent

BUILD the orchestration layer, while BUY/borrow the surrounding ideas and surfaces. Obsidian can act as the Markdown viewer/storage surface; Math Academy inspires prerequisite graphs; boot.dev inspires project-shaped learning; Anki remains a likely spaced-repetition integration. The differentiator is the dynamic graph/interview loop that turns a source into learner-specific nodes, misconceptions, explanations, and durable notes.

## Read-out

The strongest part is the clear unmet workflow: learners already combine Obsidian, Anki, ChatGPT, and courses, but the prerequisite graph and diagnostic interview loop are missing. The risk is scope gravity: the audience and artifact system can become too broad fast. The spec should anchor on one source type, one learner profile, one vault format, and a small graph/interview loop before adding gamification, Anki, sharing, achievements, or media ingestion.

## Next step

Proceed to `/write-spec Gamified LLM Wiki for self-directed learning`.
