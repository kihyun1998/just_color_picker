# sv-panel

## What it is
The saturation–value square: saturation along x, value along y, used on its own in the `bar` layout and drawn inside the wheel in the `wheel` layout.

## Governing decisions
**None.**

## Design model
From reading the source only:
- `SvPanelPainter` paints white→pure-hue horizontally, then transparent→black vertically, and puts the thumb at `(saturation * width, (1 - value) * height)`.
- `SvPanel` is the standalone widget; it takes all the space its parent gives (`constraints.biggest`). Its doc comment says the wheel does not use it — the wheel uses only the painter.
- Pointer input is clamped to `0–1` on both axes.

## Code
- `lib/src/widgets/sv_panel.dart — SvPanel::_handleDrag, build`
- `lib/src/painters/sv_panel_painter.dart — SvPanelPainter::paint`

## Reference behaviour
**None.**

## Cross-cutting invariants
- [drag-inverts-paint](../invariant/drag-inverts-paint.md) — `SvPanel::_handleDrag` and the wheel's `_handleSV` against `SvPanelPainter::paint`.

## Blast radius
- [hue-wheel](hue-wheel.md) — `SvPanelPainter` is also drawn inside the wheel, so a painter change shows in both layouts.
- [paint-primitives](paint-primitives.md) — the thumb is `paintThumb`.

## Known holes / open
**None.**
