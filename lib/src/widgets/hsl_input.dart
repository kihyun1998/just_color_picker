import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/color_picker_input_theme.dart';
import '../utils/color_conversions.dart';
import 'color_text_field.dart';

/// A widget with H, S, L (and optional A) input fields.
///
/// - H: 0–360 (hue degrees)
/// - S: 0–100 (saturation percentage)
/// - L: 0–100 (lightness percentage)
/// - A: 0–255 (alpha, optional)
class HslInput extends StatefulWidget {
  const HslInput({
    super.key,
    required this.color,
    required this.onColorChanged,
    this.showAlpha = false,
    this.theme,
  });

  /// Current color to display.
  final Color color;

  /// Called when the user enters a valid value in any field.
  final ValueChanged<Color> onColorChanged;

  /// Whether to show the alpha field.
  final bool showAlpha;

  /// Optional theme for styling the input fields.
  final ColorPickerInputThemeData? theme;

  @override
  State<HslInput> createState() => _HslInputState();
}

class _HslInputState extends State<HslInput> {
  int _revertCount = 0;

  int _alpha(Color c) => (c.a * 255.0).round() & 0xff;

  void _submitH(String text) {
    final parsed = int.tryParse(text);
    if (parsed == null || parsed < 0 || parsed > 360) {
      setState(() => _revertCount++);
      return;
    }
    final hsl = colorToHsl(widget.color);
    final alpha = _alpha(widget.color);
    widget.onColorChanged(hslToColor(parsed.toDouble(), hsl.s, hsl.l, alpha));
  }

  void _submitS(String text) {
    final parsed = int.tryParse(text);
    if (parsed == null || parsed < 0 || parsed > 100) {
      setState(() => _revertCount++);
      return;
    }
    final hsl = colorToHsl(widget.color);
    final alpha = _alpha(widget.color);
    widget.onColorChanged(hslToColor(hsl.h, parsed.toDouble(), hsl.l, alpha));
  }

  void _submitL(String text) {
    final parsed = int.tryParse(text);
    if (parsed == null || parsed < 0 || parsed > 100) {
      setState(() => _revertCount++);
      return;
    }
    final hsl = colorToHsl(widget.color);
    final alpha = _alpha(widget.color);
    widget.onColorChanged(hslToColor(hsl.h, hsl.s, parsed.toDouble(), alpha));
  }

  void _submitA(String text) {
    final parsed = int.tryParse(text);
    if (parsed == null || parsed < 0 || parsed > 255) {
      setState(() => _revertCount++);
      return;
    }
    final hsl = colorToHsl(widget.color);
    widget.onColorChanged(hslToColor(hsl.h, hsl.s, hsl.l, parsed));
  }

  @override
  Widget build(BuildContext context) {
    final hsl = colorToHsl(widget.color);
    final h = hsl.h.round();
    final s = hsl.s.round();
    final l = hsl.l.round();
    final a = _alpha(widget.color);
    final fieldWidth = widget.theme?.fieldWidth ?? 52.0;

    final formatters3 = <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(3),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ColorTextField(
          value: h.toString(),
          label: 'H',
          theme: widget.theme,
          revisionKey: _revertCount,
          fieldWidth: fieldWidth,
          inputFormatters: formatters3,
          onSubmitted: _submitH,
        ),
        const SizedBox(width: 4),
        ColorTextField(
          value: s.toString(),
          label: 'S',
          theme: widget.theme,
          revisionKey: _revertCount,
          fieldWidth: fieldWidth,
          inputFormatters: formatters3,
          onSubmitted: _submitS,
        ),
        const SizedBox(width: 4),
        ColorTextField(
          value: l.toString(),
          label: 'L',
          theme: widget.theme,
          revisionKey: _revertCount,
          fieldWidth: fieldWidth,
          inputFormatters: formatters3,
          onSubmitted: _submitL,
        ),
        if (widget.showAlpha) ...[
          const SizedBox(width: 4),
          ColorTextField(
            value: a.toString(),
            label: 'A',
            theme: widget.theme,
            revisionKey: _revertCount,
            fieldWidth: fieldWidth,
            inputFormatters: formatters3,
            onSubmitted: _submitA,
          ),
        ],
      ],
    );
  }
}
