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

  /// Called when hue changes during dragging, with a hue in `[0, 360)`.
  final ValueChanged<double> onChanged;

  /// Called when the drag gesture ends.
  final VoidCallback? onChangeEnd;

  /// The hue emitted at the bar's right edge, just below 360.
  static const double _maxHue = 360.0 - 1e-9;

  void _handleDrag(Offset local, double width) {
    final newHue = ((local.dx / width) * 360.0).clamp(0.0, _maxHue);
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
