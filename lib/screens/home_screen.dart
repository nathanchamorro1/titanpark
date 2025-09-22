import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final AuthService? authService;
  const HomeScreen({super.key, this.authService});

  @override
  Widget build(BuildContext context) {
    final auth = authService ?? AuthService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('TitanPark Home'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => auth.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(child: Text('You are signed in!')),
    );
  }
}
