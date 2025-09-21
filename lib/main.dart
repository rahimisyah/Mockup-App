// lib/main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/products_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:ui' as ui;
import 'screens/address_screen.dart';
import 'package:provider/provider.dart';
import 'services/cart_service.dart';
import 'screens/cart_screen.dart';
import 'screens/announcement_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Needed for SharedPreferences
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrototypeApp',
      theme: ThemeData(primarySwatch: Colors.blue),
      locale: Locale('en','US'),
      supportedLocales: [Locale('en','US')],
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),     // Checks if user is logged in
        '/login': (context) => LoginScreen(),
        '/landing': (context) => LandingScreen(),
        '/products': (context) => ProductsScreen(),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => SettingsScreen(),
        '/address': (context) => AddressScreen(),
        '/cart': (context) => CartScreen(),
        '/announcement': (context) => AnnouncementScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // If token exists → go to landing, else → go to login
    if (token != null) {
      Navigator.pushReplacementNamed(context, '/landing');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}