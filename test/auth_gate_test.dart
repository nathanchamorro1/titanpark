// This test file is used to test the AuthGate widget.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:titanpark/auth/auth_gate.dart';
import 'package:titanpark/auth/auth_service.dart';
import 'package:titanpark/screens/login_screen.dart';
import 'package:titanpark/screens/home_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('AuthGate shows LoginScreen when user is signed out', (
    tester,
  ) async {
    final mockAuth = MockFirebaseAuth(signedIn: false);
    final service = AuthService(auth: mockAuth);

    await tester.pumpWidget(
      MaterialApp(
        home: AuthGate(auth: mockAuth, authService: service),
      ),
    );

    await tester.pump();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);
  });

  testWidgets('AuthGate shows HomeScreen when user is signed in', (
    tester,
  ) async {
    final user = MockUser(
      isAnonymous: false,
      uid: 'uid-123',
      email: 'test@test.com',
      displayName: 'Test User',
    );

    final mockAuth = MockFirebaseAuth(mockUser: user, signedIn: true);
    final service = AuthService(auth: mockAuth);

    await tester.pumpWidget(
      MaterialApp(
        home: AuthGate(auth: mockAuth, authService: service),
      ),
    );

    await tester.pump();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });
}
