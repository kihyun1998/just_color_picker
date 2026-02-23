import 'dart:ui' show Color;

import '../utils/color_conversions.dart';

/// Interface for formatting a [Color] as a human-readable string.
abstract class ColorFormat {
  const ColorFormat();

  /// Display label (e.g. "HEX", "RGB").
  String get label;

  /// Formats [color] into a string representation.
  String format(Color color);
}

int _r(Color c) => (c.r * 255.0).round() & 0xff;
int _g(Color c) => (c.g * 255.0).round() & 0xff;
int _b(Color c) => (c.b * 255.0).round() & 0xff;
int _a(Color c) => (c.a * 255.0).round() & 0xff;

/// Formats a [Color] as a HEX string (e.g. `#FF5733` or `#80FF5733`).
class HexColorFormat extends ColorFormat {
  const HexColorFormat({this.includeAlpha = false});

  final bool includeAlpha;

  @override
  String get label => 'HEX';

  @override
  String format(Color color) {
    final r = _r(color).toRadixString(16).padLeft(2, '0').toUpperCase();
    final g = _g(color).toRadixString(16).padLeft(2, '0').toUpperCase();
    final b = _b(color).toRadixString(16).padLeft(2, '0').toUpperCase();
    if (includeAlpha) {
      final a = _a(color).toRadixString(16).padLeft(2, '0').toUpperCase();
      return '#$a$r$g$b';
    }
    return '#$r$g$b';
  }
}

/// Formats a [Color] as an RGB string (e.g. `rgb(255, 87, 51)`).
class RgbColorFormat extends ColorFormat {
  const RgbColorFormat({this.includeAlpha = false});

  final bool includeAlpha;

  @override
  String get label => includeAlpha ? 'RGBA' : 'RGB';

  @override
  String format(Color color) {
    if (includeAlpha) {
      final a = color.a.toStringAsFixed(2);
      return 'rgba(${_r(color)}, ${_g(color)}, ${_b(color)}, $a)';
    }
    return 'rgb(${_r(color)}, ${_g(color)}, ${_b(color)})';
  }
}

/// Formats a [Color] as an HSL string (e.g. `hsl(210, 65%, 47%)`).
class HslColorFormat extends ColorFormat {
  const HslColorFormat({this.includeAlpha = false});

  final bool includeAlpha;

  @override
  String get label => includeAlpha ? 'HSLA' : 'HSL';

  @override
  String format(Color color) {
    final hsl = colorToHsl(color);
    final h = hsl.h.round();
    final s = hsl.s.round();
    final l = hsl.l.round();
    if (includeAlpha) {
      final a = color.a.toStringAsFixed(2);
      return 'hsla($h, $s%, $l%, $a)';
    }
    return 'hsl($h, $s%, $l%)';
  }
}
