import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/observerState.dart';
import 'package:flutter_app/train_booker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/main.dart';
import 'package:mockito/mockito.dart';

void main() {
  group("Train Booker Input Options", () {
    testWidgets('Test Toggle Return', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp());

      // Tap the New Route Plan button.
      await tester.tap(find.widgetWithText(TextButton, "New Train Plan"));
      await tester.pumpAndSettle();

      //TODO add train_booker page
      //RoutePlannerFormState state = tester.state(find.byType(TrainBookerForm));
      //expect(state.m_mapVisible, false);

      //TODO add the variable the return status is stored under
      //bool status = state.m_returnJourney;

      // Fill-out the location form.
      await tester.tap(find.byKey(Key("ToggleReturnButton")));
      await tester.pumpAndSettle();

      //TODO add train_booker page
      //RoutePlannerFormState state = tester.state(find.byType(TrainBookerForm));
      //expect(state.m_returnJourney, !status);

    });
});
}
