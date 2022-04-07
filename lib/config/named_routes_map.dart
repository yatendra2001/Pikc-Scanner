import 'package:flutter/material.dart';

import '../screens/screens.dart';

final Map<String, Widget Function(BuildContext)> appNamedRoutesMap = {
  '/': (_) => SplashScreen(),
  LoginScreen.routeName: (_) => LoginScreen(),
  DashboardScreen.routeName: (_) => DashboardScreen(),
  ResultScreen.routeName: (_) => ResultScreen(),
};
