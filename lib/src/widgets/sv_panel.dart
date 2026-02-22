import 'package:flutter/widgets.dart';

import '../painters/sv_panel_painter.dart';

/// A standalone SV (saturation–value) panel widget.
///
/// This is used only when the SV panel is rendered outside the hue wheel.
/// When embedded inside the wheel, the [HueWheel] widget handles it directly.
class SvPanel extends StatelessWidget {
  const SvPanel({
    super.key,
    required this.hue,
    required this.saturation,
    required this.value,
    required this.thumbRadius,
    required this.onChanged,
    this.onChangeEnd,
  });

  final double hue;
  final double saturation;
  final double value;
  final double thumbRadius;
  final void Function(double saturation, double value) onChanged;
  final VoidCallback? onChangeEnd;

  void _handleDrag(Offset local, Size size) {
    final s = (local.dx / size.width).clamp(0.0, 1.0);
    final v = 1.0 - (local.dy / size.height).clamp(0.0, 1.0);
    onChanged(s, v);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        return GestureDetector(
          onPanDown: (d) => _handleDrag(d.localPosition, size),
          onPanUpdate: (d) => _handleDrag(d.localPosition, size),
          onPanEnd: (_) => onChangeEnd?.call(),
          child: CustomPaint(
            painter: SvPanelPainter(
              hue: hue,
              saturation: saturation,
              value: value,
              thumbRadius: thumbRadius,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}
