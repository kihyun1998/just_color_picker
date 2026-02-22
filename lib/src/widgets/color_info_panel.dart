import 'package:flutter/material.dart';

import '../models/color_format.dart';

/// Displays color information in various formats (HEX, RGB, etc.).
class ColorInfoPanel extends StatelessWidget {
  const ColorInfoPanel({
    super.key,
    required this.color,
    this.showAlpha = false,
  });

  final Color color;
  final bool showAlpha;

  @override
  Widget build(BuildContext context) {
    final formats = <ColorFormat>[
      HexColorFormat(includeAlpha: showAlpha),
      RgbColorFormat(includeAlpha: showAlpha),
    ];

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
                  child: Text(
                    format.label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF888888),
                    ),
                  ),
                ),
                Text(
                  format.format(color),
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
