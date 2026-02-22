import 'package:flutter/rendering.dart';

import 'checkerboard_painter.dart';

/// Paints a horizontal alpha slider with a checkerboard background,
/// a color gradient overlay, and a thumb indicator.
class AlphaSliderPainter extends CustomPainter {
  const AlphaSliderPainter({
    required this.color,
    required this.alpha,
    required this.thumbRadius,
  });

  /// The fully opaque version of the selected color.
  final Color color;

  /// Current alpha value (0–1).
  final double alpha;

  /// Radius of the thumb indicator.
  final double thumbRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4));

    // Clip to rounded rect.
    canvas.save();
    canvas.clipRRect(rrect);

    // 1) Checkerboard background.
    const checkerboard = CheckerboardPainter(cellSize: 6.0);
    checkerboard.paint(canvas, size);

    // 2) Gradient from transparent → opaque.
    final transparent = color.withValues(alpha: 0.0);
    final opaque = color.withValues(alpha: 1.0);
    final gradient = LinearGradient(colors: [transparent, opaque]);
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));

    canvas.restore();

    // 3) Border.
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = const Color(0x33000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // 4) Thumb.
    final thumbX = alpha * size.width;
    final thumbCenter = Offset(thumbX.clamp(0.0, size.width), size.height / 2);

    canvas.drawCircle(
      thumbCenter,
      thumbRadius + 2,
      Paint()
        ..color = const Color(0xFFFFFFFF)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      thumbCenter,
      thumbRadius + 2,
      Paint()
        ..color = const Color(0x33000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
    canvas.drawCircle(
      thumbCenter,
      thumbRadius,
      Paint()
        ..color = color.withValues(alpha: alpha)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(AlphaSliderPainter oldDelegate) =>
      color != oldDelegate.color ||
      alpha != oldDelegate.alpha ||
      thumbRadius != oldDelegate.thumbRadius;
}
