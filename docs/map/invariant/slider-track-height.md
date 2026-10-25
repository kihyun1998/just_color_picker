# slider-track-height

## The fact
A linear slider's track is `thumbRadius * 2 + 12` high, and the box its parent gives it is the same height.

## Why it is cross-cutting
The slider widgets size their own `CustomPaint` with the expression, and `JustColorPicker` sizes their boxes with it again, at four sites with no shared constant. The parent box decides the space; the child paints into what it computed. If one changes alone, the track is clipped or the thumb overflows. It is one rule (maintainer, 2026-10-25).

## Territories it holds in
Sites, from `git grep -n "thumbRadius \* 2 + 12" -- lib`:
- [hue-bar](../territory/hue-bar.md) — `HueBar::build`.
- [alpha-slider](../territory/alpha-slider.md) — `AlphaSlider::build`.
- [picker-composition](../territory/picker-composition.md) — `_JustColorPickerState::_buildBar` (hue bar box) and `build` (alpha slider box).

## What a violation looks like
The hue bar or alpha slider is cut off at the top or bottom, or the thumb ring is clipped, at any `thumbRadius`.

## Discovery history
- Read from the source at `fae37bc` (2026-10-25); the maintainer confirmed it is one rule (maintainer, 2026-10-25).

## Where it will recur
A new linear slider, or a new layout that hosts one, is subject to this.
