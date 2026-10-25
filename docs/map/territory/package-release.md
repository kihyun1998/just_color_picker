# package-release

## What it is
Shipping the package to pub.dev: the version, the changelog, the README a consumer reads first, the license, and watching the dependencies.

## Governing decisions
**None** as a decision record. Open issue #1 specifies Dependabot for the root pub dependencies (monthly, `increase-if-necessary`, one PR per root dependency, `example/` grouped). Tracked: #1.

## Design model
From reading the files:
- The version lives in `pubspec.yaml`. The README's install snippet pins it again (`just_color_picker: ^0.4.0`), and `CHANGELOG.md` heads each release; none of the three derives from another. Breaking changes are marked `**BREAKING**` in the changelog (0.4.0).
- The only non-SDK dependency is dev `flutter_lints` (`pubspec.yaml`), which `analysis_options.yaml` includes.
- The repo has no CI: there is no `.github/` (`ls .github`).

## Code
- `pubspec.yaml`, `CHANGELOG.md`, `README.md`, `LICENSE`, `analysis_options.yaml`
- `lib/just_color_picker.dart` — the exported surface

## Reference behaviour
**None.**

## Cross-cutting invariants
**None.**

## Blast radius
- [example-playground](example-playground.md) — it depends on the package by `path: ../`, so it builds against whatever `lib/` is, not the published version; the README points readers to it.

## Known holes / open
- Dependabot is specified and not built. Tracked: #1.
- No CI runs the tests or `flutter analyze`.
