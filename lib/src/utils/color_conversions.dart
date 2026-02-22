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
