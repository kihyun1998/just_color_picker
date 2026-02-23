import 'package:flutter/widgets.dart';

import '../painters/hue_bar_painter.dart';

/// A horizontal hue bar slider.
class HueBar extends StatelessWidget {
  const HueBar({
    super.key,
    required this.hue,
    required this.thumbRadius,
    required this.onChanged,
    this.onChangeEnd,
  });

  /// Current hue (0–360).
  final double hue;

  /// Radius of the thumb indicator.
  final double thumbRadius;

  /// Called when hue changes during dragging.
  final ValueChanged<double> onChanged;

  /// Called when the drag gesture ends.
  final VoidCallback? onChangeEnd;

  void _handleDrag(Offset local, double width) {
    final newHue = (local.dx / width).clamp(0.0, 1.0) * 360.0;
    onChanged(newHue);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          onPanDown: (d) => _handleDrag(d.localPosition, width),
          onPanUpdate: (d) => _handleDrag(d.localPosition, width),
          onPanEnd: (_) => onChangeEnd?.call(),
          child: CustomPaint(
            painter: HueBarPainter(hue: hue, thumbRadius: thumbRadius),
            size: Size(width, thumbRadius * 2 + 12),
          ),
        );
      },
    );
  }
}
