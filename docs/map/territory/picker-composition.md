# picker-composition

## What it is
`JustColorPicker`: the public widget that holds a `ColorState`, lays out the controls as `wheel` or `bar`, adds the optional alpha slider, and reports changes to the caller.

## Governing decisions
**None** as a decision record. CHANGELOG 0.4.0 removed every input and display option from this widget; what remains is the picker and its callbacks.

## Design model
From reading the source only:
- Uncontrolled mode starts from `initialColor` and ignores later changes to it. Controlled mode is on whenever `color` is non-null; `didUpdateWidget` rebuilds the state with `ColorState.fromColor` when `color` changes, unless the new `color` equals `_state.toColor()`. That case is an echo of what the picker just emitted, and the HSV state is kept. A `Color` cannot carry hue at saturation 0 or value 0, or saturation at value 0, so rebuilding from an echo turned grey and black into red (#4, measured 2026-10-26). The equality is exact and still holds when a parent stores the colour as an int, because `HSVColor.toColor` builds through `Color.fromARGB` with 8-bit integers and `Color ==` compares the components and the colour space. A non-echo grey or black still rebuilds and gets hue 0. Keeping the current hue there was offered to the maintainer and not chosen (2026-10-26). At least one of the two is asserted.
- Every control writes through `_updateState`, which sets the local state and calls `onColorChanged`. Every drag end calls `_notifyEnd`, which calls `onColorChangeEnd` with the current color.
- `wheel` layout: a `HueWheel` of `wheelDiameter`. `bar` layout: a square `SvPanel` of `wheelDiameter`, a 16 px gap, then a `HueBar`.
- The alpha slider is `wheelDiameter - wheelWidth` wide with `wheelWidth / 2` padding on each side in `wheel` layout, which lines it up with the ring's inner edge; it is `wheelDiameter` wide in `bar` layout. It is given the current color at alpha 1.

## Code
- `lib/src/widgets/color_picker.dart — JustColorPicker`, `_JustColorPickerState::initState, didUpdateWidget, _updateState, _notifyEnd, _buildWheel, _buildBar, build`
- `lib/src/models/color_picker_type.dart — ColorPickerType`
- `test/just_color_picker_test.dart — group 'JustColorPicker widget'` (renders only; no gesture test)

## Reference behaviour
**None.**

## Cross-cutting invariants
- [slider-track-height](../invariant/slider-track-height.md) — the two `SizedBox`es in `_buildBar` and `build`.

## Blast radius
- [hue-wheel](hue-wheel.md) — the alpha slider's width and padding assume the ring's inner edge sits `wheelWidth` in from `wheelDiameter`.
- [hue-bar](hue-bar.md), [alpha-slider](alpha-slider.md) — they paint at the height this widget's boxes give them.
- [sv-panel](sv-panel.md) — in `bar` layout the panel's size is the box this widget sets.
- [color-state](color-state.md) — controlled mode depends on what `fromColor` can recover.
- [package-release](package-release.md) — the constructor parameters are public and listed in the README's API table.
- [example-playground](example-playground.md) — it drives every parameter.

## Known holes / open
- Controlled mode is not strict: `_updateState` moves the local state even when the parent never passes a new `color`. Not intended (maintainer, 2026-10-25). Tracked: #5. A strict fix still has to keep the echo rule, because under strict mode the echo is the only way the state moves. The `JustColorPicker controlled mode` tests fail if every rebuild is skipped.
- Widget tests drive the hue bar's edges and the controlled-mode echo (`JustColorPicker controlled mode`). Nothing drives the wheel or the alpha slider.
