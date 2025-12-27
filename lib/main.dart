import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';

import 'screens/login_page.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/home_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const LazaApp());
}

class LazaApp extends StatefulWidget {
  const LazaApp({super.key});

  static _LazaAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_LazaAppState>()!;

  @override
  State<LazaApp> createState() => _LazaAppState();
}

class _LazaAppState extends State<LazaApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laza',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
        ),
      ),
      routes: {
        '/welcome': (context) => SplashScreen(
          onLogin: () => Navigator.pushNamed(context, '/login'),
          onSignup: () => Navigator.pushNamed(context, '/signup'),
        ),
        '/home': (context) => const HomeWrapper(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupScreen(),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            return const HomeWrapper();
          }

          return SplashScreen(
            onLogin: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            ),
            onSignup: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SignupScreen()),
            ),
          );
        },
      ),
    );
  }
}
