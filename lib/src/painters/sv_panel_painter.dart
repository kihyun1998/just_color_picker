import 'package:flutter/rendering.dart';

import 'paint_utils.dart';

/// Paints the Saturation–Value rectangle with a thumb indicator.
///
/// The panel uses two overlapping linear gradients:
/// 1. Horizontal: white → pure hue color (saturation axis).
/// 2. Vertical: transparent → black (value axis).
class SvPanelPainter extends CustomPainter {
  const SvPanelPainter({
    required this.hue,
    required this.saturation,
    required this.value,
    required this.thumbRadius,
  });

  /// Current hue (0–360) — determines the right-edge color.
  final double hue;

  /// Current saturation (0–1).
  final double saturation;

  /// Current value/brightness (0–1).
  final double value;

  /// Radius of the thumb indicator.
  final double thumbRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 1) Horizontal gradient: white → pure hue.
    final hueColor = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
    final horizontalGradient = LinearGradient(
      colors: [const Color(0xFFFFFFFF), hueColor],
    );
    canvas.drawRect(
      rect,
      Paint()..shader = horizontalGradient.createShader(rect),
    );

    // 2) Vertical gradient: transparent → black.
    final verticalGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [const Color(0x00000000), const Color(0xFF000000)],
    );
    canvas.drawRect(
      rect,
      Paint()..shader = verticalGradient.createShader(rect),
    );

    // Draw thumb.
    final thumbCenter = Offset(
      saturation * size.width,
      (1.0 - value) * size.height,
    );
    final thumbColor = HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
    paintThumb(canvas, thumbCenter, thumbRadius, thumbColor);
  }

  @override
  bool shouldRepaint(SvPanelPainter oldDelegate) =>
      hue != oldDelegate.hue ||
      saturation != oldDelegate.saturation ||
      value != oldDelegate.value ||
      thumbRadius != oldDelegate.thumbRadius;
}
