import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikc_app/screens/dashboard_screen.dart';
import 'package:pikc_app/screens/login_screen/login_screen.dart';
import 'package:pikc_app/utils/assets_constants.dart';
import 'package:pikc_app/utils/theme_constants.dart';

import '../blocs/app_init/app_init_bloc.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash-screen';
  const SplashScreen({Key? key}) : super(key: key);
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => SplashScreen(),
    );
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AppInitBloc, AppInitState>(
      listenWhen: (prevState, state) => prevState.status != state.status,
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          Navigator.of(context).pushNamed(LoginScreen.routeName);
        } else if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).pushNamed(DashboardScreen.routeName);
        }
      },
      child: Scaffold(
        backgroundColor: kScaffoldBackgroundColor,
        body: Center(
          child: Image.asset(
            pikcLogoImage,
            scale: 3,
          ),
        ),
      ),
    );
  }
}
