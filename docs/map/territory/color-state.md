# color-state

## What it is
The one store of the picked color: an immutable HSV value plus alpha that every control reads from and writes a copy of.

## Governing decisions
**None.** No decision record exists; CHANGELOG 0.4.0's "values and utilities instead of UI inputs" decides what the package exports, not how the state is held.

## Design model
From reading the source only:
- `ColorState` wraps one `HSVColor`; every `with*` returns a new instance (`color_state.dart — ColorState::withHue`, `withSV`, `withAlpha`).
- `withHue` wraps with `hue % 360`, so `360` becomes `0`. `withSV` and `withAlpha` clamp to `0–1`. The factories (`fromHSV`, `fromColor`, `fromAHSV`) do not clamp; `HSVColor.fromAHSV` asserts its own ranges.
- Equality and `hashCode` delegate to the wrapped `HSVColor`.
- `fromColor` goes through `HSVColor.fromColor`, which cannot recover a hue for a grey (saturation 0) or for black (value 0): it returns hue 0 there.

## Code
- `lib/src/models/color_state.dart — ColorState` (factories, getters, `with*`, `toColor`, `==`)
- `test/just_color_picker_test.dart — group 'ColorState'`

## Reference behaviour
**None.**

## Cross-cutting invariants
**None.**

## Blast radius
- [picker-composition](picker-composition.md) — it keeps its only copy of the color here and rebuilds it with `fromColor` in controlled mode, so a change to what `fromColor` preserves changes what the picker shows after every echo.
- [hue-bar](hue-bar.md) — the bar emits `360` at its right edge and relies on what `withHue` does with it.

## Known holes / open
- The `% 360` wrap turns the hue bar's right edge into hue `0` — see [hue-bar](hue-bar.md#known-holes--open).
- Hue is lost when a `Color` round-trips at saturation 0 or value 0 — see [picker-composition](picker-composition.md#known-holes--open). Not intended (maintainer, 2026-10-25).
