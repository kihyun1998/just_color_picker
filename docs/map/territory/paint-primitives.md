# paint-primitives

## What it is
What every painter shares: the thumb drawing and the hue spectrum's colour stops. Extracted into one file in 0.2.0 (CHANGELOG 0.2.0, `5675528`).

## Governing decisions
**None.**

## Design model
From reading the source only:
- `kHueColors` is seven stops, red→yellow→green→cyan→blue→magenta→red, one per 60°. Both the ring's sweep gradient and the bar's linear gradient spread them evenly, so the list order and spacing are the hue scale.
- `paintThumb` draws a white ring at `radius + 2`, a faint border, and a fill in the given colour.

## Code
- `lib/src/painters/paint_utils.dart — kHueColors, paintThumb`

## Reference behaviour
**None.**

## Cross-cutting invariants
- [hue-angle-space](../invariant/hue-angle-space.md) — hue 0 at the top needs the list to start at red.

## Blast radius
- [hue-wheel](hue-wheel.md), [hue-bar](hue-bar.md) — both paint `kHueColors` assuming one stop per 60°; uneven or reordered stops make the painted colour disagree with the hue under the thumb.
- [sv-panel](sv-panel.md), [alpha-slider](alpha-slider.md) — their thumbs are `paintThumb`; its outer `radius + 2` is drawn inside the track height their boxes allow.

## Known holes / open
**None.**
