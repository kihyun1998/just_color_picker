# just_color_picker

A customizable HSV color picker for Flutter with a circular hue wheel, saturation-value panel, alpha slider, and color conversion utilities. Zero external dependencies — built entirely with `CustomPainter`.

## Features

- **Two layout styles** — circular `wheel` or linear `bar`, switchable via `ColorPickerType`
- Circular **Hue Wheel** with embedded **SV (Saturation-Value) Panel**
- Linear **Hue Bar** with standalone square **SV Panel**
- **Alpha Slider** with checkerboard transparency background
- **Color conversion utilities** — HEX, RGB, HSL with alpha support
- Uncontrolled and controlled modes
- Fully customizable sizes and visibility toggles

## Getting Started

Add the dependency:

```yaml
dependencies:
  just_color_picker: ^0.4.0
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
)
```

### Color Conversion Utilities

```dart
// HEX
final hex = colorToHex(color);                        // "FF5733"
final hexAlpha = colorToHex(color, includeAlpha: true); // "80FF5733"
final color = hexToColor('#FF5733');
final valid = isValidHex('#FF5733');

// RGB
final rgb = colorToRgb(color);   // (r: 255, g: 87, b: 51, a: 255)
final color = rgbToColor(255, 87, 51);
final color = rgbToColor(255, 87, 51, 128); // with alpha

// HSL
final hsl = colorToHsl(color);   // (h: 11.0, s: 100.0, l: 60.0, a: 255)
final color = hslToColor(11, 100, 60);
final color = hslToColor(11, 100, 60, 128); // with alpha
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
| `thumbRadius` | `double` | `8.0` | Thumb indicator radius |

### ColorState

| Property / Method | Type | Description |
|-------------------|------|-------------|
| `ColorState.fromColor(Color)` | factory | Create from a Flutter Color |
| `ColorState.fromHSV(HSVColor)` | factory | Create from an HSVColor |
| `ColorState.fromAHSV(a, h, s, v)` | factory | Create from individual components |
| `hue` | `double` | Hue (0–360) |
| `saturation` | `double` | Saturation (0–1) |
| `value` | `double` | Value / brightness (0–1) |
| `alpha` | `double` | Alpha (0–1) |
| `hsv` | `HSVColor` | Underlying HSVColor |
| `toColor()` | `Color` | Convert to Flutter Color |
| `withHue(double)` | `ColorState` | Copy with new hue |
| `withSV(double, double)` | `ColorState` | Copy with new saturation & value |
| `withAlpha(double)` | `ColorState` | Copy with new alpha |

### Standalone Widgets

These widgets are also exported for custom layouts:

| Widget | Description |
|--------|-------------|
| `HueWheel` | Circular hue ring with embedded SV panel |
| `HueBar` | Horizontal hue spectrum slider |
| `SvPanel` | Saturation-value rectangle |
| `AlphaSlider` | Opacity slider with checkerboard background |

### ColorState

Immutable wrapper around `HSVColor` with convenience methods for color manipulation.

```dart
// Create from a Color or HSV components
final state = ColorState.fromColor(Colors.blue);
final state = ColorState.fromHSV(myHsvColor);
final state = ColorState.fromAHSV(1.0, 210, 0.8, 0.9);

// Read components
state.hue;        // 0–360
state.saturation;  // 0–1
state.value;       // 0–1
state.alpha;       // 0–1
state.hsv;         // underlying HSVColor

// Immutable updates
final updated = state.withHue(120).withSV(0.5, 0.8).withAlpha(0.9);

// Convert back to Color
final color = state.toColor();
```

### Conversion Utilities

| Function | Description |
|----------|-------------|
| `colorToHex(Color, {includeAlpha})` | Color → `"FF5733"` |
| `hexToColor(String)` | `"#RGB"` / `"#RRGGBB"` / `"#AARRGGBB"` → Color? |
| `isValidHex(String)` | HEX string validation |
| `colorToRgb(Color)` | Color → `({int r, int g, int b, int a})` |
| `rgbToColor(int r, int g, int b, [int a])` | RGB → Color |
| `colorToHsl(Color)` | Color → `({double h, double s, double l, int a})` |
| `hslToColor(double h, double s, double l, [int a])` | HSL → Color |

## Example

The `example/` directory contains an interactive playground app where you can toggle all options in real time. Run it with:

```bash
cd example
flutter run
```
