import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/color_picker_input_theme.dart';
import 'color_text_field.dart';

/// A widget with R, G, B (and optional A) input fields.
///
/// Each field accepts integer values (0–255) and independently
/// updates the color when submitted.
class RgbInput extends StatefulWidget {
  const RgbInput({
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
  State<RgbInput> createState() => _RgbInputState();
}

class _RgbInputState extends State<RgbInput> {
  int _revertCount = 0;

  int _r(Color c) => (c.r * 255.0).round() & 0xff;
  int _g(Color c) => (c.g * 255.0).round() & 0xff;
  int _b(Color c) => (c.b * 255.0).round() & 0xff;
  int _a(Color c) => (c.a * 255.0).round() & 0xff;

  void _submit(
    String text,
    int Function(Color) getCurrent,
    Color Function(int value) buildColor,
  ) {
    final parsed = int.tryParse(text);
    if (parsed == null || parsed < 0 || parsed > 255) {
      setState(() => _revertCount++);
      return;
    }
    // Only update if value actually changed.
    if (parsed == getCurrent(widget.color)) return;
    widget.onColorChanged(buildColor(parsed));
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.color;
    final r = _r(c);
    final g = _g(c);
    final b = _b(c);
    final a = _a(c);
    final fieldWidth = widget.theme?.fieldWidth ?? 52.0;

    final formatters = <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(3),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ColorTextField(
          value: r.toString(),
          label: 'R',
          theme: widget.theme,
          revisionKey: _revertCount,
          fieldWidth: fieldWidth,
          inputFormatters: formatters,
          onSubmitted: (text) => _submit(
            text,
            _r,
            (v) =>
                Color.from(alpha: c.a, red: v / 255.0, green: c.g, blue: c.b),
          ),
        ),
        const SizedBox(width: 4),
        ColorTextField(
          value: g.toString(),
          label: 'G',
          theme: widget.theme,
          revisionKey: _revertCount,
          fieldWidth: fieldWidth,
          inputFormatters: formatters,
          onSubmitted: (text) => _submit(
            text,
            _g,
            (v) =>
                Color.from(alpha: c.a, red: c.r, green: v / 255.0, blue: c.b),
          ),
        ),
        const SizedBox(width: 4),
        ColorTextField(
          value: b.toString(),
          label: 'B',
          theme: widget.theme,
          revisionKey: _revertCount,
          fieldWidth: fieldWidth,
          inputFormatters: formatters,
          onSubmitted: (text) => _submit(
            text,
            _b,
            (v) =>
                Color.from(alpha: c.a, red: c.r, green: c.g, blue: v / 255.0),
          ),
        ),
        if (widget.showAlpha) ...[
          const SizedBox(width: 4),
          ColorTextField(
            value: a.toString(),
            label: 'A',
            theme: widget.theme,
            revisionKey: _revertCount,
            fieldWidth: fieldWidth,
            inputFormatters: formatters,
            onSubmitted: (text) => _submit(
              text,
              _a,
              (v) =>
                  Color.from(alpha: v / 255.0, red: c.r, green: c.g, blue: c.b),
            ),
          ),
        ],
      ],
    );
  }
}
