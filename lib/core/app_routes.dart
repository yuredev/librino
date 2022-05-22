import 'package:flutter/material.dart';
import 'package:librino/presentation/screens/home_screen.dart';
import 'package:librino/presentation/screens/login_screen.dart';

class AppRoutes {
  static const home = '/';
  static const login = '/login';

  static Map<String, Widget Function(BuildContext)> get all => {
        AppRoutes.home: ((context) => HomeScreen()),
        AppRoutes.login: ((context) => LoginScreen()),
      };
}
