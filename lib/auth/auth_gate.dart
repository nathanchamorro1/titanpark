import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import 'auth_service.dart';

class AuthGate extends StatelessWidget {
  final FirebaseAuth _auth;
  final AuthService? authService;

  AuthGate({super.key, FirebaseAuth? auth, this.authService})
      : _auth = auth ?? FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final service = authService ?? AuthService(auth: _auth);
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return HomeScreen(authService: service);
        }
        return LoginScreen(authService: service);
      },
    );
  }
}
