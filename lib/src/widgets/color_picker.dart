import 'package:flutter/material.dart';

import '../models/color_state.dart';
import 'alpha_slider.dart';
import 'color_info_panel.dart';
import 'color_preview.dart';
import 'hex_input.dart';
import 'hue_wheel.dart';

/// A complete HSV color picker with a circular hue wheel, SV panel,
/// optional alpha slider, HEX input, and color info display.
///
/// Supports both **uncontrolled** mode (via [initialColor]) and
/// **controlled** mode (via [color]).
class JustColorPicker extends StatefulWidget {
  const JustColorPicker({
    super.key,
    this.initialColor,
    this.color,
    required this.onColorChanged,
    this.onColorChangeEnd,
    this.wheelDiameter = 280.0,
    this.wheelWidth = 26.0,
    this.showAlpha = true,
    this.showHexInput = true,
    this.showColorInfo = true,
    this.showPreview = true,
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

  /// Diameter of the hue wheel in logical pixels.
  final double wheelDiameter;

  /// Thickness of the hue ring.
  final double wheelWidth;

  /// Whether to show the alpha slider.
  final bool showAlpha;

  /// Whether to show the HEX input field.
  final bool showHexInput;

  /// Whether to show the color info panel (HEX/RGB values).
  final bool showColorInfo;

  /// Whether to show the color preview swatch.
  final bool showPreview;

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

  @override
  Widget build(BuildContext context) {
    final color = _state.toColor();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hue wheel + SV panel.
        HueWheel(
          hue: _state.hue,
          saturation: _state.saturation,
          value: _state.value,
          wheelDiameter: widget.wheelDiameter,
          wheelWidth: widget.wheelWidth,
          thumbRadius: widget.thumbRadius,
          onHueChanged: (hue) => _updateState(_state.withHue(hue)),
          onSVChanged: (s, v) => _updateState(_state.withSV(s, v)),
          onChangeEnd: _notifyEnd,
        ),

        // Alpha slider.
        if (widget.showAlpha) ...[
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  (widget.wheelDiameter -
                      widget.wheelDiameter +
                      widget.wheelWidth) /
                  2,
            ),
            child: SizedBox(
              width: widget.wheelDiameter - widget.wheelWidth,
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

        // Bottom row: preview + hex input + info panel.
        if (widget.showPreview ||
            widget.showHexInput ||
            widget.showColorInfo) ...[
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.wheelWidth / 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.showPreview) ...[
                  ColorPreview(color: color, size: 40),
                  const SizedBox(width: 12),
                ],
                if (widget.showHexInput) ...[
                  HexInput(
                    color: color,
                    showAlpha: widget.showAlpha,
                    onColorChanged: (c) {
                      final newState = ColorState.fromColor(c);
                      _updateState(newState);
                    },
                  ),
                  const SizedBox(width: 12),
                ],
                if (widget.showColorInfo)
                  ColorInfoPanel(color: color, showAlpha: widget.showAlpha),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
