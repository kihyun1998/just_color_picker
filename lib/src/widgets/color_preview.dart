import 'package:flutter/widgets.dart';

import '../painters/checkerboard_painter.dart';

/// Displays a color swatch preview with a checkerboard background
/// for visualizing alpha transparency.
class ColorPreview extends StatelessWidget {
  const ColorPreview({super.key, required this.color, this.size = 40.0});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: CustomPaint(
          painter: const CheckerboardPainter(cellSize: 4.0),
          foregroundPainter: _SolidColorPainter(color),
          size: Size(size, size),
        ),
      ),
    );
  }
}

class _SolidColorPainter extends CustomPainter {
  const _SolidColorPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_SolidColorPainter oldDelegate) =>
      color != oldDelegate.color;
}
