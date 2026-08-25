# Step C — Phase Closure (2026-08-22)

**Decision (Mohamed, 2026-08-22):** Step C is closed at **11 of 13 stories merged**. Stories
`#74` FEED-001 and `#75` RELEASE-001 are abandoned. The project's design is judged not good
enough to continue incrementally — the next phase is a **full redesign**, run by a separate
agent from a clean slate. This document is the canonical closure record; the tracker issue
`da5ater/dailyxp#[CLEAR-SLATE]` (linked below) supersedes the abandoned tickets.

## What shipped (the durable record)

Step B (4/4) + Step C executable stories #68–#73, every one under the **executable bar**
(ACs verified against the running plugin, not just node tests):

| Story | PR | Merge | What exists |
|-------|----|-------|-------------|
| FOUND/MODEL/PLAN/FOCUS/HABIT contracts (#63–#67) | #81–#85 | 2026-08-22 | Deterministic event model, planning carryover + consent, focused Session contract, habit streaks — hardened docs + coverage proofs |
| PROG-001 (#68) | #86 `f39180b` | 2026-08-22 | Panel Progress sheet, bar Lv/rank/Momentum, IPC |
| STORY-001 (#69) | #87 `89bbdc7` | 2026-08-22 | Kingdom sheet: provinces, landmarks, antagonists, Comeback Quest |
| RECOV-001 (#70) | #88 `10e3c98` | 2026-08-22 | Recovery sheet: tracks, backdated start, check-in, explicit relapse, restart, deletion scopes |
| UX-001 (#71) | #89 `1e7cea8` | 2026-08-22 | Play/Journey/World navigation, focused sheets, protected Recovery entry, reduced-motion |
| INSIGHT-001 (#72) | #90 `147b8ab` | 2026-08-22 | Statistics projection wired into StateStore, Journey statistics sheet, name-level app-tracking consent, Recovery structurally excluded |
| SHARE-001 (#73) | #91 `75495a6` | 2026-08-22 | Share sheet: live preview = exported PNG via grabToImage, per-field removal, sample mode labelled in-image, prepared X/LinkedIn/Facebook posts (never auto-post) |

Plus the earlier integrity fixes: session single-active/cap/boundaries (#61), recovery
privacy redaction (#62), DST fall-back + Day-Boundary replay (#60).

**Test floor at close:** 156/156 passing (`node --test tests/*.test.js`);
`omarchy plugin validate .` exit 0; qmllint zero errors.

## What is abandoned

- **#74 FEED-001** (bounded sound & notifications) — never started. `FeedModel.js` remains an orphaned pure model with no production wiring.
- **#75 RELEASE-001** (honest Omarchy competition build, deadline 2026-08-24 10:00 Cairo) — forfeited by this decision. The competition build will not be submitted from this codebase.
- The remaining DAG edges into RELEASE are dead; no partial FEED work exists to preserve.

## Why (honest rationale)

The incremental execution was sound — reviews caught real bugs and the executable bar held.
The judgment call is about the **product design itself**: after seeing eleven stories rendered
as real surfaces, Mohamed concluded the design needs a whole rethink rather than two more
stories bolted on. Closing now preserves a truthful boundary instead of shipping a release
that would misrepresent where the product actually is.

## What carries forward into the next phase

1. **Merged code stays merged on `main`.** It is real history. The next design may reuse:
   the deterministic local event model + journal replay pattern, the projection-lifecycle
   convention (`emptyProjection` / `decide` / `projectIntents` / journal restore), Recovery
   privacy isolation patterns, and the consent model for application tracking.
2. **Process lessons that transfer:** the executable bar worked (three persist-but-not-project
   bugs were caught precisely because ACs were judged against running surfaces, not tests);
   review cycles converge in ≤4 rounds when findings are verified from file truth.
3. **Cold ticket `da5ater/dailyxp#13`** (AWS/home-server re-audit, 2026-10-20) stays OPEN and
   untouched — it predates and outlives this phase.

## Next phase entry point

The next phase starts with a **clean slate and a redesign**, driven by a different agent:

1. `/handover` or `/tech-vision` on this repo to author the new architecture vision
   (target state, gap vs today, explicit anti-scope) — *before* any tickets are filed.
2. New stories are filed only via `/feature` | `/task` | `/bug`, same as the post-#57 regime.
3. Do not inherit Step C's PRD assumptions wholesale — treat `docs/design/dailyxp-v1.md`
   as input material, not gospel.

## Trace

- Superseding tracker issue: `[CLEAR-SLATE]` on `da5ater/dailyxp` (see ops doc update below)
- Precedent: `da5ater/dailyxp#57 [CLEAR-SLATE]` (bulk-filing cutover)
- Executable-bar record: `projects/dailyxp/step-c-executable-triage.md`
- DAG: `projects/dailyxp/step-c-dag.md`
