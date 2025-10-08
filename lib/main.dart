import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'auth/auth_gate.dart';
import 'theme/app_theme.dart';
import 'app_router.dart';
import 'auth/auth_service.dart'; // ✅ Add this import for auth service

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ Create the dependencies
  final authService = AuthService(); // or however your project initializes it
  final appRouter = AppRouter(authService: authService);

  // ✅ Remove const (router is not const)
  runApp(TitanParkApp(appRouter: appRouter));
}

/// The main app widget
class TitanParkApp extends StatelessWidget {
  const TitanParkApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TitanPark',
      theme: AppTheme.light,
      onGenerateRoute: appRouter.onGenerateRoute, // ✅ use instance router
      home: AuthGate(), // entry point (can stay as is)
      debugShowCheckedModeBanner: false,
    );
  }
}

/// ---- Compatibility shims for widget tests ----
/// Keeps `const MyApp()` working for widget_test.dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create minimal dependencies for test environment
    final authService = AuthService();
    final appRouter = AppRouter(authService: authService);
    return TitanParkApp(appRouter: appRouter);
  }
}

/// Keeps `const MyHomePage()` working for widget tests
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
