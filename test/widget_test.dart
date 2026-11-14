import 'package:flutter_test/flutter_test.dart';

import 'package:accelerometer_practice/main.dart';

void main() {
  testWidgets('shows the accelerometer controls', (WidgetTester tester) async {
    await tester.pumpWidget(const AccelerometerApp());

    expect(find.text('Start accelerometer'), findsOneWidget);
    expect(find.text('Stop accelerometer'), findsOneWidget);
    expect(find.text('X'), findsOneWidget);
    expect(find.text('Y'), findsOneWidget);
    expect(find.text('Z'), findsOneWidget);
  });
}
