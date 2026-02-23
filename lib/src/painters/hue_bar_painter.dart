import 'package:flutter/rendering.dart';

import 'paint_utils.dart';

/// Paints a horizontal hue bar with the full hue spectrum
/// and a thumb indicator at the current hue position.
class HueBarPainter extends CustomPainter {
  const HueBarPainter({required this.hue, required this.thumbRadius});

  /// Current hue (0–360).
  final double hue;

  /// Radius of the thumb indicator.
  final double thumbRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4));

    // Clip to rounded rect.
    canvas.save();
    canvas.clipRRect(rrect);

    // 1) Hue spectrum gradient: Red→Yellow→Green→Cyan→Blue→Magenta→Red.
    const gradient = LinearGradient(colors: kHueColors);
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));

    canvas.restore();

    // 2) Border.
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = const Color(0x33000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // 3) Thumb.
    final thumbX = (hue / 360.0) * size.width;
    final thumbCenter = Offset(thumbX.clamp(0.0, size.width), size.height / 2);
    final thumbColor = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
    paintThumb(canvas, thumbCenter, thumbRadius, thumbColor);
  }

  @override
  bool shouldRepaint(HueBarPainter oldDelegate) =>
      hue != oldDelegate.hue || thumbRadius != oldDelegate.thumbRadius;
}
