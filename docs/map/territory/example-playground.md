# example-playground

## What it is
The `example/` app: a playground that exposes every `JustColorPicker` option as a live control. Nothing ships from it.

## Governing decisions
**None.**

## Design model
From reading the source only:
- Depends on the package by `path: ../` and is `publish_to: 'none'` (`example/pubspec.yaml`).
- Keys the picker on `ValueKey(_type)`, so switching layout remounts it and uncontrolled mode starts again from the current colour.
- Builds its own colour preview with `colorToHex`; the library has had no preview widget since 0.4.0.

## Code
- `example/lib/main.dart — PlaygroundApp, PlaygroundPage, _PlaygroundPageState`
- `example/test/widget_test.dart`

## Reference behaviour
**None.**

## Cross-cutting invariants
**None.**

## Blast radius
- [picker-composition](picker-composition.md) — it sets every public parameter, so a renamed or removed one breaks this app first.

## Known holes / open
**None.**
