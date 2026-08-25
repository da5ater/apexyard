# DailyXP — Phase R Declaration (2026-08-24)

**Decision (Mohamed, 2026-08-23/24):** after the grilling + traceability audit, the product
enters **Phase R** — a full redesign executed as shape-first vertical slices. This document
records the phase boundary; the shaping docs are its source of truth.

## What this supersedes

- **RELEASE-001 (#75) and its 2026-08-24 10:00 Cairo deadline** — forfeited by the Step C
  closure decision (`step-c-phase-close.md`, tracker `da5ater/dailyxp#92 [CLEAR-SLATE]`).
  Submission will be re-scoped as an end-of-phase gate once the redesigned product merits one.
- **FEED-001 (#74)** — out of Phase R scope (FeedModel stays orphaned; no obligation carried).
- **The v1 PRD as build authority** — `docs/design/dailyxp-v1.md` is input material and audit
  evidence, not gospel (per phase-close § next-phase entry point).
- **Old IA assumptions** — Play/Journey/World placement, sheet inventories, Stitch screen
  dispositions are candidate material only; Shape A's breadboard defines the real structure.

## What Phase R is

Shaping completed and approved 2026-08-24:

| Artifact | Location |
|----------|----------|
| Grilling handoff + requirements traceability audit | conversation record 2026-08-23/24 |
| Shaping doc (R set final, spikes S1/S2 proven, Shape A selected) | `projects/dailyxp/shaping/shaping-doc.md` |
| Slices V1–V8 (approved with integrity correction 2026-08-24: V9 engine-bind removed; V2+ bind real engine) | `projects/dailyxp/shaping/slices.md` |

Delivery doctrine per slice: one user-observable moment per PR — **UI + real domain behavior + real persistence + visible evidence** for every slice ≥V2 · deterministic visual evidence at real dimensions (`qt6 offscreen+software` harness) · design-review gate on every `.qml` diff (wired via ops `project-config.json ui_paths`) · Rex beside, not instead · CEO per-PR merge approval unchanged.

## Engine boundary (load-bearing clarification, corrected 2026-08-24)

The current JS models + journals are **frozen for V1 only** — the sole stub-driven slice,
the real-QML shell prototype. From V2 onward every slice binds the real engine
incrementally (planning → session → progression → routines → habits/overdue → story/
recovery → settings/export/bar), proving one user moment against real persistence each
time; the fixture adapter retires progressively and there is no end-phase engine-bind
slice. The freeze asserts nothing about the engine's completeness or correctness for
the final respec — any gap a bind exposes becomes its own small PR.

## Scope boundaries (cannot silently return)

Share Cards · Feed/sound · competition/cloud/social · Season-XP machinery obligations ·
deep accessibility beyond keyboard/focus/reduced-motion · localization.
Cloud/AWS remains behind cold `da5ater/dailyxp#13` (re-audit 2026-10-20).

## Trace

- Precedent chain: `da5ater/dailyxp#57` (bulk-filing cutover) → `#92` (Step C clear-slate) → this declaration
- Step C durable record: `projects/dailyxp/step-c-phase-close.md` (11/13 merged, test floor 156)
- Audit rule honored: existing code is evidence, not product truth — nothing preserved merely because it exists
