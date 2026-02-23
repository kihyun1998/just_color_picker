import 'dart:ui' show Color;

/// Parses a HEX color string into a [Color].
///
/// Supported formats:
/// - `#RGB`
/// - `#RRGGBB`
/// - `#AARRGGBB`
///
/// The `#` prefix is optional. Returns `null` if parsing fails.
Color? hexToColor(String hex) {
  hex = hex.trim();
  if (hex.startsWith('#')) {
    hex = hex.substring(1);
  }

  if (hex.length == 3) {
    // #RGB → #RRGGBB
    hex = hex[0] * 2 + hex[1] * 2 + hex[2] * 2;
  }

  int? value;
  switch (hex.length) {
    case 6:
      value = int.tryParse('FF$hex', radix: 16);
    case 8:
      value = int.tryParse(hex, radix: 16);
    default:
      return null;
  }

  if (value == null) return null;
  return Color(value);
}

/// Formats a [Color] as a HEX string (e.g. `FF5733`), without `#`.
String colorToHex(Color color, {bool includeAlpha = false}) {
  final r = ((color.r * 255.0).round() & 0xff)
      .toRadixString(16)
      .padLeft(2, '0')
      .toUpperCase();
  final g = ((color.g * 255.0).round() & 0xff)
      .toRadixString(16)
      .padLeft(2, '0')
      .toUpperCase();
  final b = ((color.b * 255.0).round() & 0xff)
      .toRadixString(16)
      .padLeft(2, '0')
      .toUpperCase();
  if (includeAlpha) {
    final a = ((color.a * 255.0).round() & 0xff)
        .toRadixString(16)
        .padLeft(2, '0')
        .toUpperCase();
    return '$a$r$g$b';
  }
  return '$r$g$b';
}

/// Returns `true` if [hex] is a valid HEX color string.
bool isValidHex(String hex) => hexToColor(hex) != null;

/// Converts HSL values to a [Color].
///
/// - [h]: hue, 0–360
/// - [s]: saturation, 0–100
/// - [l]: lightness, 0–100
/// - [alpha]: opacity, 0–255 (default 255 = fully opaque)
Color hslToColor(double h, double s, double l, [int alpha = 255]) {
  final hNorm = (h % 360) / 360.0;
  final sNorm = s / 100.0;
  final lNorm = l / 100.0;

  double hueToRgb(double p, double q, double t) {
    var tt = t;
    if (tt < 0) tt += 1;
    if (tt > 1) tt -= 1;
    if (tt < 1 / 6) return p + (q - p) * 6 * tt;
    if (tt < 1 / 2) return q;
    if (tt < 2 / 3) return p + (q - p) * (2 / 3 - tt) * 6;
    return p;
  }

  double r, g, b;
  if (sNorm == 0) {
    r = g = b = lNorm;
  } else {
    final q = lNorm < 0.5 ? lNorm * (1 + sNorm) : lNorm + sNorm - lNorm * sNorm;
    final p = 2 * lNorm - q;
    r = hueToRgb(p, q, hNorm + 1 / 3);
    g = hueToRgb(p, q, hNorm);
    b = hueToRgb(p, q, hNorm - 1 / 3);
  }

  return Color.from(alpha: alpha / 255.0, red: r, green: g, blue: b);
}

/// Converts a [Color] to HSL components.
///
/// Returns a record with:
/// - `h`: hue, 0–360
/// - `s`: saturation, 0–100
/// - `l`: lightness, 0–100
({double h, double s, double l}) colorToHsl(Color color) {
  final r = color.r;
  final g = color.g;
  final b = color.b;

  final cMax = [r, g, b].reduce((a, b) => a > b ? a : b);
  final cMin = [r, g, b].reduce((a, b) => a < b ? a : b);
  final delta = cMax - cMin;

  final l = (cMax + cMin) / 2;

  double h, s;
  if (delta == 0) {
    h = 0;
    s = 0;
  } else {
    s = l > 0.5 ? delta / (2 - cMax - cMin) : delta / (cMax + cMin);

    if (cMax == r) {
      h = ((g - b) / delta + (g < b ? 6 : 0)) * 60;
    } else if (cMax == g) {
      h = ((b - r) / delta + 2) * 60;
    } else {
      h = ((r - g) / delta + 4) * 60;
    }
  }

  return (h: h, s: s * 100, l: l * 100);
}
