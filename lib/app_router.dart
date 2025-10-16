import 'package:flutter/material.dart';
import 'screens/profile/profile_screen.dart';


// Screens
import 'screens/home_screen.dart';
import 'screens/vehicles_screen.dart';
import 'screens/marketplace_screen.dart';
import 'screens/reservation_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/parking_availability_screen.dart';
import 'screens/profile/profile_screen.dart';

// Auth
import 'auth/auth_service.dart';

class AppRouter {
  AppRouter({required this.authService});
  final AuthService authService;

  // Route names
  static const home = '/';
  static const vehicles = '/vehicles';
  static const marketplace = '/marketplace';
  static const reservation = '/reservation';
  static const wallet = '/wallet';
  static const parkingAvailability = '/parking';
  static const profile = '/profile';

  // onGenerateRoute handler
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _fade(HomeScreen(authService: authService));
      case vehicles:
        return _fade(const VehiclesScreen());
      case marketplace:
        return _fade(const MarketplaceScreen());
      case reservation:
        return _fade(const ReservationScreen());
      case wallet:
        return _fade(const WalletScreen());
      case parkingAvailability:
        return _fade(const ParkingAvailabilityScreen());
      case profile:
        return _fade(const ProfileScreen());
      default:
        return _fade(HomeScreen(authService: authService));
    }
  }

  // Page transition helper
  static PageRoute _fade(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }
}
