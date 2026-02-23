import 'package:flutter/rendering.dart';

/// The seven hue stops (0°→60°→120°→180°→240°→300°→360°) used by both
/// the circular hue wheel and the linear hue bar.
const List<Color> kHueColors = [
  Color(0xFFFF0000), // 0°   Red
  Color(0xFFFFFF00), // 60°  Yellow
  Color(0xFF00FF00), // 120° Green
  Color(0xFF00FFFF), // 180° Cyan
  Color(0xFF0000FF), // 240° Blue
  Color(0xFFFF00FF), // 300° Magenta
  Color(0xFFFF0000), // 360° Red (wrap)
];

/// Draws a circular thumb indicator with a white outer ring, a subtle
/// shadow border, and a filled inner circle.
void paintThumb(Canvas canvas, Offset center, double radius, Color color) {
  // White outer ring.
  canvas.drawCircle(
    center,
    radius + 2,
    Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill,
  );
  // Subtle shadow border.
  canvas.drawCircle(
    center,
    radius + 2,
    Paint()
      ..color = const Color(0x33000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0,
  );
  // Inner fill.
  canvas.drawCircle(
    center,
    radius,
    Paint()
      ..color = color
      ..style = PaintingStyle.fill,
  );
}
