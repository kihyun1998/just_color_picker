# color-conversions

## What it is
Pure functions that turn a `Color` into HEX, RGB and HSL values and back. Since 0.4.0 these are what the package offers instead of input widgets.

## Governing decisions
**None** as a decision record. CHANGELOG 0.4.0 records the direction: input and display widgets removed, "the library now provides values and utilities instead of UI inputs".

## Design model
From reading the source only:
- HEX: `hexToColor` trims, drops one leading `#`, expands 3 digits to 6, prefixes `FF` to 6 digits, and parses 8 digits as `AARRGGBB`. Any other length returns `null`. `colorToHex` writes uppercase `RRGGBB`, or `AARRGGBB` with `includeAlpha`, with no `#`. `isValidHex` is `hexToColor(...) != null`.
- RGB and alpha travel as integers `0–255`; HSL as `h 0–360`, `s` and `l` `0–100`. Channels are read as `(channel * 255).round() & 0xff`.
- Outside input — a HEX string from a user — is bounded only by the length switch. `rgbToColor` and `hslToColor` do not clamp their arguments.

## Code
- `lib/src/utils/color_conversions.dart — hexToColor, colorToHex, isValidHex, colorToRgb, rgbToColor, hslToColor, colorToHsl`
- `test/just_color_picker_test.dart — group 'color_conversions'`

## Reference behaviour
**None.**

## Cross-cutting invariants
**None.**

## Blast radius
- [package-release](package-release.md) — every function here is public API, and the README's conversion table documents each signature; a changed return shape is a breaking change, as 0.4.0's `colorToHsl` alpha was.
- [example-playground](example-playground.md) — its preview box prints `colorToHex`'s output.

## Known holes / open
- Unverified: `int.tryParse` accepts a leading sign, so an 8-character string like `-1234567` may pass `isValidHex`. Not run; no Dart toolchain in this reading.
- Out-of-range arguments to `rgbToColor` and `hslToColor` are passed on as they are.
