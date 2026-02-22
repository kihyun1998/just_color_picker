import 'package:flutter/rendering.dart';

/// Paints a checkerboard pattern used as a transparency background.
class CheckerboardPainter extends CustomPainter {
  const CheckerboardPainter({this.cellSize = 6.0});

  final double cellSize;

  @override
  void paint(Canvas canvas, Size size) {
    final lightPaint = Paint()..color = const Color(0xFFFFFFFF);
    final darkPaint = Paint()..color = const Color(0xFFCCCCCC);

    // Fill with light color first.
    canvas.drawRect(Offset.zero & size, lightPaint);

    // Draw dark cells.
    final cols = (size.width / cellSize).ceil();
    final rows = (size.height / cellSize).ceil();
    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        if ((row + col) % 2 == 1) {
          final rect = Rect.fromLTWH(
            col * cellSize,
            row * cellSize,
            cellSize,
            cellSize,
          ).intersect(Offset.zero & size);
          canvas.drawRect(rect, darkPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CheckerboardPainter oldDelegate) =>
      cellSize != oldDelegate.cellSize;
}
