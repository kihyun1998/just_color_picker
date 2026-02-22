import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/color_conversions.dart';

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
  });

  /// Current color to display.
  final Color color;

  /// Called when the user enters a valid HEX color.
  final ValueChanged<Color> onColorChanged;

  /// Whether to show alpha in the HEX string.
  final bool showAlpha;

  @override
  State<HexInput> createState() => _HexInputState();
}

class _HexInputState extends State<HexInput> {
  late final TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: colorToHex(widget.color, includeAlpha: widget.showAlpha),
    );
  }

  @override
  void didUpdateWidget(HexInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update the text field if the color changed externally (not from user input).
    if (!_isEditing && widget.color != oldWidget.color) {
      final hex = colorToHex(widget.color, includeAlpha: widget.showAlpha);
      _controller.text = hex;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSubmitted(String text) {
    _isEditing = false;
    final color = hexToColor(text);
    if (color != null) {
      widget.onColorChanged(color);
    } else {
      // Revert to current color on invalid input.
      _controller.text = colorToHex(
        widget.color,
        includeAlpha: widget.showAlpha,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxLength = widget.showAlpha ? 8 : 6;
    return SizedBox(
      width: widget.showAlpha ? 120 : 100,
      child: Row(
        children: [
          const Text(
            '#',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                border: OutlineInputBorder(),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9a-fA-F]')),
                LengthLimitingTextInputFormatter(maxLength),
              ],
              onTap: () => _isEditing = true,
              onSubmitted: _onSubmitted,
              onEditingComplete: () => _onSubmitted(_controller.text),
            ),
          ),
        ],
      ),
    );
  }
}
