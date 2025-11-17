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
        const jsonRes = '''
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
            "perc_full": 90.61,
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

        return http.Response(jsonRes, 200);
      });

      await tester.pumpWidget(
        createTestWidget(ParkingAvailabilityScreen(httpClient: mockClient)),
      );
      await tester.pumpAndSettle();

      // Test that percentage under 50% is green
      final containerGreen = tester
          .widget<Container>(find.byKey(const Key('parking_indicator')).at(0));
      final decorationGreen = containerGreen.decoration as BoxDecoration;
      final borderGreen = decorationGreen.border as Border;
      expect(borderGreen.top.color, Colors.green);

      // Test that percentage between 50% and 75% is orange
      final containerOrange = tester
          .widget<Container>(find.byKey(const Key('parking_indicator')).at(1));
      final decorationOrange = containerOrange.decoration as BoxDecoration;
      final borderOrange = decorationOrange.border as Border;
      expect(borderOrange.top.color, Colors.orange);

      // Test that percentage over 75% is red
      final containerRed = tester
          .widget<Container>(find.byKey(const Key('parking_indicator')).at(2));
      final decorationRed = containerRed.decoration as BoxDecoration;
      final borderRed = decorationRed.border as Border;
      expect(borderRed.top.color, Colors.red);
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

    testWidgets(
        'TC-SCRN-PA5: Test that the percentage shown for how full the parking structure is matches the percentage returned by the parking service API.',
        (tester) async {
      // Mock HTTP client
      final mockClient = MockClient((request) async {
        const jsonRes = '''
        {
          "Nutwood_Structure": {
            "available": 1445,
            "total": 2504,
            "perc_full": 42.29,
            "name": "Nutwood Structure",
            "price_in_cents": 150
          },
          "State_College_Structure": {
            "available": 670,
            "total": 1373,
            "perc_full": 51.2,
            "name": "State College Structure",
            "price_in_cents": 150
          },
          "Eastside_North": {
            "available": 188,
            "total": 1880,
            "perc_full": 90,
            "name": "Eastside North",
            "price_in_cents": 150
          },
          "Eastside_South": {
            "available": 779,
            "total": 1242,
            "perc_full": 37.28,
            "name": "Eastside South",
            "price_in_cents": 100
          }
        }
        ''';

        return http.Response(jsonRes, 200);
      });

      await tester.pumpWidget(
        createTestWidget(ParkingAvailabilityScreen(httpClient: mockClient)),
      );
      await tester.pumpAndSettle();

      // Test Nutwood Structure percentage
      final textNutwood =
          tester.widget<Text>(find.byKey(const Key('perc_full')).at(0));
      expect(textNutwood.data, "42.29% Full");

      // Test State College percentage
      final textStateCollege =
          tester.widget<Text>(find.byKey(const Key('perc_full')).at(1));
      expect(textStateCollege.data, "51.2% Full");

      // Test Eastside North percentage
      final textEastsideNorth =
          tester.widget<Text>(find.byKey(const Key('perc_full')).at(2));
      expect(textEastsideNorth.data, "90% Full");

      // Test Eastside South percentage
      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pumpAndSettle();
      expect(find.text("37.28% Full"), findsOneWidget);
    });
  });
}
