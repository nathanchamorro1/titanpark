import 'package:flutter/material.dart';

import 'auth/auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/vehicles_screen.dart';
import 'screens/marketplace_screen.dart';
import 'screens/list_spot_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/profile_page.dart';

class AppRouter {
  AppRouter({required this.authService});
  final AuthService authService;

  // route names
  static const home = '/';
  static const vehicles = '/vehicles';
  static const marketplace = '/marketplace';
  static const reservation = '/reservation';
  static const wallet = '/wallet';
  static const profile = '/profile'; // ⟵ NEW

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
        return _fade(const ListSpotScreen());
      case wallet:
        return _fade(const WalletScreen());
      case profile: // ⟵ NEW
        return _fade(const ProfilePage());
      default:
        return _fade(HomeScreen(authService: authService));
    }
  }

  static PageRoute _fade(Widget child) =>
      PageRouteBuilder(pageBuilder: (_, __, ___) => child);
}
