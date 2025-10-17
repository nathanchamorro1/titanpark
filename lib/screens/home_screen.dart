import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import 'package:titanpark/screens/marketplace_screen.dart';
import 'package:titanpark/screens/reservation_screen.dart';
import './parking_availability_screen.dart';

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
                Container(color: Colors.black.withValues(alpha: 0.4)),

                // ✅ FIXED HEADER ICON ALIGNMENT
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 👤 Profile Icon (left of logout)
                          IconButton(
                            icon: const Icon(Icons.person, color: Colors.white),
                            tooltip: 'Profile',
                            onPressed: () => _showProfileMenu(context),
                          ),

                          // 🔒 Logout Icon (rightmost)
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

                // Centered logo overlaying the background
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

  // --- PROFILE MENU ---
  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildProfileButton(context, "Display Name"),
              _buildProfileButton(context, "Email"),
              _buildProfileButton(context, "Wallet"),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileButton(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00244E),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Feature coming soon!"),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        child: Text(title),
      ),
    );
  }
}
