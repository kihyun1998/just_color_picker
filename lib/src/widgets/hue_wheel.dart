import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../painters/hue_wheel_painter.dart';
import '../painters/sv_panel_painter.dart';
import '../utils/math_utils.dart';

/// Displays a circular hue ring with an SV panel in the center.
///
/// Handles unified gesture detection to distinguish between ring drags
/// (hue changes) and panel drags (saturation/value changes).
class HueWheel extends StatelessWidget {
  const HueWheel({
    super.key,
    required this.hue,
    required this.saturation,
    required this.value,
    required this.wheelDiameter,
    required this.wheelWidth,
    required this.thumbRadius,
    required this.onHueChanged,
    required this.onSVChanged,
    this.onChangeEnd,
  });

  final double hue;
  final double saturation;
  final double value;
  final double wheelDiameter;
  final double wheelWidth;
  final double thumbRadius;
  final ValueChanged<double> onHueChanged;
  final void Function(double saturation, double value) onSVChanged;
  final VoidCallback? onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: wheelDiameter,
      height: wheelDiameter,
      child: _HueWheelGesture(
        hue: hue,
        saturation: saturation,
        value: value,
        wheelDiameter: wheelDiameter,
        wheelWidth: wheelWidth,
        thumbRadius: thumbRadius,
        onHueChanged: onHueChanged,
        onSVChanged: onSVChanged,
        onChangeEnd: onChangeEnd,
      ),
    );
  }
}

enum _DragTarget { hue, sv, none }

class _HueWheelGesture extends StatefulWidget {
  const _HueWheelGesture({
    required this.hue,
    required this.saturation,
    required this.value,
    required this.wheelDiameter,
    required this.wheelWidth,
    required this.thumbRadius,
    required this.onHueChanged,
    required this.onSVChanged,
    this.onChangeEnd,
  });

  final double hue;
  final double saturation;
  final double value;
  final double wheelDiameter;
  final double wheelWidth;
  final double thumbRadius;
  final ValueChanged<double> onHueChanged;
  final void Function(double saturation, double value) onSVChanged;
  final VoidCallback? onChangeEnd;

  @override
  State<_HueWheelGesture> createState() => _HueWheelGestureState();
}

class _HueWheelGestureState extends State<_HueWheelGesture> {
  _DragTarget _currentTarget = _DragTarget.none;

  double get _outerRadius => widget.wheelDiameter / 2;
  double get _innerRadius => _outerRadius - widget.wheelWidth;

  /// The SV panel is inscribed inside the inner circle.
  double get _panelSize => _innerRadius * math.sqrt2 - 4; // small padding

  Offset get _center => Offset(_outerRadius, _outerRadius);

  Rect get _panelRect {
    final half = _panelSize / 2;
    return Rect.fromCenter(center: _center, width: half * 2, height: half * 2);
  }

  _DragTarget _hitTest(Offset local) {
    final dist = distanceToCenter(local, _center);
    if (dist >= _innerRadius && dist <= _outerRadius) {
      return _DragTarget.hue;
    }
    if (_panelRect.contains(local)) {
      return _DragTarget.sv;
    }
    // If touching between panel edge and ring, determine closest target.
    if (dist < _innerRadius) {
      return _DragTarget.sv;
    }
    return _DragTarget.none;
  }

  void _handleHue(Offset local) {
    final newHue = offsetToHue(local, _center);
    widget.onHueChanged(newHue);
  }

  void _handleSV(Offset local) {
    final rect = _panelRect;
    final s = ((local.dx - rect.left) / rect.width).clamp(0.0, 1.0);
    final v = 1.0 - ((local.dy - rect.top) / rect.height).clamp(0.0, 1.0);
    widget.onSVChanged(s, v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) {
        _currentTarget = _hitTest(details.localPosition);
        switch (_currentTarget) {
          case _DragTarget.hue:
            _handleHue(details.localPosition);
          case _DragTarget.sv:
            _handleSV(details.localPosition);
          case _DragTarget.none:
            break;
        }
      },
      onPanUpdate: (details) {
        switch (_currentTarget) {
          case _DragTarget.hue:
            _handleHue(details.localPosition);
          case _DragTarget.sv:
            _handleSV(details.localPosition);
          case _DragTarget.none:
            break;
        }
      },
      onPanEnd: (_) {
        _currentTarget = _DragTarget.none;
        widget.onChangeEnd?.call();
      },
      child: CustomPaint(
        painter: HueWheelPainter(
          hue: widget.hue,
          wheelWidth: widget.wheelWidth,
          thumbRadius: widget.thumbRadius,
        ),
        foregroundPainter: _SvPanelForegroundPainter(
          hue: widget.hue,
          saturation: widget.saturation,
          value: widget.value,
          thumbRadius: widget.thumbRadius,
          panelRect: _panelRect,
        ),
        size: Size(widget.wheelDiameter, widget.wheelDiameter),
      ),
    );
  }
}

/// Draws the SV panel as a foreground layer within the hue wheel.
class _SvPanelForegroundPainter extends CustomPainter {
  const _SvPanelForegroundPainter({
    required this.hue,
    required this.saturation,
    required this.value,
    required this.thumbRadius,
    required this.panelRect,
  });

  final double hue;
  final double saturation;
  final double value;
  final double thumbRadius;
  final Rect panelRect;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(panelRect.left, panelRect.top);

    final panelSize = Size(panelRect.width, panelRect.height);
    final painter = SvPanelPainter(
      hue: hue,
      saturation: saturation,
      value: value,
      thumbRadius: thumbRadius,
    );
    painter.paint(canvas, panelSize);

    canvas.restore();
  }

  @override
  bool shouldRepaint(_SvPanelForegroundPainter oldDelegate) =>
      hue != oldDelegate.hue ||
      saturation != oldDelegate.saturation ||
      value != oldDelegate.value ||
      thumbRadius != oldDelegate.thumbRadius ||
      panelRect != oldDelegate.panelRect;
}
