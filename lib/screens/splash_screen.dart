import 'package:flutter/material.dart';
import 'package:pikc_app/screens/login_screen.dart';
import 'package:pikc_app/utils/assets_constants.dart';
import 'package:pikc_app/utils/theme_constants.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash-screen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, LoginScreen.routeName),
          child: Image.asset(
            pikcLogoImage,
            scale: 3,
          ),
        ),
      ),
    );
  }
}
