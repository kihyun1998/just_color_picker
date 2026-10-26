# color-state

## What it is
The one store of the picked color: an immutable HSV value plus alpha that every control reads from and writes a copy of.

## Governing decisions
**None.** No decision record exists; CHANGELOG 0.4.0's "values and utilities instead of UI inputs" decides what the package exports, not how the state is held.

## Design model
From reading the source only:
- `ColorState` wraps one `HSVColor`; every `with*` returns a new instance (`color_state.dart — ColorState::withHue`, `withSV`, `withAlpha`).
- `withHue` wraps with `hue % 360`, so `360` becomes `0`. Every control that feeds it emits `[0, 360)`, so the wrap only acts on out-of-range input ([hue-bar](hue-bar.md#design-model)). `withSV` and `withAlpha` clamp to `0–1`. The factories (`fromHSV`, `fromColor`, `fromAHSV`) do not clamp; `HSVColor.fromAHSV` asserts its own ranges.
- Equality and `hashCode` delegate to the wrapped `HSVColor`.
- `fromColor` goes through `HSVColor.fromColor`, which cannot recover a hue for a grey (saturation 0) or for black (value 0): it returns hue 0 there, and saturation 0 for black. `JustColorPicker` avoids the round trip for echoes ([picker-composition](picker-composition.md#design-model)). Any other caller of `fromColor` still loses the hue.

## Code
- `lib/src/models/color_state.dart — ColorState` (factories, getters, `with*`, `toColor`, `==`)
- `test/just_color_picker_test.dart — group 'ColorState'`

## Reference behaviour
**None.**

## Cross-cutting invariants
**None.**

## Blast radius
- [picker-composition](picker-composition.md) — it keeps its only copy of the color here and rebuilds it with `fromColor` in controlled mode, so a change to what `fromColor` preserves changes what the picker shows after every echo.
- [hue-bar](hue-bar.md) — the bar keeps its output below `360` so that `withHue`'s wrap never moves its thumb. Changing the wrap or the stored range moves that edge.

## Known holes / open
**None.**
