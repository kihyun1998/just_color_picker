# just_color_picker

A customizable HSV color picker for Flutter with a circular hue wheel, saturation-value panel, alpha slider, and HEX input field. Zero external dependencies — built entirely with `CustomPainter`.

## Features

- Circular **Hue Wheel** with embedded **SV (Saturation-Value) Panel**
- **Alpha Slider** with checkerboard transparency background
- **HEX Input** field with bidirectional sync
- **HEX / RGB** color info display
- Uncontrolled and controlled modes
- Fully customizable sizes and visibility toggles

## Getting Started

Add the dependency:

```yaml
dependencies:
  just_color_picker: ^0.1.0
```

## Usage

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
  wheelDiameter: 300,      // wheel size
  wheelWidth: 30,           // ring thickness
  thumbRadius: 10,          // indicator size
  showAlpha: true,          // alpha slider
  showHexInput: true,       // HEX text field
  showColorInfo: true,      // HEX/RGB display
  showPreview: true,        // color swatch
)
```

## API

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `initialColor` | `Color?` | — | Initial color (uncontrolled mode) |
| `color` | `Color?` | — | Controlled color |
| `onColorChanged` | `ValueChanged<Color>` | **required** | Real-time color callback |
| `onColorChangeEnd` | `ValueChanged<Color>?` | `null` | Gesture-end callback |
| `wheelDiameter` | `double` | `280.0` | Wheel diameter |
| `wheelWidth` | `double` | `26.0` | Ring thickness |
| `showAlpha` | `bool` | `true` | Show alpha slider |
| `showHexInput` | `bool` | `true` | Show HEX input |
| `showColorInfo` | `bool` | `true` | Show color info |
| `showPreview` | `bool` | `true` | Show preview swatch |
| `thumbRadius` | `double` | `8.0` | Thumb indicator radius |
