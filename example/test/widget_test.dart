import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('Example app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const PlaygroundApp());
    expect(find.text('JustColorPicker Playground'), findsOneWidget);
  });
}
