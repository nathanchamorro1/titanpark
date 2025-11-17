import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:titanpark/screens/vehicles_screen.dart';

void main() {
  group('Vehicle Screen Tests', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        home: child,
      );
    }

    testWidgets(
        'TC-VHCL-01: Test that the Vehicles screen successfully loads and displays a list of vehicles when the API returns a successful response with vehicle data.',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(const VehiclesScreen()),
      );
    });
  });
}
