import 'package:flutter/material.dart';

/// Theme data for styling color input fields (HEX, RGB, HSL).
///
/// All properties are optional — when `null`, sensible defaults are used.
/// Use [effectiveTextStyle], [effectiveLabelStyle], and [effectiveDecoration]
/// to get resolved values with defaults applied.
class ColorPickerInputThemeData {
  const ColorPickerInputThemeData({
    this.textStyle,
    this.labelStyle,
    this.decoration,
    this.cursorColor,
    this.labelSpacing = 2.0,
    this.fieldWidth,
  });

  /// Text style for input field text.
  ///
  /// Default: fontSize 14, monospace font family.
  final TextStyle? textStyle;

  /// Text style for field labels ('#', 'R', 'G', 'H', etc.).
  ///
  /// Default: fontSize 14, fontWeight w500, color 0xFF666666.
  final TextStyle? labelStyle;

  /// Input decoration for text fields.
  ///
  /// Default: isDense, OutlineInputBorder, horizontal/vertical padding 8.
  final InputDecoration? decoration;

  /// Cursor color for text fields.
  final Color? cursorColor;

  /// Spacing between the label and the text field.
  ///
  /// Default: 2.0.
  final double labelSpacing;

  /// Width of individual input fields.
  ///
  /// When `null`, HEX fields default to 100 (120 with alpha),
  /// and RGB/HSL fields default to 52.
  final double? fieldWidth;

  /// Default text style for input fields.
  static const TextStyle defaultTextStyle = TextStyle(
    fontSize: 14,
    fontFamily: 'monospace',
  );

  /// Default label style.
  static const TextStyle defaultLabelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF666666),
  );

  /// Default input decoration.
  static const InputDecoration defaultDecoration = InputDecoration(
    isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    border: OutlineInputBorder(),
  );

  /// Returns [textStyle] if provided, otherwise [defaultTextStyle].
  TextStyle get effectiveTextStyle => textStyle ?? defaultTextStyle;

  /// Returns [labelStyle] if provided, otherwise [defaultLabelStyle].
  TextStyle get effectiveLabelStyle => labelStyle ?? defaultLabelStyle;

  /// Returns [decoration] if provided, otherwise [defaultDecoration].
  InputDecoration get effectiveDecoration => decoration ?? defaultDecoration;
}
