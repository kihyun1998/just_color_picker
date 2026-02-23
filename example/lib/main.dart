import 'package:flutter/material.dart';
import 'package:just_color_picker/just_color_picker.dart';

void main() {
  runApp(const PlaygroundApp());
}

class PlaygroundApp extends StatelessWidget {
  const PlaygroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JustColorPicker Playground',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PlaygroundPage(),
    );
  }
}

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  Color _selectedColor = Colors.blue;

  // Picker options.
  ColorPickerType _type = ColorPickerType.wheel;
  bool _showAlpha = true;
  bool _showHexInput = true;
  bool _showColorInfo = true;
  bool _showPreview = true;
  bool _showRgbInput = false;
  bool _showHslInput = false;
  double _wheelDiameter = 280;
  double _wheelWidth = 26;
  double _thumbRadius = 8;

  // Input theme preset.
  String _themePreset = 'default';

  ColorPickerInputThemeData? get _inputTheme {
    switch (_themePreset) {
      case 'rounded':
        return const ColorPickerInputThemeData(
          textStyle: TextStyle(fontSize: 13, fontFamily: 'monospace'),
          labelStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5C6BC0),
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xFFB0BEC5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xFF5C6BC0), width: 2),
            ),
          ),
          cursorColor: Color(0xFF5C6BC0),
          labelSpacing: 4,
        );
      case 'minimal':
        return const ColorPickerInputThemeData(
          textStyle: TextStyle(fontSize: 14, fontFamily: 'monospace'),
          labelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF9E9E9E),
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            border: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF424242), width: 2),
            ),
          ),
          cursorColor: Color(0xFF424242),
          labelSpacing: 2,
        );
      case 'bold':
        return const ColorPickerInputThemeData(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'monospace',
          ),
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFFE65100),
          ),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Color(0xFFFFF3E0),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide(color: Color(0xFFFFCC80), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide(color: Color(0xFFE65100), width: 2),
            ),
          ),
          cursorColor: Color(0xFFE65100),
          labelSpacing: 4,
          fieldWidth: 58,
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('JustColorPicker Playground'),
        backgroundColor: _selectedColor.withValues(alpha: 0.3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: isWide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: color picker.
                  Expanded(child: Center(child: _buildPicker())),
                  const SizedBox(width: 24),
                  // Right: control panel.
                  SizedBox(width: 320, child: _buildControls()),
                ],
              )
            : Column(
                children: [
                  Center(child: _buildPicker()),
                  const SizedBox(height: 24),
                  _buildControls(),
                ],
              ),
      ),
    );
  }

  Widget _buildPicker() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        JustColorPicker(
          key: ValueKey(_type),
          initialColor: _selectedColor,
          onColorChanged: (color) {
            setState(() => _selectedColor = color);
          },
          onColorChangeEnd: (color) {
            debugPrint('Color change ended: $color');
          },
          type: _type,
          wheelDiameter: _wheelDiameter,
          wheelWidth: _wheelWidth,
          showAlpha: _showAlpha,
          showHexInput: _showHexInput,
          showColorInfo: _showColorInfo,
          showPreview: _showPreview,
          showRgbInput: _showRgbInput,
          showHslInput: _showHslInput,
          thumbRadius: _thumbRadius,
          inputTheme: _inputTheme,
        ),
        const SizedBox(height: 24),
        // Color preview box.
        Container(
          width: _wheelDiameter,
          height: 60,
          decoration: BoxDecoration(
            color: _selectedColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          alignment: Alignment.center,
          child: Text(
            'Selected Color',
            style: TextStyle(
              color: _selectedColor.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Controls', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),

            // Type segmented button.
            Text('Type', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<ColorPickerType>(
              segments: const [
                ButtonSegment(
                  value: ColorPickerType.wheel,
                  label: Text('Wheel'),
                ),
                ButtonSegment(value: ColorPickerType.bar, label: Text('Bar')),
              ],
              selected: {_type},
              onSelectionChanged: (v) => setState(() => _type = v.first),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // Bool toggles.
            _buildSwitch('showAlpha', _showAlpha, (v) {
              setState(() => _showAlpha = v);
            }),
            _buildSwitch('showHexInput', _showHexInput, (v) {
              setState(() => _showHexInput = v);
            }),
            _buildSwitch('showColorInfo', _showColorInfo, (v) {
              setState(() => _showColorInfo = v);
            }),
            _buildSwitch('showPreview', _showPreview, (v) {
              setState(() => _showPreview = v);
            }),
            _buildSwitch('showRgbInput', _showRgbInput, (v) {
              setState(() => _showRgbInput = v);
            }),
            _buildSwitch('showHslInput', _showHslInput, (v) {
              setState(() => _showHslInput = v);
            }),

            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),

            // Input theme preset.
            Text('Input Theme', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'default', label: Text('Default')),
                ButtonSegment(value: 'rounded', label: Text('Rounded')),
                ButtonSegment(value: 'minimal', label: Text('Minimal')),
                ButtonSegment(value: 'bold', label: Text('Bold')),
              ],
              selected: {_themePreset},
              onSelectionChanged: (v) => setState(() => _themePreset = v.first),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // Numeric sliders.
            _buildSlider(
              'wheelDiameter',
              _wheelDiameter,
              150,
              400,
              (v) => setState(() => _wheelDiameter = v),
            ),
            _buildSlider(
              'wheelWidth',
              _wheelWidth,
              10,
              50,
              (v) => setState(() => _wheelWidth = v),
            ),
            _buildSlider(
              'thumbRadius',
              _thumbRadius,
              4,
              16,
              (v) => setState(() => _thumbRadius = v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.round()}'),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }
}
