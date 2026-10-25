# hue-bar

## What it is
The `bar` layout's hue control: a horizontal spectrum where position along the width is hue `0–360`.

## Governing decisions
**None.**

## Design model
From reading the source only:
- `HueBar._handleDrag` maps `dx / width`, clamped to `0–1`, times 360. `HueBarPainter` puts the thumb at `hue / 360 * width` and paints `kHueColors` as an evenly spaced linear gradient.
- The bar paints at `thumbRadius * 2 + 12` high.
- Pointer input is clamped to the bar's width.

## Code
- `lib/src/widgets/hue_bar.dart — HueBar::_handleDrag, build`
- `lib/src/painters/hue_bar_painter.dart — HueBarPainter::paint`

## Reference behaviour
**None.**

## Cross-cutting invariants
- [drag-inverts-paint](../invariant/drag-inverts-paint.md) — `_handleDrag` against `HueBarPainter::paint`.
- [slider-track-height](../invariant/slider-track-height.md) — `HueBar::build`.

## Blast radius
- [color-state](color-state.md) — the `360` this bar emits at its right edge is wrapped there.
- [paint-primitives](paint-primitives.md) — the spectrum is `kHueColors`; even spacing is what makes a linear position a linear hue.
- [picker-composition](picker-composition.md) — it sizes this bar's box.

## Known holes / open
- Right edge jumps left: at `dx >= width` the bar emits `360`, `ColorState::withHue` wraps it to `0`, and `HueBarPainter` draws the thumb at the left edge. CHANGELOG 0.2.0 lists this as fixed, but `withHue` is unchanged since `4ef5313` and nothing in the bar avoids `360`. Read from the code, not run; the maintainer did not know it (maintainer, 2026-10-25). Tracked: #3
