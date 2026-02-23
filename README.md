# just_color_picker

A customizable HSV color picker for Flutter with a circular hue wheel, saturation-value panel, alpha slider, HEX/RGB/HSL input fields, and a themeable input system. Zero external dependencies — built entirely with `CustomPainter`.

## Features

- **Two layout styles** — circular `wheel` or linear `bar`, switchable via `ColorPickerType`
- Circular **Hue Wheel** with embedded **SV (Saturation-Value) Panel**
- Linear **Hue Bar** with standalone square **SV Panel**
- **Alpha Slider** with checkerboard transparency background
- **HEX / RGB / HSL Input** fields with bidirectional sync
- **HEX / RGB / HSL** color info display
- **Input theme system** — customize text style, label style, decoration, cursor color, spacing, and field width via `ColorPickerInputThemeData`
- Uncontrolled and controlled modes
- Fully customizable sizes and visibility toggles

## Getting Started

Add the dependency:

```yaml
dependencies:
  just_color_picker: ^0.3.0
```

## Usage

### Wheel Mode (default)

```dart
import 'package:just_color_picker/just_color_picker.dart';

JustColorPicker(
  initialColor: Colors.blue,
  onColorChanged: (Color color) {
    // Called continuously during drag
  },
  onColorChangeEnd: (Color color) {
    // Called when drag ends
  },
)
```

### Bar Mode

```dart
JustColorPicker(
  type: ColorPickerType.bar,
  initialColor: Colors.blue,
  onColorChanged: (color) {},
)
```

### Controlled Mode

```dart
JustColorPicker(
  color: myColor,          // externally managed
  onColorChanged: (color) {
    setState(() => myColor = color);
  },
)
```

### Customization

```dart
JustColorPicker(
  initialColor: Colors.red,
  onColorChanged: (color) {},
  type: ColorPickerType.wheel, // wheel or bar
  wheelDiameter: 300,          // wheel / SV panel size
  wheelWidth: 30,              // ring thickness (wheel mode)
  thumbRadius: 10,             // indicator size
  showAlpha: true,             // alpha slider
  showHexInput: true,          // HEX text field
  showColorInfo: true,         // HEX/RGB display
  showPreview: true,           // color swatch
)
```

## Picker Types

### `ColorPickerType.wheel`

Circular hue ring with a saturation-value panel inscribed inside. Classic HSV wheel layout.

### `ColorPickerType.bar`

Square SV panel on top with a horizontal hue bar below it. Compact linear layout.

## API

### JustColorPicker

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `initialColor` | `Color?` | — | Initial color (uncontrolled mode) |
| `color` | `Color?` | — | Controlled color |
| `onColorChanged` | `ValueChanged<Color>` | **required** | Real-time color callback |
| `onColorChangeEnd` | `ValueChanged<Color>?` | `null` | Gesture-end callback |
| `type` | `ColorPickerType` | `wheel` | Layout style (`wheel` or `bar`) |
| `wheelDiameter` | `double` | `280.0` | Wheel diameter / SV panel size |
| `wheelWidth` | `double` | `26.0` | Ring thickness (wheel mode only) |
| `showAlpha` | `bool` | `true` | Show alpha slider |
| `showHexInput` | `bool` | `true` | Show HEX input |
| `showColorInfo` | `bool` | `true` | Show color info |
| `showPreview` | `bool` | `true` | Show preview swatch |
| `showRgbInput` | `bool` | `false` | Show RGB input fields |
| `showHslInput` | `bool` | `false` | Show HSL input fields |
| `thumbRadius` | `double` | `8.0` | Thumb indicator radius |
| `inputTheme` | `ColorPickerInputThemeData?` | `null` | Theme for all input fields |

### ColorPickerType

| Value | Description |
|-------|-------------|
| `wheel` | Circular hue ring with embedded SV panel (default) |
| `bar` | Horizontal hue bar with square SV panel |

### Standalone Widgets

These widgets are also exported for custom layouts:

| Widget | Description |
|--------|-------------|
| `HueWheel` | Circular hue ring with embedded SV panel |
| `HueBar` | Horizontal hue spectrum slider |
| `SvPanel` | Saturation-value rectangle |
| `AlphaSlider` | Opacity slider with checkerboard background |
| `HexInput` | HEX color code text field |
| `RgbInput` | R/G/B/A individual input fields (0–255) |
| `HslInput` | H/S/L/A individual input fields |
| `ColorTextField` | Reusable base input component |
| `ColorPreview` | Color swatch with checkerboard background |
| `ColorInfoPanel` | HEX / RGB / HSL value display |

## Example

The `example/` directory contains an interactive playground app where you can toggle all options in real time. Run it with:

```bash
cd example
flutter run
```
