import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:titanpark/auth/auth_gate.dart';
import 'package:titanpark/screens/login_screen.dart';
import 'package:titanpark/screens/home_screen.dart';

void main() {
  testWidgets('smoke: AuthGate renders Login when signed out', (tester) async {
    final mockAuth = MockFirebaseAuth(signedIn: false);

    await tester.pumpWidget(MaterialApp(home: AuthGate(auth: mockAuth)));
    await tester.pump(); // settle stream/microtasks

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
  });

  testWidgets('smoke: AuthGate renders Home when signed in', (tester) async {
    final user = MockUser(uid: 'u1', email: 't@t.com');
    final mockAuth = MockFirebaseAuth(mockUser: user, signedIn: true);

    await tester.pumpWidget(MaterialApp(home: AuthGate(auth: mockAuth)));
    await tester.pump();

    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
