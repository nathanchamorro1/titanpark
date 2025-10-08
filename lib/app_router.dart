// lib/app_router.dart
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/vehicles_screen.dart';
import 'screens/marketplace_screen.dart';
import 'screens/reservation_screen.dart';
import 'screens/wallet_screen.dart';

// adjust path if different
import 'auth/auth_service.dart';

class AppRouter {
  AppRouter({required this.authService});
  final AuthService authService;

  // route names
  static const home = '/';
  static const vehicles = '/vehicles';
  static const marketplace = '/marketplace';
  static const reservation = '/reservation';
  static const wallet = '/wallet';

  // instance onGenerateRoute
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
      default:
        return _fade(HomeScreen(authService: authService));
    }
  }

  static PageRoute _fade(Widget child) =>
      PageRouteBuilder(pageBuilder: (_, __, ___) => child);
}
