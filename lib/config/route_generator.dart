import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    return _errorRoute();
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
