import 'package:flutter/material.dart';
import 'package:just_color_picker/just_color_picker.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just Color Picker Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ColorPickerExample(),
    );
  }
}

class ColorPickerExample extends StatefulWidget {
  const ColorPickerExample({super.key});

  @override
  State<ColorPickerExample> createState() => _ColorPickerExampleState();
}

class _ColorPickerExampleState extends State<ColorPickerExample> {
  Color _selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Just Color Picker'),
        backgroundColor: _selectedColor.withValues(alpha: 0.3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              JustColorPicker(
                initialColor: _selectedColor,
                onColorChanged: (color) {
                  setState(() => _selectedColor = color);
                },
                onColorChangeEnd: (color) {
                  debugPrint('Color change ended: $color');
                },
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                height: 80,
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
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
