# package-release

## What it is
Shipping the package to pub.dev: the version, the changelog, the README a consumer reads first, the license, and watching the dependencies.

## Governing decisions
**None** as a decision record. Dependabot's shape comes from #1 and two maintainer calls made on 2026-10-26, which are judgements and theirs to reverse. Both were made against #1's text and the `dependabot.yml` of the six sibling packages (`flutter_table_plus`, `flutter_dropdown_button`, `flutter_folderview`, `flutter_password_input`, `flutter_syntax_highlight`, `flutter_example_template`):
- `/example` is watched. #1 said both "root-only" and "Example PRs are grouped". The sibling that leaves `example/` out (`flutter_syntax_highlight`, its PR #33) does so because its example depends on nothing but lints. This example depends on `cupertino_icons`.
- The root runs weekly, not the monthly #1 named, so it matches all six siblings.

## Design model
From reading the files:
- The version lives in `pubspec.yaml`. The README's install snippet pins it again (`just_color_picker: ^0.4.0`), and `CHANGELOG.md` heads each release; none of the three derives from another. Breaking changes are marked `**BREAKING**` in the changelog (0.4.0).
- The only non-SDK dependency is dev `flutter_lints` (`pubspec.yaml`), which `analysis_options.yaml` includes.
- The repo has no CI: `.github/` holds only `dependabot.yml`.
- Dependabot watches pub in two directories (`.github/dependabot.yml`). The root runs weekly with `versioning-strategy: increase-if-necessary`, one PR per dependency. The root `pubspec.lock` is gitignored, as a library's should be, so the only thing to update is the constraint. A PR opens only when a release falls outside the caret, and at `0.x` every minor release does. Such a PR raises the floor for consumers, so each is a separate release decision. `/example` runs monthly with every dependency grouped into one PR: its `pubspec.lock` is committed, and nothing ships from it.
- Both entries label their PRs `needs-triage`, which already exists in the repo. Nothing creates the label. There is no `github-actions` entry because there is no workflow to watch.

## Code
- `pubspec.yaml`, `CHANGELOG.md`, `README.md`, `LICENSE`, `analysis_options.yaml`
- `lib/just_color_picker.dart` — the exported surface
- `.github/dependabot.yml`

## Reference behaviour
**None.**

## Cross-cutting invariants
**None.**

## Blast radius
- [example-playground](example-playground.md) — it depends on the package by `path: ../`, so it builds against whatever `lib/` is, not the published version; the README points readers to it.

## Known holes / open
- No CI runs the tests or `flutter analyze`. Tracked: #6. The first workflow also needs a `github-actions` entry in `.github/dependabot.yml`. The siblings that have workflows run it monthly with every action grouped into one PR.
