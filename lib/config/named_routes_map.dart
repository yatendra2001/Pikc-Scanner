import 'package:flutter/material.dart';
import 'package:pikc_app/screens/dashboard_screen.dart';
import 'package:pikc_app/screens/login_screen.dart';
import 'package:pikc_app/screens/splash_screen.dart';

final Map<String, Widget Function(BuildContext)> appNamedRoutesMap = {
  '/': (_) => SplashScreen(),
  LoginScreen.routeName: (_) => LoginScreen(),
  DashboardScreen.routeName: (_) => DashboardScreen(),
};
