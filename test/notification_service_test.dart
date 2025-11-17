import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:titanpark/services/notification_service.dart';

void main() {
  testWidgets(
    'NotificationService.showSuccess displays a SnackBar with title and message',
    (WidgetTester tester) async {
      // Build a minimal app with a button that triggers the notification.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      NotificationService.showSuccess(
                        context,
                        title: 'Reservation confirmed',
                        message: 'You selected Eastside Parking.',
                      );
                    },
                    child: const Text('Show notification'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Tap the button to trigger NotificationService.showSuccess.
      await tester.tap(find.text('Show notification'));
      await tester.pump(); // start SnackBar animation

      // Verify that the SnackBar with the expected title and message appears.
      expect(find.text('Reservation confirmed'), findsOneWidget);
      expect(find.text('You selected Eastside Parking.'), findsOneWidget);
    },
  );
}
