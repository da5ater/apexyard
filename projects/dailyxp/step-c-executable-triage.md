# Step C — Executable-bar AC triage (#68 → #75)

**Quality bar (set by Mohamed, 2026-08-22):** from #68 PROG-001 onward, every
acceptance criterion is judged against the **executable Omarchy plugin** — the
QML panel/bar/IPC/file/notification surfaces a reviewer gets from
`omarchy plugin add` — not just `node --test` or `docs/*.md`.

| Verdict | Meaning | PR shape |
|---------|---------|----------|
| IMPLEMENTED | Exact production code path exists + demonstrable in running plugin | Docs-only PR acceptable only on this verdict |
| PARTIAL | Some production path exists but missing wiring, UI, IPC, lifecycle, or OS integration | Same story's PR implements the missing production behavior |
| NOT IMPLEMENTED | No production code path (model stub, QML never renders it) | PR builds the minimal production path and demonstrates it |

Tests proving a model function returns the expected object are **not sufficient**
when the AC describes a user-visible or OS-integrated capability.

## Triage results

| # | Story | Pre-work verdict | Merged as | Post-work state |
|---|-------|------------------|-----------|-----------------|
| 68 | PROG-001 | PARTIAL — ledger/momentum/cap tested but never rendered | #86 `f39180b` | Panel Progress sheet + bar Lv/rank/Momentum + IPC |
| 69 | STORY-001 | PARTIAL/NOT — kingdom derived but never rendered | #87 `89bbdc7` | Kingdom sheet: provinces, landmarks, antagonists, Comeback Quest controls |
| 70 | RECOV-001 | PARTIAL — recovery never surfaced; no relapse/deletion UI | #88 `10e3c98` | Recovery sheet: tracks, backdated start, check-in, explicit relapse, restart, deletion scopes |
| 71 | UX-001 | PARTIAL — stacked single-scroll panel, reduced-motion hardcoded off | #89 `1e7cea8` | Play/Journey/World navigation, focused sheets, overdue fold, protected Recovery entry, reduced-motion bound to uxProjection |
| 72 | INSIGHT-001 | **NOT IMPLEMENTED** — `InsightModel.js` orphaned, not imported in StateStore | pending | Wire `insightProjection`; statistics sheet; app-tracking consent; Recovery isolation proof |
| 73 | SHARE-001 | **NOT IMPLEMENTED** — metadata object ≠ image; no export surface | pending | Card preview + field removal + rendered image + Save/Copy/preparePost; Recovery gated; sample labelled/isolated |
| 74 | FEED-001 | **NOT IMPLEMENTED** — sounds never play; budget orphaned | pending | FeedModel wired: shouldPlay gate, category volumes, quiet hours, visual equivalents, bundled notifications |
| 75 | RELEASE-001 | BLOCKED on #72–#74 | pending | Clean-install lifecycle offline matrix + refreshed marketplace evidence |

## Verification shape per PR

```sh
node --test tests/*.test.js
omarchy plugin validate .
/usr/lib/qt6/bin/qmllint -I /usr/share/omarchy/shell BarWidget.qml Panel.qml StateStore.qml
# plus manual lifecycle demo per affected story (panel open, bar states, IPC)
```

PR body must contain: triage table, narrative summary bullets, testing steps,
`Fixes #N`, glossary.

## Rex follow-ups from merged Step C reviews (candidates for tickets)

- Journal growth: nav/sheet UX events persist with no debounce/cap strategy
- Overdue-fold copy promises complete/reschedule actions that are not yet wired
- Duplicated surface literals between BarWidget and `UxModel.SURFACES`
- Unused `UxModel.js` import in Panel.qml (cleanup)

## Trace

- Supersedes the external plan file (`~/.claude/plans/vast-moseying-journal.md`) —
  this document is the canonical, versioned home for the executable bar.
- DAG: `projects/dailyxp/step-c-dag.md`
- PRD: dailyxp repo `docs/design/dailyxp-v1.md`
