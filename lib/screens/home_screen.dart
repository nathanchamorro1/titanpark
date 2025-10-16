import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../app_router.dart';

class HomeScreen extends StatelessWidget {
  final AuthService? authService;

  const HomeScreen({super.key, this.authService});

  @override
  Widget build(BuildContext context) {
    final auth = authService ?? AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TitanPark'),
        actions: [
          // ✅ Profile button (new)
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to TitanPark!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Find, list, or manage your parking spots easily.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/parking-availability');
              },
              icon: const Icon(Icons.local_parking),
              label: const Text('Parking Availability'),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/marketplace');
              },
              icon: const Icon(Icons.storefront),
              label: const Text('Marketplace'),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/reservation');
              },
              icon: const Icon(Icons.event_available),
              label: const Text('Reservations'),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/vehicles');
              },
              icon: const Icon(Icons.directions_car),
              label: const Text('My Vehicles'),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/wallet');
              },
              icon: const Icon(Icons.account_balance_wallet),
              label: const Text('Wallet'),
            ),
          ],
        ),
      ),
    );
  }
}
