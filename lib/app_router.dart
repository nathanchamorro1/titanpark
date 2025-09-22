import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/vehicles_screen.dart';
import 'screens/marketplace_screen.dart';
import 'screens/reservation_screen.dart';
import 'screens/wallet_screen.dart';

class AppRouter {
  static const home = '/';
  static const vehicles = '/vehicles';
  static const marketplace = '/marketplace';
  static const reservation = '/reservation';
  static const wallet = '/wallet';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _fade(const HomeScreen());
      case vehicles:
        return _fade(const VehiclesScreen());
      case marketplace:
        return _fade(const MarketplaceScreen());
      case reservation:
        return _fade(const ReservationScreen());
      case wallet:
        return _fade(const WalletScreen());
      default:
        return _fade(const HomeScreen());
    }
  }

  static PageRoute _fade(Widget child) =>
      PageRouteBuilder(pageBuilder: (_, __, ___) => child);
}
