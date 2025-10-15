import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import './add_vehicle_screen.dart';
import './vehicles_screen.dart';

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
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VehiclesScreen(),
                ),
              );
            },
            label: const Text('My vehicles'),
          ),
        ],
      )),
    );
  }
}
