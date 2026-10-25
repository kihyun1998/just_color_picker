# hue-angle-space

## The fact
On the wheel, hue 0° is at 12 o'clock and hue increases clockwise, in screen coordinates (y down).

## Why it is cross-cutting
Three sites state it on their own. `offsetToHue` turns a touch into hue by adding 90° to `atan2`; `hueToOffset` places the thumb by subtracting 90°; `HueWheelPainter::paint` rotates the `SweepGradient` by `-π/2` so the gradient's start, red, lands at the top. The two `math_utils` functions do not call each other, and the gradient rotation reaches neither. Change one and the thumb, the finger and the colour under them disagree.

## Territories it holds in
- [hue-wheel](../territory/hue-wheel.md) — `math_utils.dart — offsetToHue, hueToOffset`; `hue_wheel_painter.dart — HueWheelPainter::paint` (`GradientRotation(-math.pi / 2)`).
- [paint-primitives](../territory/paint-primitives.md) — `kHueColors` must start at red for 0° to be red.

## What a violation looks like
Dragging to a colour on the ring selects a different hue, or the thumb sits a quarter turn away from the finger.

## Discovery history
- Read from the source at `fae37bc` (2026-10-25): the `+ 90.0`, `- 90.0` and `-math.pi / 2` and their comments each restate the convention.

## Where it will recur
Any code that converts between an angle and a hue on the wheel — a new hit test, a tick mark, a label — is subject to this.
