---
shaping: true
---

# DailyXP Phase R — Shaping

**Status:** Shape A (Four-Cartridge Console) selected by Mohamed, 2026-08-24.
**Sources:** grilling handoff (`handoff-grilling.md`), requirements traceability audit (2026-08-24), spikes S1+S2 (proven 2026-08-23), breadboard (this doc §Breadboard).
**Companion:** `slices.md` — slice breakdown, approved with integrity correction 2026-08-24 (no end-phase engine-bind; V2+ bind the real engine incrementally).

## Requirements (R) — final for this cycle

| ID | Requirement | Status |
|----|-------------|--------|
| R0 | DailyXP becomes something Mohamed actually uses daily on Omarchy; every merged PR leaves the product visibly better for a real user | Core goal |
| R1 | Complete navigable shell prototype — stub data, real bar+panel dimensions, retro-credible skin, zero overflow — exists before deepening, composed from extracted primitives so Panel.qml stops being the architecture | Must-have |
| R2 | Every implementation PR delivers one complete user-observable slice, touching model/persistence layers only when that slice requires them | Must-have |
| R3 | Every UI PR ships before/after evidence at real Omarchy dimensions from the deterministic harness, passes the design-review gate on `.qml` diffs, and renders exactly as production renders (software-safe techniques) | Must-have |
| R4 | Core loop end-to-end: create useful commitment → see it when needed → start → system responds → progress survives close/reopen/reboot | Core goal |
| R4.1 | Continuous focus accrual is the default interaction; recorded as formal AgDR vs Pomodoro cycles vs user-selectable mode | Leaning yes |
| R4.2 | XP accrues primarily from focused minutes elapsed (bonuses secondary); every award explainable and ledger user-visible | Leaning yes |
| R4.3 | Habit quick-check lives inside the landing experience | Leaning yes |
| R4.4 | Recovery stays private-by-default behind its guard | Carried constraint |
| R4.5 | Missing work produces a small restart/reschedule suggestion on landing — never an intimidating backlog dump | Must-have |
| R5 | Landing opens minimal + actionable; Journey/World directly discoverable; editorial never forces traversal of experiential surfaces | Must/Core |
| R5.1 | World carries kingdom identity as a light motivational motif — not a deep game system this phase | Scope boundary |
| R5.2 | Insights stay thin: personal progress / time / XP / streak-level only | Scope boundary |
| R6 | Built for Mohamed alone; nothing serves an imagined marketplace/cloud user | Leaning yes |
| R7 | Guided first-run: fresh install reaches first useful commitment and Play without understanding the data model — minimal, no tour | In (minimal) |
| R8 | Accessibility floor: keyboard operability + visible focus + reduced motion; deeper work explicitly deferred | Minimum accepted |

**Out of scope:** Share Cards · Feed/sound · competition/cloud/social · Season-XP machinery obligations · deep accessibility · localization.

**Constraint:** engine freeze applies to the shell prototype phase only; it asserts nothing about current-engine completeness/correctness for the final respec.

## Traceability appendix (old R ID → new home)

R0→R0 · R1→R1 · R2→R2 (reworded) · R3+R4(design-gate)→R3 · R5(core-loop)→R4.x · R6(timer)→R4.1 · R7(editorial)→R5 · R8(recovery)→R4.4 · R9(retro)→R1 skin clause · R10(single-user)→R6 · R11(primitives)→R1 · R12(XP)→R4.2 · R13(minimal open)→R5 · R14(discoverable motivation)→R5 · audit P10(onboarding)→R7 · audit U7(a11y)→R8.

## Shared foundation parts

| Part | Mechanism | Status |
|------|-----------|--------|
| K1 | Engine boundary — **corrected 2026-08-24**: V1 is the sole fixture-stub exception (real-QML shell prototype). From V2 on, every slice binds the real engine incrementally (planning→session→progression→routines→habits/overdue→story/recovery→settings/export/bar); fixture loader retires progressively. No end-phase engine-bind slice. | corrected |
| K2 | Primitives kit: ArcadeScreen / ArcadeCard / ArcadeSheet / BevelButton / SegmentedBar / StatChip; Panel.qml refactored to compose them | designed |
| K3 | Bar binding via existing IPC + projections, stub-fed initially | designed |
| K4 | Token bridge: Theme.qml singleton (Arcade Chronicle) | spike-proven S1 |
| K5 | Evidence harness: qt6 offscreen+software, grabToImage→saveToFile; software-safe rendering rule | spike-proven S2 |

## Shape A: Four-Cartridge Console

Persistent bottom controller, four cartridges (PLAY/JOURNEY/WORLD/SETUP), PLAY lands first. Full part tables and fit check in conversation history 2026-08-24; affordance-level breadboard below is authoritative.

## Breadboard

Places P0 shell-chrome · P1 PLAY(landing) · P2 JOURNEY · P3 WORLD · P4 SETUP · P5 Commitment Sheet · P6 Routine Sheet · P7 Recovery Guard · P8 Recovery Screen · P9 XP Ledger Sheet · E1 Engine (existing, frozen).

Key wiring (tables in conversation 2026-08-24): tabs→NavState→Loader-switch; PLAY rail START→SessionRuntime(tick/pause/finish→ledger.append); habit chips→complete; overdue-strip renders exactly one gentle suggestion (N27 suggest()); empty-state CTA→Commitment Sheet; SETUP routines/skills/settings/export/reset; Recovery Guard→Screen with private flag enforced at write sites; JOURNEY tiles/bar/thin-insights/Ledger link; WORLD province cards/Momentum banner/Hollow King cause-line.

**Breadboard correction 2026-08-24 (slice-integrity):** the engine chunk (E1/E2 projections + IPC verbs) is **no longer a V9 later-bind target**. From V2 onward each slice wires its N-affordances directly to the real E1/E2 affordances for that slice's domain (V2: planning verbs+journal · V3: sessionCommand+session replay · V4: progressionProjection · V5: routine generation · V6: HabitModel+carryover · V7: StoryModel+RecoveryModel privacy gates · V8: settings persistence+export+live bar). Stub affordances N10/N11 exist only inside V1 and retire progressively per-slice. Tables in conversation remain authoritative for the full wiring; the fixture path is a V1-scoped seam, not the system spine.

Verification notes: every display-U sourced; R4 loop traces clean end-to-end; R4.5 structural (single-suggestion rule); R5.2 enforced by absence of deeper analytics affordances; R8 keyboard chain N3 verified-by-V1-demo with visibility-toggle fallback if Loader focus breaks.

## Spikes

| # | Spike | Verdict |
|---|-------|---------|
| S1 | Arcade Chronicle → QML fidelity at panel size | Proven credible; bevels/segmented bars/cards/octagons survive; scanlines need α≈0.06 or background-only; Space Grotesk must be bundled |
| S2 | Deterministic evidence harness | Proven: `/usr/lib/qt6/bin/qml -platform offscreen`, `QT_QUICK_BACKEND=software`, grabToImage→saveToFile; custom ShaderEffects invisible under software renderer → production must use software-safe techniques |

## Phase-scope decisions carried from grilling

Deadline RELEASE-001 dead (forfeited per step-c-phase-close.md + tracker #92 clear-slate) · FEED-001 out · cloud/AWS deferred behind cold #13 (2026-10-20) · docs split ops↔repo · no bulk tracker ops.
