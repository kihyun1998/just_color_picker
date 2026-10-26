# hue-bar

## What it is
The `bar` layout's hue control: a horizontal spectrum where position along the width is hue `0–360`.

## Governing decisions
**None** as a decision record. Where the right-edge fix lives was the maintainer's call (2026-10-26, #3), and theirs to reverse. They were shown three options: `HueBar` emits `[0, 360)`; `JustColorPicker` clamps before `withHue`; `ColorState` keeps `360`. They chose the first. The second leaves a consumer who wires `HueBar` to `ColorState.withHue` themselves (both are public, per the README) with the same bug. The third makes hue 0 and hue 360 unequal states and overlaps #4/#5.

## Design model
From reading the source only:
- `HueBar._handleDrag` maps `dx / width` times 360, clamped to `[0, HueBar._maxHue]`. `_maxHue` is `360 - 1e-9`, so `onChanged` emits `[0, 360)`, the same range `ColorState.withHue` stores and the wheel's `offsetToHue` returns. At the right edge the thumb sits about 1e-9 / 360 of the width short of the edge, and the colour still converts to `0xFFFF0000`. `HueBarPainter` puts the thumb at `hue / 360 * width` and paints `kHueColors` as an evenly spaced linear gradient.
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
- [color-state](color-state.md) — `withHue` stores `[0, 360)`. `_maxHue` exists to stay inside it, so a change to that range moves this bar's right edge.
- [paint-primitives](paint-primitives.md) — the spectrum is `kHueColors`; even spacing is what makes a linear position a linear hue.
- [picker-composition](picker-composition.md) — it sizes this bar's box.

## Known holes / open
- CHANGELOG 0.2.0 lists the right-edge jump as fixed. The only change in that release was the painter's thumb-x clamp, which keeps the thumb inside the bar but did not stop the wrap. The actual fix is #3 (reproduced 2026-10-26: a drag past the edge gave hue `0`).
