import 'package:flutter/widgets.dart';

import '../painters/alpha_slider_painter.dart';

/// A horizontal alpha (opacity) slider.
class AlphaSlider extends StatelessWidget {
  const AlphaSlider({
    super.key,
    required this.color,
    required this.alpha,
    required this.thumbRadius,
    required this.onChanged,
    this.onChangeEnd,
  });

  /// The fully opaque version of the selected color.
  final Color color;

  /// Current alpha value (0–1).
  final double alpha;

  /// Radius of the thumb indicator.
  final double thumbRadius;

  /// Called when alpha changes during dragging.
  final ValueChanged<double> onChanged;

  /// Called when the drag gesture ends.
  final VoidCallback? onChangeEnd;

  void _handleDrag(Offset local, double width) {
    final newAlpha = (local.dx / width).clamp(0.0, 1.0);
    onChanged(newAlpha);
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
            painter: AlphaSliderPainter(
              color: color,
              alpha: alpha,
              thumbRadius: thumbRadius,
            ),
            size: Size(width, thumbRadius * 2 + 12),
          ),
        );
      },
    );
  }
}
