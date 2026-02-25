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
  double _wheelDiameter = 280;
  double _wheelWidth = 26;
  double _thumbRadius = 8;

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
    final hex = colorToHex(_selectedColor);

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
          thumbRadius: _thumbRadius,
        ),
        const SizedBox(height: 24),
        // Color preview box — built by the app, not the library.
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
            hex,
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

            const SizedBox(height: 8),
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
