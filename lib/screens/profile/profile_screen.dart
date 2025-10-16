import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _featureComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feature coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _featureComingSoon(context),
              icon: const Icon(Icons.person_outline),
              label: const Text('Edit Display Name'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _featureComingSoon(context),
              icon: const Icon(Icons.email_outlined),
              label: const Text('Change Email'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _featureComingSoon(context),
              icon: const Icon(Icons.lock_outline),
              label: const Text('Change Password'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _featureComingSoon(context),
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
