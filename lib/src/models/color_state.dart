import 'dart:ui' show Color;

import 'package:flutter/painting.dart' show HSVColor;

/// Immutable wrapper around [HSVColor] with convenience methods.
class ColorState {
  const ColorState._(this._hsv);

  final HSVColor _hsv;

  /// Creates a [ColorState] from an [HSVColor].
  factory ColorState.fromHSV(HSVColor hsv) => ColorState._(hsv);

  /// Creates a [ColorState] from a [Color].
  factory ColorState.fromColor(Color color) =>
      ColorState._(HSVColor.fromColor(color));

  /// Creates a [ColorState] from individual HSV + alpha components.
  factory ColorState.fromAHSV(
    double alpha,
    double hue,
    double saturation,
    double value,
  ) => ColorState._(HSVColor.fromAHSV(alpha, hue, saturation, value));

  /// The underlying [HSVColor].
  HSVColor get hsv => _hsv;

  /// Hue component (0–360).
  double get hue => _hsv.hue;

  /// Saturation component (0–1).
  double get saturation => _hsv.saturation;

  /// Value (brightness) component (0–1).
  double get value => _hsv.value;

  /// Alpha component (0–1).
  double get alpha => _hsv.alpha;

  /// Converts to a Flutter [Color].
  Color toColor() => _hsv.toColor();

  /// Returns a copy with the given [hue] (0–360).
  ColorState withHue(double hue) =>
      ColorState._(HSVColor.fromAHSV(alpha, hue % 360, saturation, value));

  /// Returns a copy with the given [saturation] and [value].
  ColorState withSV(double saturation, double value) => ColorState._(
    HSVColor.fromAHSV(
      alpha,
      hue,
      saturation.clamp(0.0, 1.0),
      value.clamp(0.0, 1.0),
    ),
  );

  /// Returns a copy with the given [alpha] (0–1).
  ColorState withAlpha(double alpha) => ColorState._(
    HSVColor.fromAHSV(alpha.clamp(0.0, 1.0), hue, saturation, value),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorState &&
          runtimeType == other.runtimeType &&
          _hsv == other._hsv;

  @override
  int get hashCode => _hsv.hashCode;

  @override
  String toString() =>
      'ColorState(h: ${hue.toStringAsFixed(1)}, s: ${saturation.toStringAsFixed(2)}, v: ${value.toStringAsFixed(2)}, a: ${alpha.toStringAsFixed(2)})';
}
