// This is a basic Flutter widget test for the marathon split calculator.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:emily_marathon_split_calculator/main.dart';

void main() {
  testWidgets('Marathon split calculator smoke test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MarathonTimeEstimatorApp());

    // Verify that the app title is displayed.
    expect(find.text("emily's race split estimator"), findsOneWidget);

    // Verify that the race type dropdown is present.
    expect(find.text('Race Type'), findsOneWidget);

    // Verify that the pace input is present.
    expect(find.text('Pace'), findsOneWidget);

    // Verify that the start time button is present.
    expect(find.text('Start Time'), findsOneWidget);

    // Verify that the calculate button is present.
    expect(find.text('Calculate'), findsOneWidget);
  });

  testWidgets('Calculate splits functionality test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MarathonTimeEstimatorApp());

    // Tap the calculate button.
    await tester.tap(find.text('Calculate'));
    await tester.pump();

    // Verify that split times are calculated and displayed.
    // The first item should be the start time.
    expect(find.textContaining('Start:'), findsOneWidget);
  });
}
