# alpha-slider

## What it is
The opacity control: a horizontal track over a checkerboard, transparent at the left and opaque at the right.

## Governing decisions
**None.**

## Design model
From reading the source only:
- `AlphaSlider._handleDrag` maps `dx / width`, clamped to `0–1`. `AlphaSliderPainter` puts the thumb at `alpha * width`.
- It is handed the current color at alpha 1 and paints a gradient from that color at 0 to it at 1 over a 6 px `CheckerboardPainter`.
- It paints at `thumbRadius * 2 + 12` high.

## Code
- `lib/src/widgets/alpha_slider.dart — AlphaSlider::_handleDrag, build`
- `lib/src/painters/alpha_slider_painter.dart — AlphaSliderPainter::paint`
- `lib/src/painters/checkerboard_painter.dart — CheckerboardPainter`

## Reference behaviour
**None.**

## Cross-cutting invariants
- [drag-inverts-paint](../invariant/drag-inverts-paint.md) — `_handleDrag` against `AlphaSliderPainter::paint`.
- [slider-track-height](../invariant/slider-track-height.md) — `AlphaSlider::build`.

## Blast radius
- [picker-composition](picker-composition.md) — it sizes this slider and passes the opaque color.
- [paint-primitives](paint-primitives.md) — the thumb is `paintThumb`.

## Known holes / open
**None.**
