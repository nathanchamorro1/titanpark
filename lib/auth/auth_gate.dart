import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class AuthGate extends StatelessWidget {
  final FirebaseAuth _auth;
  final AuthService? authService;

  // NOTE: not const — because we use FirebaseAuth.instance (non-const)
  AuthGate({Key? key, FirebaseAuth? auth, this.authService})
      : _auth = auth ?? FirebaseAuth.instance,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = authService ?? AuthService(auth: _auth);

    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          // Signed in → go to landing screen. (No const because we pass a value)
          return HomeScreen(authService: service);
        }

        // Not signed in → show login
        return LoginScreen(authService: service);
      },
    );
  }
}
