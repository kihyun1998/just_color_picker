# Territory map

<!-- grill-map build stamp: 18c00d1 -->
<!-- grill-map synced at: fae37bc (2026-10-25) -->

The map answers two questions before a change:

- **If I touch this, what else moves?** Open the territory note and work through its `## Blast radius` as a checklist; an edge with nothing to do is a correct outcome. Then follow `## Cross-cutting invariants`.
- **What is this shape derived from?** Read `## Governing decisions` and `## Design model`. A **None.** is the answer: this repo has no decision records, so most rules here are read from the source and say so.

A comment's why, trap and measured value go to a note here. Notes are added as they come up, or all at once with `grill-map`, which also reads hand-written notes as leads and keeps their paths.

Conventions: exact section headings in every note; `**None.**` for an empty section; symbols, never line numbers; relative links; a fact is linked, not restated; every claim carries its evidence, or its source and date.

The map cannot answer for source files or issues as nodes: they are text inside notes.

## The repo

A Flutter package with no non-SDK runtime dependency. One immutable HSV `ColorState` is the only store. Four controls each turn a drag into one component and paint it back. `JustColorPicker` composes them as `wheel` or `bar`. Pure functions convert colours to and from HEX, RGB and HSL. CI runs the tests on the Flutter floor and on stable (see [package-release](territory/package-release.md)). No test drives the wheel or the alpha slider.

## Territories

- [color-state](territory/color-state.md)
- [color-conversions](territory/color-conversions.md)
- [picker-composition](territory/picker-composition.md)
- [hue-wheel](territory/hue-wheel.md)
- [hue-bar](territory/hue-bar.md)
- [sv-panel](territory/sv-panel.md)
- [alpha-slider](territory/alpha-slider.md)
- [paint-primitives](territory/paint-primitives.md)
- [package-release](territory/package-release.md)
- [example-playground](territory/example-playground.md)

## Cross-cutting invariants

- [hue-angle-space](invariant/hue-angle-space.md)
- [drag-inverts-paint](invariant/drag-inverts-paint.md)
- [slider-track-height](invariant/slider-track-height.md)

## Scope

Covers `lib/`, `test/`, `example/`, the release files at the root, and `.github/` (Dependabot and CI belong to [package-release](territory/package-release.md)). Out of scope: `docs/agents/`, `CLAUDE.md` and `.metadata`, which configure tools rather than the package. A territory appears when something in the repo commits to it, such as code, a decision record or an open issue with a design. A missing note means nothing does yet.
