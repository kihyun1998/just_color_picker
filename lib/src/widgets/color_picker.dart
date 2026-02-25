import 'package:flutter/widgets.dart';

import '../models/color_picker_type.dart';
import '../models/color_state.dart';
import 'alpha_slider.dart';
import 'hue_bar.dart';
import 'hue_wheel.dart';
import 'sv_panel.dart';

/// A complete HSV color picker with a circular hue wheel, SV panel,
/// and optional alpha slider.
///
/// Supports both **uncontrolled** mode (via [initialColor]) and
/// **controlled** mode (via [color]).
///
/// Use [type] to switch between the circular [ColorPickerType.wheel] layout
/// and the linear [ColorPickerType.bar] layout.
class JustColorPicker extends StatefulWidget {
  const JustColorPicker({
    super.key,
    this.initialColor,
    this.color,
    required this.onColorChanged,
    this.onColorChangeEnd,
    this.type = ColorPickerType.wheel,
    this.wheelDiameter = 280.0,
    this.wheelWidth = 26.0,
    this.showAlpha = true,
    this.thumbRadius = 8.0,
  }) : assert(
         initialColor != null || color != null,
         'Either initialColor or color must be provided.',
       );

  /// Initial color for uncontrolled mode.
  final Color? initialColor;

  /// Controlled color — when provided, the picker reflects this color
  /// and the parent is responsible for updating it via [onColorChanged].
  final Color? color;

  /// Called continuously while the user is dragging.
  final ValueChanged<Color> onColorChanged;

  /// Called when the user finishes a drag gesture.
  final ValueChanged<Color>? onColorChangeEnd;

  /// The layout style of the picker.
  final ColorPickerType type;

  /// Diameter of the hue wheel in logical pixels.
  /// In [ColorPickerType.bar] mode this controls the size of the SV panel.
  final double wheelDiameter;

  /// Thickness of the hue ring.
  final double wheelWidth;

  /// Whether to show the alpha slider.
  final bool showAlpha;

  /// Radius of thumb indicators.
  final double thumbRadius;

  @override
  State<JustColorPicker> createState() => _JustColorPickerState();
}

class _JustColorPickerState extends State<JustColorPicker> {
  late ColorState _state;

  bool get _isControlled => widget.color != null;

  @override
  void initState() {
    super.initState();
    final initial =
        widget.color ?? widget.initialColor ?? const Color(0xFF0000FF);
    _state = ColorState.fromColor(initial);
  }

  @override
  void didUpdateWidget(JustColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isControlled &&
        widget.color != oldWidget.color &&
        widget.color != null) {
      _state = ColorState.fromColor(widget.color!);
    }
  }

  void _updateState(ColorState newState) {
    setState(() => _state = newState);
    widget.onColorChanged(newState.toColor());
  }

  void _notifyEnd() {
    widget.onColorChangeEnd?.call(_state.toColor());
  }

  Widget _buildWheel() {
    return HueWheel(
      hue: _state.hue,
      saturation: _state.saturation,
      value: _state.value,
      wheelDiameter: widget.wheelDiameter,
      wheelWidth: widget.wheelWidth,
      thumbRadius: widget.thumbRadius,
      onHueChanged: (hue) => _updateState(_state.withHue(hue)),
      onSVChanged: (s, v) => _updateState(_state.withSV(s, v)),
      onChangeEnd: _notifyEnd,
    );
  }

  Widget _buildBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // SV panel (square, size = wheelDiameter).
        SizedBox(
          width: widget.wheelDiameter,
          height: widget.wheelDiameter,
          child: SvPanel(
            hue: _state.hue,
            saturation: _state.saturation,
            value: _state.value,
            thumbRadius: widget.thumbRadius,
            onChanged: (s, v) => _updateState(_state.withSV(s, v)),
            onChangeEnd: _notifyEnd,
          ),
        ),
        const SizedBox(height: 16),
        // Hue bar.
        SizedBox(
          width: widget.wheelDiameter,
          height: widget.thumbRadius * 2 + 12,
          child: HueBar(
            hue: _state.hue,
            thumbRadius: widget.thumbRadius,
            onChanged: (hue) => _updateState(_state.withHue(hue)),
            onChangeEnd: _notifyEnd,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBar = widget.type == ColorPickerType.bar;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hue selector + SV panel.
        if (isBar) _buildBar() else _buildWheel(),

        // Alpha slider.
        if (widget.showAlpha) ...[
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isBar ? 0 : widget.wheelWidth / 2,
            ),
            child: SizedBox(
              width: isBar
                  ? widget.wheelDiameter
                  : widget.wheelDiameter - widget.wheelWidth,
              height: widget.thumbRadius * 2 + 12,
              child: AlphaSlider(
                color: HSVColor.fromAHSV(
                  1.0,
                  _state.hue,
                  _state.saturation,
                  _state.value,
                ).toColor(),
                alpha: _state.alpha,
                thumbRadius: widget.thumbRadius,
                onChanged: (a) => _updateState(_state.withAlpha(a)),
                onChangeEnd: _notifyEnd,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
