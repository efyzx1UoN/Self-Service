import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/main.dart';
import 'package:mockito/mockito.dart';

void main() {
  group("Input Validation", () {
    testWidgets('Counter increments smoke test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp());


      // Tap the New Route Plan button.
      await tester.tap(find.widgetWithText(TextButton, "New Route Plan"));
      await tester.pumpAndSettle();

      // Tap the New Route Plan button.
      await tester.tap(find.byKey(Key("StartingLocationInput")));
      await tester.pumpAndSettle();
    });
  });
}
