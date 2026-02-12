import 'package:flutter/material.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/home_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const LoginScreen(),
    '/home': (context) => const HomeScreen(),

  };
}
