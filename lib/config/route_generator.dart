import 'package:flutter/material.dart';
import 'package:pikc_app/screens/dashboard_screen.dart';
import 'package:pikc_app/screens/login_screen/login_screen.dart';
import 'package:pikc_app/screens/login_screen/otp_screen.dart';
import 'package:pikc_app/screens/login_screen/phone_screen.dart';
import 'package:pikc_app/screens/screens.dart';
import 'package:pikc_app/screens/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const Scaffold(),
        );
      case SplashScreen.routeName:
        return SplashScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case NavScreen.routeName:
        return NavScreen.route();
      case PhoneScreen.routeName:
        return PhoneScreen.route();
      case OtpScreen.routeName:
        return OtpScreen.route();
      case ResultScreen.routeName:
        return ResultScreen.route();
      case DashboardScreen.routeName:
        return DashboardScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text('Error'),
              ),
              body: Center(
                child: Text(
                  'Something Went Wrong!',
                  style: TextStyle(color: Colors.grey[600], fontSize: 24),
                ),
              ),
            ));
  }
}
