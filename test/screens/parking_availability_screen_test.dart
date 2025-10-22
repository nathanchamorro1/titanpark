import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:titanpark/screens/parking_availability_screen.dart';
import 'package:http/http.dart' as http;

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

    testWidgets(
        'TC-SCRN-PA3: Test that the _getAvailabilityColor function returns the expected color for each level of traffic congestion in the parking structures.',
        (tester) async {
      // Mock HTTP client
      final mockClient = MockClient((request) async {
        const json_res = '''
        {
          "Nutwood_Structure": {
            "available": 1449,
            "total": 2504,
            "perc_full": 42.13,
            "name": "Nutwood Structure",
            "price_in_cents": 150
          },
          "State_College_Structure": {
            "available": 595,
            "total": 1373,
            "perc_full": 56.66,
            "name": "State College Structure",
            "price_in_cents": 150
          },
          "Eastside_North": {
            "available": 797,
            "total": 1880,
            "perc_full": 57.61,
            "name": "Eastside North",
            "price_in_cents": 150
          },
          "Eastside_South": {
            "available": 993,
            "total": 1242,
            "perc_full": 80,
            "name": "Eastside South",
            "price_in_cents": 250
          }
        }
        ''';

        return http.Response(json_res, 200);
      });

      await tester.pumpWidget(
        createTestWidget(ParkingAvailabilityScreen(httpClient: mockClient)),
      );
      await tester.pumpAndSettle();

      throw UnimplementedError();
    });

    testWidgets(
        'TC-SCRN-PA4: Test that the Parking Availability screen displays an error page when the Listings API server returns an unsuccessful response.',
        (tester) async {
      // Mock the HTTP Client to fail
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      await tester.pumpWidget(
        createTestWidget(ParkingAvailabilityScreen(httpClient: mockClient)),
      );

      await tester.pumpAndSettle();

      // Test that error icon is present
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      // That that error message is present
      expect(find.text('There was an error loading parking structure data'),
          findsOneWidget);
      // Check that retry button is present
      expect(
          find.descendant(
              of: find.byType(ElevatedButton), matching: find.text('Retry')),
          findsOne);
    });
  });
}
