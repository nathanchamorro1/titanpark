// Simple widget test decoupled from Firebase/Auth.
// We pump MyHomePage directly so the test doesn't require
// Firebase initialization or the AuthGate widget.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:titanpark/main.dart';

void main() {
  testWidgets('MyHomePage counter increments', (tester) async {
    // Pump the counter page inside a MaterialApp scaffold.
    await tester.pumpWidget(
      const MaterialApp(
        home: MyHomePage(title: 'Test Counter'),
      ),
    );

    // Starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the FAB and rebuild a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Counter increments to 1.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
