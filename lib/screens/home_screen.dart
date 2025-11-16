import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import 'package:titanpark/screens/marketplace_screen.dart';
import 'package:titanpark/screens/reservation_screen.dart';
import './parking_availability_screen.dart';
import './vehicles_screen.dart';
import '../app_router.dart';

class HomeScreen extends StatelessWidget {
  final AuthService? authService;
  const HomeScreen({super.key, this.authService});

  @override
  Widget build(BuildContext context) {
    final auth = authService ?? AuthService();

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.38,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/titanpark_bg.jpg',
                  fit: BoxFit.cover,
                ),
                Container(color: Colors.black.withValues(alpha: 0.4)),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, right: 8.0, left: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.person, color: Colors.white),
                            tooltip: 'Profile',
                            onPressed: () => Navigator.of(context)
                                .pushNamed(AppRouter.profile),
                          ),
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
          Container(
            height: 6,
            color: const Color(0xFFFF7900),
          ),
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
                    const SizedBox(height: 16),
                    _actionButton('MY VEHICLES', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VehiclesScreen(),
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

  Widget _actionButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: 260,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00244E),
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
