import 'dart:math' as math;
import 'dart:ui' show Offset;

/// Converts a touch [position] relative to the center of the wheel into
/// a hue angle in degrees (0–360).
///
/// The returned angle starts from the top (12 o'clock position) and
/// increases clockwise.
double offsetToHue(Offset position, Offset center) {
  final dx = position.dx - center.dx;
  final dy = position.dy - center.dy;
  // atan2 returns radians from the positive x-axis, counter-clockwise.
  // We rotate so 0° is at the top and increases clockwise.
  final radians = math.atan2(dy, dx);
  final degrees = radians * 180.0 / math.pi;
  // Shift so that top (negative y-axis) = 0°.
  return (degrees + 90.0) % 360.0;
}

/// Returns the distance from [position] to [center].
double distanceToCenter(Offset position, Offset center) {
  return (position - center).distance;
}

/// Converts a hue angle (0–360, top = 0°, clockwise) to an [Offset]
/// on a circle of the given [radius] centered at [center].
Offset hueToOffset(double hue, double radius, Offset center) {
  // Convert from our coordinate system (top = 0°, clockwise)
  // to standard math angle (right = 0°, counter-clockwise).
  final radians = (hue - 90.0) * math.pi / 180.0;
  return Offset(
    center.dx + radius * math.cos(radians),
    center.dy + radius * math.sin(radians),
  );
}

/// Clamps [value] to the range [min]–[max].
double clampDouble(double value, double min, double max) {
  if (value < min) return min;
  if (value > max) return max;
  return value;
}
