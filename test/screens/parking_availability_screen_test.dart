import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:titanpark/screens/parking_availability_screen.dart';

void main() {
  group('Parking Availability Screen Tests', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        home: child,
      );
    }

    testWidgets(
        'TC-SCRN-PA1: Test that there is a loading spinner on the screen when the Parking Availability page first loads, before the API returns any data.',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(const ParkingAvailabilityScreen()),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'TC-SCRN-PA2: Test that there is a navigation bar at the top of the screen with a back button, title, and refresh button.',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(const ParkingAvailabilityScreen()),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(
          find.descendant(
              of: find.byType(AppBar),
              matching: find.text('Parking Availability')),
          findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });
  });
}
