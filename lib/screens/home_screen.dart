import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import 'profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final AuthService? authService; // keep optional reference to AuthService
  const HomeScreen({super.key, this.authService});

  @override
  Widget build(BuildContext context) {
    final auth = authService ?? AuthService(); // fallback instance if null

    return Scaffold(
      appBar: AppBar(
        title: const Text('TitanPark'),
        actions: [
          // Profile icon → navigates to ProfileScreen
          IconButton(
            tooltip: 'Profile',
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          // Sign out icon
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signed out')),
                );
                Navigator.of(context).maybePop();
              }
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              'Welcome to TitanPark!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Find, list, or manage your parking spots easily.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                // Placeholder action for navigating to marketplace
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feature coming soon!')),
                );
              },
              icon: const Icon(Icons.local_parking),
              label: const Text('List a Spot'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                // Placeholder action for navigating to buy spot screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feature coming soon!')),
                );
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Buy a Spot'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
