import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import 'package:titanpark/screens/marketplace_screen.dart';
import 'package:titanpark/screens/reservation_screen.dart';
import './parking_availability_screen.dart';
import '../app_router.dart'; // ⟵ for AppRouter.profile route

class HomeScreen extends StatelessWidget {
  final AuthService? authService;
  const HomeScreen({super.key, this.authService});

  @override
  Widget build(BuildContext context) {
    final auth = authService ?? AuthService();

    return Scaffold(
      body: Column(
        children: [
          // HEADER SECTION
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.38,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background photo of Eastside Parking Structure
                Image.asset(
                  'assets/titanpark_bg.jpg',
                  fit: BoxFit.cover,
                ),

                // Dark overlay for readability / accessibility
                Container(color: Colors.black.withOpacity(0.4)),

                // Header icons (Profile + Logout)
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 👤 Profile — navigates to dedicated Profile page
                          IconButton(
                            icon: const Icon(Icons.person, color: Colors.white),
                            tooltip: 'Profile',
                            onPressed: () =>
                                Navigator.of(context).pushNamed(AppRouter.profile),
                          ),
                          // 🔒 Logout
                          IconButton(
                            icon: const Icon(Icons.logout, color: Colors.white),
                            tooltip: 'Sign out',
                            onPressed: () => auth.signOut(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Centered TitanPark logo
                Center(
                  child: Image.asset(
                    'assets/titanpark_logo.png',
                    width: 220,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          // ORANGE DIVIDER LINE
          Container(
            height: 6,
            color: const Color(0xFFFF7900), // Titan Orange
          ),

          // BUTTONS AND LINKS
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _actionButton('LIST A SPOT', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MarketplaceScreen(),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    _actionButton('SELL A SPOT', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReservationScreen(),
                        ),
                      );
                    }),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ParkingAvailabilityScreen(),
                          ),
                        );
                      },
                      child: const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'OR ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'view parking availability >',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- BUTTON HELPER ---
  Widget _actionButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: 260,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00244E), // Titan Blue
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 3,
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
