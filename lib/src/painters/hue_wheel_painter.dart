import 'dart:math' as math;

import 'package:flutter/rendering.dart';

import '../utils/math_utils.dart';
import 'paint_utils.dart';

/// Paints a circular hue ring using [SweepGradient] and a thumb indicator.
class HueWheelPainter extends CustomPainter {
  const HueWheelPainter({
    required this.hue,
    required this.wheelWidth,
    required this.thumbRadius,
  });

  /// Current hue value (0–360).
  final double hue;

  /// The thickness of the hue ring.
  final double wheelWidth;

  /// Radius of the thumb indicator.
  final double thumbRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = math.min(size.width, size.height) / 2;
    final innerRadius = outerRadius - wheelWidth;

    // Draw hue ring.
    // SweepGradient always starts from 3 o'clock (positive x-axis).
    // We apply a -90° transform so that hue 0° (red) starts at 12 o'clock,
    // matching our coordinate system (top = 0°, clockwise).
    final ringPaint = Paint()
      ..shader = SweepGradient(
        colors: kHueColors,
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(Rect.fromCircle(center: center, radius: outerRadius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = wheelWidth;

    final ringRadius = (outerRadius + innerRadius) / 2;
    canvas.drawCircle(center, ringRadius, ringPaint);

    // Draw thumb.
    final thumbCenter = hueToOffset(hue, ringRadius, center);
    final thumbColor = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
    paintThumb(canvas, thumbCenter, thumbRadius, thumbColor);
  }

  @override
  bool shouldRepaint(HueWheelPainter oldDelegate) =>
      hue != oldDelegate.hue ||
      wheelWidth != oldDelegate.wheelWidth ||
      thumbRadius != oldDelegate.thumbRadius;
}
