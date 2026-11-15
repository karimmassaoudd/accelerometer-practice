import 'package:flutter_test/flutter_test.dart';

import 'package:accelerometer_practice/main.dart';

void main() {
  testWidgets('shows the educational sensor interface', (WidgetTester tester) async {
    await tester.pumpWidget(const AccelerometerApp());

    expect(find.text('Phone movement sensor'), findsOneWidget);
    expect(find.text('Sensor stopped'), findsOneWidget);
    expect(find.text('Start sensor'), findsOneWidget);
    expect(find.text('X axis'), findsOneWidget);
    expect(find.text('Y axis'), findsOneWidget);
    expect(find.text('Z axis'), findsOneWidget);
    expect(find.text('Try it yourself'), findsOneWidget);
  });
}
