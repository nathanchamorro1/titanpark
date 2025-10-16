import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming later!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Profile',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Edit Display Name button
            ElevatedButton.icon(
              onPressed: () => _showComingSoon(context, 'Edit Display Name'),
              icon: const Icon(Icons.person_outline),
              label: const Text('Edit Display Name'),
            ),

            const SizedBox(height: 10),

            // Edit Email button
            ElevatedButton.icon(
              onPressed: () => _showComingSoon(context, 'Edit Email'),
              icon: const Icon(Icons.email_outlined),
              label: const Text('Edit Email'),
            ),

            const SizedBox(height: 10),

            // Edit Password button
            ElevatedButton.icon(
              onPressed: () => _showComingSoon(context, 'Edit Password'),
              icon: const Icon(Icons.lock_outline),
              label: const Text('Edit Password'),
            ),

            const SizedBox(height: 10),

            // Manage Vehicles button
            ElevatedButton.icon(
              onPressed: () => _showComingSoon(context, 'Manage Vehicles'),
              icon: const Icon(Icons.directions_car_outlined),
              label: const Text('Manage Vehicles'),
            ),

            const SizedBox(height: 10),

            // Add Payment Method button
            ElevatedButton.icon(
              onPressed: () => _showComingSoon(context, 'Add Payment Method'),
              icon: const Icon(Icons.account_balance_wallet_outlined),
              label: const Text('Add Payment Method'),
            ),
          ],
        ),
      ),
    );
  }
}
