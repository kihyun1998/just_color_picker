import 'package:flutter/material.dart';

import '../models/color_format.dart';
import '../models/color_picker_input_theme.dart';

/// Displays color information in various formats (HEX, RGB, HSL).
class ColorInfoPanel extends StatelessWidget {
  const ColorInfoPanel({
    super.key,
    required this.color,
    this.showAlpha = false,
    this.showHsl = false,
    this.theme,
  });

  final Color color;
  final bool showAlpha;

  /// Whether to show HSL format in addition to HEX and RGB.
  final bool showHsl;

  /// Optional theme for styling labels and values.
  final ColorPickerInputThemeData? theme;

  @override
  Widget build(BuildContext context) {
    final formats = <ColorFormat>[
      HexColorFormat(includeAlpha: showAlpha),
      RgbColorFormat(includeAlpha: showAlpha),
      if (showHsl) HslColorFormat(includeAlpha: showAlpha),
    ];

    final labelStyle =
        theme?.effectiveLabelStyle ??
        const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF888888),
        );
    final valueStyle =
        theme?.effectiveTextStyle ??
        const TextStyle(
          fontSize: 12,
          fontFamily: 'monospace',
          color: Color(0xFF333333),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final format in formats)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 40,
                  child: Text(format.label, style: labelStyle),
                ),
                Text(format.format(color), style: valueStyle),
              ],
            ),
          ),
      ],
    );
  }
}
