# drag-inverts-paint

## The fact
For every control, the widget's pointer-to-value mapping is the exact inverse of its painter's value-to-position mapping, so the thumb is drawn under the finger.

## Why it is cross-cutting
Each pair is written twice, in a widget and a painter that share no helper. Change one side and the other keeps the old mapping.

## Territories it holds in
- [sv-panel](../territory/sv-panel.md) — `SvPanel::_handleDrag` (`s = x / w`, `v = 1 - y / h`) against `SvPanelPainter::paint` (`(s * w, (1 - v) * h)`).
- [hue-wheel](../territory/hue-wheel.md) — `_HueWheelGestureState::_handleSV`, the same mapping relative to `_panelRect`, against `SvPanelPainter::paint`.
- [hue-bar](../territory/hue-bar.md) — `HueBar::_handleDrag` (`x / w * 360`) against `HueBarPainter::paint` (`hue / 360 * w`).
- [alpha-slider](../territory/alpha-slider.md) — `AlphaSlider::_handleDrag` (`x / w`) against `AlphaSliderPainter::paint` (`alpha * w`).

## What a violation looks like
The thumb drifts away from the finger during a drag, or the selected colour is not the one under the thumb. The hue bar's right edge is one already: the drag maps to 360, `withHue` wraps it to 0, and the painter draws 0 at the left ([hue-bar](../territory/hue-bar.md#known-holes--open)).

## Discovery history
- Read from the source at `fae37bc` (2026-10-25): four handler and painter pairs with matching formulas and no shared function.

## Where it will recur
If a widget turns a pointer position into a colour component and a painter draws that component's thumb, the two formulas are subject to this, and so is anything between them that changes the value, such as a wrap or a clamp.
