import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/color_picker_input_theme.dart';

/// A reusable labeled text field for color input.
///
/// Provides bidirectional sync between external [value] updates and
/// user editing. Uses [revisionKey] to force-revert invalid input.
///
/// Layout: `[Label] [SizedBox(spacing)] [TextField]`
class ColorTextField extends StatefulWidget {
  const ColorTextField({
    super.key,
    required this.value,
    required this.label,
    required this.onSubmitted,
    this.inputFormatters,
    this.theme,
    this.revisionKey = 0,
    this.fieldWidth,
  });

  /// Current text value, controlled by the parent.
  final String value;

  /// Label displayed before the field (e.g. '#', 'R', 'H').
  final String label;

  /// Called when the user submits input (press Enter or lose focus).
  final ValueChanged<String> onSubmitted;

  /// Optional input formatters for restricting input.
  final List<TextInputFormatter>? inputFormatters;

  /// Optional theme for styling.
  final ColorPickerInputThemeData? theme;

  /// Increment this to force-revert the text field to [value].
  ///
  /// Used by the parent to revert invalid input.
  final int revisionKey;

  /// Width of the text field. If null, the field expands to fill.
  final double? fieldWidth;

  @override
  State<ColorTextField> createState() => _ColorTextFieldState();
}

class _ColorTextFieldState extends State<ColorTextField> {
  late final TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(ColorTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Force revert on revisionKey change.
    if (widget.revisionKey != oldWidget.revisionKey) {
      _isEditing = false;
      _controller.text = widget.value;
      return;
    }

    // Sync external value changes while not editing.
    if (!_isEditing && widget.value != oldWidget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSubmitted(String text) {
    _isEditing = false;
    widget.onSubmitted(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final textStyle =
        theme?.effectiveTextStyle ?? ColorPickerInputThemeData.defaultTextStyle;
    final labelStyle =
        theme?.effectiveLabelStyle ??
        ColorPickerInputThemeData.defaultLabelStyle;
    final decoration =
        theme?.effectiveDecoration ??
        ColorPickerInputThemeData.defaultDecoration;
    final spacing = theme?.labelSpacing ?? 2.0;

    final field = TextField(
      controller: _controller,
      style: textStyle,
      decoration: decoration,
      cursorColor: theme?.cursorColor,
      inputFormatters: widget.inputFormatters,
      onTap: () => _isEditing = true,
      onSubmitted: _onSubmitted,
      onEditingComplete: () => _onSubmitted(_controller.text),
    );

    final wrappedField = widget.fieldWidth != null
        ? SizedBox(width: widget.fieldWidth, child: field)
        : Expanded(child: field);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.label, style: labelStyle),
        SizedBox(width: spacing),
        wrappedField,
      ],
    );
  }
}
