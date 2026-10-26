import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_color_picker/just_color_picker.dart';

void main() {
  group('ColorState', () {
    test('creates from Color', () {
      final state = ColorState.fromColor(const Color(0xFFFF0000));
      expect(state.hue, closeTo(0.0, 0.5));
      expect(state.saturation, closeTo(1.0, 0.01));
      expect(state.value, closeTo(1.0, 0.01));
      expect(state.alpha, 1.0);
    });

    test('withHue returns new state with changed hue', () {
      final state = ColorState.fromColor(const Color(0xFFFF0000));
      final updated = state.withHue(120.0);
      expect(updated.hue, closeTo(120.0, 0.5));
      expect(updated.saturation, state.saturation);
      expect(updated.value, state.value);
    });

    test('withSV clamps values', () {
      final state = ColorState.fromColor(const Color(0xFFFF0000));
      final updated = state.withSV(-0.5, 1.5);
      expect(updated.saturation, 0.0);
      expect(updated.value, 1.0);
    });

    test('withAlpha clamps values', () {
      final state = ColorState.fromColor(const Color(0xFFFF0000));
      final updated = state.withAlpha(2.0);
      expect(updated.alpha, 1.0);
      final updated2 = state.withAlpha(-1.0);
      expect(updated2.alpha, 0.0);
    });

    test('toColor round-trips through HSV', () {
      const original = Color(0xFF3366CC);
      final state = ColorState.fromColor(original);
      final result = state.toColor();
      // Allow small rounding differences.
      expect((result.r * 255).round(), closeTo((original.r * 255).round(), 1));
      expect((result.g * 255).round(), closeTo((original.g * 255).round(), 1));
      expect((result.b * 255).round(), closeTo((original.b * 255).round(), 1));
    });

    test('equality', () {
      final a = ColorState.fromColor(const Color(0xFF00FF00));
      final b = ColorState.fromColor(const Color(0xFF00FF00));
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });
  });

  group('color_conversions', () {
    test('hexToColor parses 6-digit hex', () {
      final color = hexToColor('#FF5733');
      expect(color, isNotNull);
      expect((color!.r * 255).round(), 255);
      expect((color.g * 255).round(), 87);
      expect((color.b * 255).round(), 51);
    });

    test('hexToColor parses 3-digit hex', () {
      final color = hexToColor('#F00');
      expect(color, isNotNull);
      expect((color!.r * 255).round(), 255);
      expect((color.g * 255).round(), 0);
      expect((color.b * 255).round(), 0);
    });

    test('hexToColor parses 8-digit hex with alpha', () {
      final color = hexToColor('#80FF5733');
      expect(color, isNotNull);
      expect((color!.a * 255).round(), 128);
    });

    test('hexToColor returns null for invalid hex', () {
      expect(hexToColor('XYZ'), isNull);
      expect(hexToColor('#GG0000'), isNull);
      expect(hexToColor('#12345'), isNull);
    });

    test('colorToHex without alpha', () {
      expect(colorToHex(const Color(0xFFFF5733)), 'FF5733');
    });

    test('colorToHex with alpha', () {
      expect(
        colorToHex(const Color(0x80FF5733), includeAlpha: true),
        '80FF5733',
      );
    });

    test('isValidHex', () {
      expect(isValidHex('#FF0000'), isTrue);
      expect(isValidHex('ABC'), isTrue);
      expect(isValidHex('ZZZZZZ'), isFalse);
    });

    test('colorToRgb', () {
      final rgb = colorToRgb(const Color(0xFFFF5733));
      expect(rgb.r, 255);
      expect(rgb.g, 87);
      expect(rgb.b, 51);
      expect(rgb.a, 255);
    });

    test('colorToRgb with alpha', () {
      final rgb = colorToRgb(const Color(0x80FF5733));
      expect(rgb.r, 255);
      expect(rgb.g, 87);
      expect(rgb.b, 51);
      expect(rgb.a, 128);
    });

    test('rgbToColor', () {
      final color = rgbToColor(255, 87, 51);
      expect((color.r * 255).round(), 255);
      expect((color.g * 255).round(), 87);
      expect((color.b * 255).round(), 51);
      expect((color.a * 255).round(), 255);
    });

    test('rgbToColor with alpha', () {
      final color = rgbToColor(255, 87, 51, 128);
      expect((color.a * 255).round(), 128);
    });

    test('colorToHsl', () {
      final hsl = colorToHsl(const Color(0xFFFF0000));
      expect(hsl.h, closeTo(0, 0.5));
      expect(hsl.s, closeTo(100, 0.5));
      expect(hsl.l, closeTo(50, 0.5));
      expect(hsl.a, 255);
    });

    test('colorToHsl with alpha', () {
      final hsl = colorToHsl(const Color(0x80FF0000));
      expect(hsl.a, 128);
    });

    test('hslToColor round-trips through colorToHsl', () {
      const original = Color(0xFF3366CC);
      final hsl = colorToHsl(original);
      final result = hslToColor(hsl.h, hsl.s, hsl.l, hsl.a);
      expect((result.r * 255).round(), closeTo((original.r * 255).round(), 1));
      expect((result.g * 255).round(), closeTo((original.g * 255).round(), 1));
      expect((result.b * 255).round(), closeTo((original.b * 255).round(), 1));
    });
  });

  group('JustColorPicker widget', () {
    testWidgets('renders without error', (tester) async {
      Color? changedColor;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JustColorPicker(
              initialColor: const Color(0xFF0000FF),
              onColorChanged: (c) => changedColor = c,
            ),
          ),
        ),
      );

      // Should find the widget.
      expect(find.byType(JustColorPicker), findsOneWidget);
      // No callback should have fired yet.
      expect(changedColor, isNull);
    });

    testWidgets('renders with alpha disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JustColorPicker(
              initialColor: const Color(0xFF0000FF),
              onColorChanged: (_) {},
              showAlpha: false,
            ),
          ),
        ),
      );

      expect(find.byType(JustColorPicker), findsOneWidget);
    });

    testWidgets(
      'bar keeps the hue thumb at the right edge when dragged past it',
      (tester) async {
        final changed = <Color>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: JustColorPicker(
                  type: ColorPickerType.bar,
                  initialColor: const Color(0xFF00FFFF),
                  onColorChanged: changed.add,
                ),
              ),
            ),
          ),
        );

        final bar = find.byType(HueBar);
        final rect = tester.getRect(bar);
        await tester.dragFrom(rect.center, Offset(rect.width, 0));
        await tester.pump();

        expect(tester.widget<HueBar>(bar).hue, greaterThan(359.0));
        expect(changed.last, const Color(0xFFFF0000));
      },
    );
  });

  group('JustColorPicker controlled mode', () {
    // HSV(200, 0.8, 0.8).
    const blue = Color(0xFF2996CC);

    /// Pumps a bar picker whose parent echoes every emitted color back as
    /// `color`, and returns a setter for the parent's color.
    Future<void Function(Color)> pumpEchoing(WidgetTester tester) async {
      var color = blue;
      late StateSetter setParent;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  setParent = setState;
                  return JustColorPicker(
                    type: ColorPickerType.bar,
                    showAlpha: false,
                    color: color,
                    onColorChanged: (c) => setState(() => color = c),
                  );
                },
              ),
            ),
          ),
        ),
      );
      return (c) => setParent(() => color = c);
    }

    Future<void> dragSv(
      WidgetTester tester,
      (double, double) from,
      (double, double) to,
    ) async {
      final rect = tester.getRect(find.byType(SvPanel));
      Offset at((double, double) sv) => Offset(
        rect.left + sv.$1 * rect.width,
        rect.top + (1 - sv.$2) * rect.height,
      );
      await tester.dragFrom(at(from), at(to) - at(from));
      await tester.pump();
    }

    SvPanel svPanel(WidgetTester tester) =>
        tester.widget<SvPanel>(find.byType(SvPanel));

    testWidgets('keeps the hue when the echoed color passes through grey', (
      tester,
    ) async {
      await pumpEchoing(tester);

      await dragSv(tester, (0.8, 0.8), (-0.2, 0.8));
      expect(svPanel(tester).saturation, 0.0);
      expect(tester.widget<HueBar>(find.byType(HueBar)).hue, closeTo(200, 0.5));

      await dragSv(tester, (0.05, 0.8), (0.8, 0.8));
      expect(svPanel(tester).hue, closeTo(200, 0.5));
    });

    testWidgets('keeps hue and saturation when the echoed color is black', (
      tester,
    ) async {
      await pumpEchoing(tester);

      await dragSv(tester, (0.8, 0.8), (0.8, -0.2));
      final panel = svPanel(tester);
      expect(panel.value, 0.0);
      expect(panel.hue, closeTo(200, 0.5));
      expect(panel.saturation, closeTo(0.8, 0.01));
    });

    testWidgets('follows a color the parent sets that is not an echo', (
      tester,
    ) async {
      final setColor = await pumpEchoing(tester);

      setColor(const Color(0xFF00FF00));
      await tester.pump();

      final panel = svPanel(tester);
      expect(panel.hue, closeTo(120, 0.5));
      expect(panel.saturation, closeTo(1.0, 0.01));
      expect(panel.value, closeTo(1.0, 0.01));
    });

    testWidgets('follows a grey the parent sets that is not an echo', (
      tester,
    ) async {
      final setColor = await pumpEchoing(tester);

      setColor(const Color(0xFF808080));
      await tester.pump();

      final panel = svPanel(tester);
      expect(panel.saturation, 0.0);
      expect(panel.value, closeTo(0.5, 0.01));
    });
  });

  group('HueBar', () {
    Future<List<double>> dragAcross(WidgetTester tester, double dx) async {
      final emitted = <double>[];
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(
              width: 200,
              child: HueBar(hue: 180, thumbRadius: 8, onChanged: emitted.add),
            ),
          ),
        ),
      );
      final rect = tester.getRect(find.byType(HueBar));
      await tester.dragFrom(rect.center, Offset(dx, 0));
      return emitted;
    }

    testWidgets('emits a hue below 360 when dragged past the right edge', (
      tester,
    ) async {
      final emitted = await dragAcross(tester, 300);
      expect(emitted, everyElement(lessThan(360.0)));
      expect(emitted.last, greaterThan(359.0));
    });

    testWidgets('emits 0 when dragged past the left edge', (tester) async {
      final emitted = await dragAcross(tester, -300);
      expect(emitted.last, 0.0);
    });
  });
}
