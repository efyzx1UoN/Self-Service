// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  group("Navigation", () {
      testWidgets('New Route', (WidgetTester tester) async {
        // Build our app and trigger a frame.
        await tester.pumpWidget(MyApp());

        // Verify that we start on the Home page.
        expect(
            find.widgetWithText(AppBar, "Self Service: Home"), findsOneWidget);

        // Tap the New Route Plan button.
        await tester.tap(find.widgetWithText(TextButton, "New Route Plan"));
        await tester.pumpAndSettle();

        // Verify that we are now on the New Route Plan page.
        expect(find.widgetWithText(AppBar, "New Route Plan"), findsOneWidget);
      });
    });
}
