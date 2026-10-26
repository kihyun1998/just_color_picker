# picker-composition

## What it is
`JustColorPicker`: the public widget that holds a `ColorState`, lays out the controls as `wheel` or `bar`, adds the optional alpha slider, and reports changes to the caller.

## Governing decisions
- **Controlled mode is strict** (maintainer, 2026-10-26, #5; theirs to reverse). They were shown three options: strict, as in Flutter's `Slider` (rejecting and clamping work; **BREAKING** for a parent that sets `color` but never rebuilds, such as `just_make_logo`'s dialog); documenting the semi-controlled behaviour (nothing breaks; rejecting and clamping stay unsupported); and an opt-in parameter (nothing breaks; a public parameter and two behaviours to keep). The table is in the decision comment on #5. Not covered by that call: the version bump, publishing, and the change to `just_make_logo`.
- **A change that leaves the colour unchanged is applied locally, even in strict mode** (maintainer, 2026-10-26, #5). Dragging the hue in grey, or the saturation in black, changes HSV without changing the `Color`. A parent that only rebuilds when a value changes (`ValueNotifier`, Riverpod, Bloc with `Equatable`) would never pass it back, and the thumb would freeze. The alternative shown, adopting the change only on a parent rebuild, was not chosen. The parent cannot see such a change, so it cannot reject it either, and strictness is kept for every visible colour.
**None** as a decision record. CHANGELOG 0.4.0 removed every input and display option from this widget; what remains is the picker and its callbacks.

## Design model
From reading the source only:
- Uncontrolled mode starts from `initialColor`, ignores later changes to it, and applies every drag to its own state. Controlled mode is on whenever `color` is non-null, and the picker shows only what `color` allows. `_updateState` keeps a drag's new state as `_candidate` and emits it. It changes `_state` directly only when the candidate's `Color` equals the shown one (see Governing decisions). `didUpdateWidget` then resolves the candidate. If the new `color` equals the candidate's `toColor()`, that is an echo, and the candidate's HSV is adopted. Otherwise, if `color` differs from `_state.toColor()`, the state is rebuilt with `ColorState.fromColor`. Otherwise (a rejection, or no rebuild at all) nothing moves. Comparing against `_state` rather than the previous `color` is what makes a parent that snaps back to the same value hold the picker (#5, measured 2026-10-26: under the old check a red/blue palette snap let the picker follow the finger at 200, 160, 60 and 30). Adopting the candidate rather than rebuilding is what keeps hue at saturation 0 or value 0, and saturation at value 0: a `Color` cannot carry them, and rebuilding from an echo turned grey and black into red (#4, measured 2026-10-26). The equality is exact and still holds when a parent stores the colour as an int, because `HSVColor.toColor` builds through `Color.fromARGB` with 8-bit integers and `Color ==` compares the components and the colour space. A non-echo grey or black still rebuilds and gets hue 0. Keeping the current hue there was offered to the maintainer and not chosen (2026-10-26). At least one of `color` and `initialColor` is asserted.
- Every control writes through `_updateState`, which also records the state as `_lastEmitted`. Every drag end calls `_notifyEnd`, which calls `onColorChangeEnd` with the last emitted colour, the one the drag ended on, as `Slider.onChangeEnd` does. A drag end with no emission reports the shown colour.
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
- Widget tests drive the hue bar's edges and the controlled-mode echo (`JustColorPicker controlled mode`). Nothing drives the wheel or the alpha slider.
