## 0.3.0

- **feat**: `RgbInput` widget — R/G/B/A individual input fields (0–255)
- **feat**: `HslInput` widget — H/S/L/A individual input fields (H: 0–360, S/L: 0–100)
- **feat**: `ColorTextField` — reusable base input component with bidirectional sync and revert mechanism
- **feat**: `ColorPickerInputThemeData` — theme system for styling all input fields (text style, label style, decoration, cursor color, spacing, field width)
- **feat**: `HslColorFormat` — format colors as `hsl(210, 65%, 47%)` strings
- **feat**: `hslToColor()` / `colorToHsl()` conversion utilities
- **feat**: `showRgbInput`, `showHslInput`, `inputTheme` parameters on `JustColorPicker`
- **feat**: `showHsl`, `theme` parameters on `ColorInfoPanel`
- **feat**: Input theme preset selector (Default / Rounded / Minimal / Bold) in playground example
- **refactor**: `HexInput` now uses `ColorTextField` internally, accepts `theme` parameter

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
