import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/color_picker_input_theme.dart';
import '../utils/color_conversions.dart';
import 'color_text_field.dart';

/// A text field for entering a HEX color code.
///
/// Supports bidirectional sync: external color changes update the field,
/// and user input updates the color.
class HexInput extends StatefulWidget {
  const HexInput({
    super.key,
    required this.color,
    required this.onColorChanged,
    this.showAlpha = false,
    this.theme,
  });

  /// Current color to display.
  final Color color;

  /// Called when the user enters a valid HEX color.
  final ValueChanged<Color> onColorChanged;

  /// Whether to show alpha in the HEX string.
  final bool showAlpha;

  /// Optional theme for styling the input field.
  final ColorPickerInputThemeData? theme;

  @override
  State<HexInput> createState() => _HexInputState();
}

class _HexInputState extends State<HexInput> {
  int _revertCount = 0;

  void _onSubmitted(String text) {
    final color = hexToColor(text);
    if (color != null) {
      widget.onColorChanged(color);
    } else {
      // Force revert on invalid input.
      setState(() => _revertCount++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxLength = widget.showAlpha ? 8 : 6;
    final defaultWidth = widget.showAlpha ? 120.0 : 100.0;
    final width = widget.theme?.fieldWidth ?? defaultWidth;

    return SizedBox(
      width: width + 16, // account for label + spacing
      child: ColorTextField(
        value: colorToHex(widget.color, includeAlpha: widget.showAlpha),
        label: '#',
        theme: widget.theme,
        revisionKey: _revertCount,
        onSubmitted: _onSubmitted,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9a-fA-F]')),
          LengthLimitingTextInputFormatter(maxLength),
        ],
      ),
    );
  }
}
