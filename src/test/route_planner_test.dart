import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/observerState.dart';
import 'package:flutter_app/routePlanner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/main.dart';
import 'package:mockito/mockito.dart';

void main() {
  group("Input and JSON Validation", () {
    testWidgets('Location Input: JSON Response', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp());

      // Tap the New Route Plan button.
      await tester.tap(find.widgetWithText(TextButton, "New Route Plan"));
      await tester.pumpAndSettle();

      // Fill-out the location form.
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key("StartingLocationInput")), "Nottingham");
      await tester.enterText(find.byKey(Key("DestinationInput")), "Birmingham");
      await tester.tap(find.byKey(Key("LocationInputButton")));
      await tester.pumpAndSettle();

      RoutePlannerFormState state = tester.state(find.byType(RoutePlannerForm));

      // Check if input boxes for the map are hidden.
      await tester.tap(find.byKey(Key("RouteOption1")));
      await tester.pumpAndSettle();

      //TODO if JSON response returned results (Need to implement "m_directions" in routePlanner)
      //expect(state.m_directions.isNotNull(), true);

    });

    testWidgets('Location Input: Valid', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp());

      // Tap the New Route Plan button.
      await tester.tap(find.widgetWithText(TextButton, "New Route Plan"));
      await tester.pumpAndSettle();

      // Fill-out the location form.
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key("StartingLocationInput")), "Nottingham");
      await tester.enterText(find.byKey(Key("DestinationInput")), "Birmingham");
      await tester.tap(find.byKey(Key("LocationInputButton")));
      await tester.pumpAndSettle();

      // Check if input boxes for the map are hidden.
      RoutePlannerFormState state = tester.state(find.byType(RoutePlannerForm));
      expect(state.m_mapVisible, false);
    });

    testWidgets('Location Input: Invalid', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp());

      // Tap the New Route Plan button.
      await tester.tap(find.widgetWithText(TextButton, "New Route Plan"));
      await tester.pumpAndSettle();

      // Fill-out the location form.
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key("StartingLocationInput")), "");
      await tester.enterText(find.byKey(Key("DestinationInput")), "Birmingham");
      await tester.tap(find.byKey(Key("LocationInputButton")));
      await tester.pumpAndSettle();

      // Check if the input box remains after submitting with wrong an empty input.
      RoutePlannerFormState state = tester.state(find.byType(RoutePlannerForm));
      expect(state.m_mapVisible, true);
    });
  });

  group("Travel Option Tests", () {
    testWidgets('Select Travel Option', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MyApp());

      RoutePlannerFormState state = tester.state(find.byType(RoutePlannerForm));
      expect(state.m_mapVisible, true);

      //TODO Check default option when entering RoutePlanner page. (Need to implement "transportMethod" in routePlanner)
      //expect(state.m_travelModeRadio.createState().selectedIndex, 0);

      //TODO Tap and select the Taxi and Train Buttons. (Need to implement "transportMethod" routePlanner)
      await tester.tap(find.byKey(Key("TaxiButton")));
      await tester.pumpAndSettle();
      //expect(state.m_transportMethod, "Taxi");
      await tester.tap(find.byKey(Key("TrainButton")));
      await tester.pumpAndSettle();
      //expect(state.m_transportMethod, "Train");
    });

  });
}
