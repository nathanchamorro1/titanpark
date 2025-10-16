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

      // Logout (top-right)
      SafeArea(
        child: Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Sign out',
            onPressed: () => auth.signOut(),
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
            color: const Color(0xFFFF7900), // Titan Orange (https://brand.fullerton.edu/colors/)
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
                        )
                      );
                    }),
                    const SizedBox(height: 16),
                    _actionButton('SELL A SPOT', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReservationScreen(),
                        )
                      );
                    }),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ParkingAvailabilityScreen(),
                          )
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

  Widget _actionButton(String text, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8), // space between buttons
    child: SizedBox(
      width: 260,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00244E), // Titan Blue (https://brand.fullerton.edu/colors/)
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20), // taller buttons so they're more clickable
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 3, // slight shadow
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