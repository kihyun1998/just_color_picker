# package-release

## What it is
Shipping the package to pub.dev: the version, the changelog, the README a consumer reads first, the license, and watching the dependencies.

## Governing decisions
**None** as a decision record. Dependabot's shape comes from #1 and two maintainer calls made on 2026-10-26, which are judgements and theirs to reverse. Both were made against #1's text and the `dependabot.yml` of the six sibling packages (`flutter_table_plus`, `flutter_dropdown_button`, `flutter_folderview`, `flutter_password_input`, `flutter_syntax_highlight`, `flutter_example_template`):
- `/example` is watched. #1 said both "root-only" and "Example PRs are grouped". The sibling that leaves `example/` out (`flutter_syntax_highlight`, its PR #33) does so because its example depends on nothing but lints. This example depends on `cupertino_icons`.
- The root runs weekly, not the monthly #1 named, so it matches all six siblings.
- CI's shape comes from three maintainer calls on #6 (2026-10-26), theirs to reverse, each shown with its consequences: two legs, the floor and stable, rather than stable only; no `dart format` gate rather than one on stable; and proving the workflow red once on a throwaway draft PR.
- `/example` also runs weekly. The siblings that watch their example run it monthly.

## Design model
From reading the files:
- The version lives in `pubspec.yaml`. The README's install snippet pins it again (`just_color_picker: ^<version>`), and `CHANGELOG.md` heads each release; none of the three derives from another. Breaking changes are marked `**BREAKING**` in the changelog (0.4.0). Changes that have not shipped go under a `## Unreleased` heading at the top, which is renamed to the version at release (first done for 0.5.0). This was the maintainer's call (2026-10-26, #3), chosen over bumping to `0.4.1` per fix.
- The only non-SDK dependency is dev `flutter_lints` (`pubspec.yaml`), which `analysis_options.yaml` includes.
- CI (`.github/workflows/ci.yml`) runs on every push to `main` and every PR. Each of `pub get`, `analyze` and `test` is its own step, for the package and then for `example/`. A step's exit status is its own, while a multi-line `run:` block depends on the shell's flags to stop at the first failure (sibling `flutter_dropdown_button`, whose CI had exactly that hole). It runs on two Flutter versions with `fail-fast: false`, so each leg reports:
  - **minimum, 3.35.3:** the first stable Flutter shipping Dart 3.9.2, which is the floor `sdk: ^3.9.2` promises (from `releases_linux.json`, 2026-10-26). It is the only leg that catches the package or a dependency needing something newer. #9 (`cupertino_icons 2`, needs Dart ^3.12) is green on stable and red here. `pubspec.yaml`'s `flutter: ">=3.35.3"` states the same floor (it read `>=3.27.0` until #6, which promised less than `sdk` already required). Raising either constraint means raising this pin and the other constraint in the same commit.
  - **stable:** the latest on the channel (3.47.8 / Dart 3.13.7 on 2026-10-26).
- `.pubignore` keeps `docs/` and `CLAUDE.md` out of the published archive. These are repository docs for maintainers and agents, added after 0.4.0. Without the file, 0.5.0's dry run listed them and warned that a top-level `docs` should be named `doc` (`pub publish --dry-run`, 2026-10-26: 293 KB with them, 278 KB and 0 warnings without). Pub reads `.pubignore` **in place of** the root `.gitignore`, so every root `.gitignore` entry is repeated in it. An entry added to one and not the other ships, or stops shipping, without anyone seeing it. The `.gitignore` files under `example/` still apply, since a `.pubignore` replaces only the `.gitignore` in its own directory.
- CI runs on Linux only. Nothing in the suite reads file paths, the cause of a Windows-only failure in sibling `flutter_example_template`.
- CI does not run `dart format`. The tree is formatted locally with Dart 3.11.5. Sibling `flutter_example_template` measured other SDKs' formatters rewriting files, so a format gate goes red on whichever leg's SDK disagrees. Run it locally.
- Dependabot watches pub in two directories (`.github/dependabot.yml`). The root runs weekly with `versioning-strategy: increase-if-necessary`, one PR per dependency. The root `pubspec.lock` is gitignored, as a library's should be, so the only thing to update is the constraint. A PR opens only when a release falls outside the caret, and at `0.x` every minor release does. Such a PR raises the floor for consumers, so each is a separate release decision. `/example` runs weekly with every dependency grouped into one PR: its `pubspec.lock` is committed, and nothing ships from it.
- Every entry labels its PRs `needs-triage`, which already exists in the repo. Nothing creates the label. A third entry watches the workflow's actions monthly, grouped into one PR, like the siblings that have workflows.

## Code
- `pubspec.yaml`, `CHANGELOG.md`, `README.md`, `LICENSE`, `analysis_options.yaml`, `.pubignore`
- `lib/just_color_picker.dart` — the exported surface
- `.github/dependabot.yml`, `.github/workflows/ci.yml`

## Reference behaviour
**None.**

## Cross-cutting invariants
**None.**

## Blast radius
- [example-playground](example-playground.md) — it depends on the package by `path: ../`, so it builds against whatever `lib/` is, not the published version; the README points readers to it.

## Known holes / open
