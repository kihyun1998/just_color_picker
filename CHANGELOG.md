## 0.2.0

- **feat**: `ColorPickerType` — switch between `wheel` (circular hue ring) and `bar` (linear hue bar + square SV panel) layouts via the `type` parameter
- **feat**: `HueBar` widget — horizontal hue spectrum slider, usable standalone or through `JustColorPicker`
- **feat**: Interactive playground example app with real-time controls for all picker options
- **refactor**: Extract shared `paintThumb()` helper and `kHueColors` constant across all painters
- **fix**: Hue bar thumb no longer jumps to the left edge when dragged to the far right

## 0.1.0

- **feat**: HSV circular hue wheel with embedded SV (saturation-value) panel
- **feat**: Alpha slider with checkerboard transparency background
- **feat**: HEX color code input with bidirectional sync
- **feat**: HEX and RGB color info display
- **feat**: Uncontrolled (`initialColor`) and controlled (`color`) modes
- **feat**: Customizable wheel diameter, ring width, and thumb size
- **feat**: Toggle visibility of alpha slider, HEX input, color info, and preview
