# hue-wheel

## What it is
The `wheel` layout's control: a hue ring with an SV panel inscribed inside it, one gesture detector deciding per drag whether the ring or the panel is being dragged.

## Governing decisions
**None.**

## Design model
From reading the source only:
- Geometry in `_HueWheelGestureState`: outer radius `wheelDiameter / 2`, inner radius `outer - wheelWidth`, panel side `inner * sqrt2 - 4` centred, so the square fits inside the inner circle with a small gap.
- The drag target is chosen once on pan-down by `_hitTest` and kept for the whole drag: inside the ring band is hue; inside the panel, or anywhere inside the inner circle, is SV (clamped to the panel); outside the outer circle is none.
- `_panelRect` is computed once and passed to `_SvPanelForegroundPainter`, so hit-testing and painting share one rectangle.
- `HueWheelPainter` derives its radii from the canvas size, `min(width, height) / 2`; it agrees with the gesture state's `wheelDiameter / 2` because `HueWheel` gives the paint a `wheelDiameter` square.
- Pointer input is bounded by the widget's box; every SV value is clamped to `0–1`.

## Code
- `lib/src/widgets/hue_wheel.dart — HueWheel`, `_HueWheelGestureState::_hitTest, _handleHue, _handleSV, _panelRect`, `_SvPanelForegroundPainter`
- `lib/src/painters/hue_wheel_painter.dart — HueWheelPainter::paint`
- `lib/src/utils/math_utils.dart — offsetToHue, hueToOffset, distanceToCenter` (`clampDouble` has no caller in `lib/`)

## Reference behaviour
**None.**

## Cross-cutting invariants
- [hue-angle-space](../invariant/hue-angle-space.md) — `offsetToHue`, `hueToOffset`, and the ring gradient's rotation.
- [drag-inverts-paint](../invariant/drag-inverts-paint.md) — `_handleSV` against `SvPanelPainter`.

## Blast radius
- [sv-panel](sv-panel.md) — the wheel draws `SvPanelPainter` inside its own foreground, so a change to the painter shows here, and a change to the panel rectangle changes where SV drags land.
- [paint-primitives](paint-primitives.md) — the ring is `kHueColors` swept, and hue 0 at the top assumes the list starts at red.
- [picker-composition](picker-composition.md) — it lines the alpha slider up with this ring's inner edge.

## Known holes / open
- `clampDouble` in `math_utils.dart` has no caller in `lib/` (`git grep clampDouble`).
