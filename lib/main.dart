import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pikc_app/blocs/app_init/app_init_bloc.dart';
import 'package:pikc_app/blocs/ocr/ocr_bloc.dart';
import 'package:pikc_app/config/named_routes_map.dart';
import 'package:pikc_app/config/route_generator.dart';
import 'package:pikc_app/repositories/auth/auth_repository.dart';
import 'package:pikc_app/repositories/ocr/ocr_repository.dart';
import 'package:pikc_app/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:pikc_app/screens/screens.dart';
import 'package:sizer/sizer.dart';

import 'screens/login_screen/cubit/login_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AuthRepository>(create: (_) => AuthRepository()),
            RepositoryProvider<OcrRepository>(create: (_) => OcrRepository()),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<AppInitBloc>(
                create: (context) =>
                    AppInitBloc(authRepository: context.read<AuthRepository>()),
              ),
              BlocProvider<OcrBloc>(
                create: (context) => OcrBloc(
                  ocrRepository: context.read<OcrRepository>(),
                ),
              ),
              BlocProvider<LoginCubit>(
                create: (context) =>
                    LoginCubit(authRepository: context.read<AuthRepository>()),
              ),
              BlocProvider<BottomNavBarCubit>(
                create: (context) => BottomNavBarCubit(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Pikc App',
              theme: ThemeData(
                primarySwatch: Colors.grey,
                fontFamily: GoogleFonts.montserrat().fontFamily,
              ),
              // routes: appNamedRoutesMap,
              initialRoute: SplashScreen.routeName,
              onGenerateRoute: RouteGenerator.generateRoute,
            ),
          ),
        );
      },
    );
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    print(event);
    super.onEvent(bloc, event!);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  Future<void> onError(
      BlocBase bloc, Object error, StackTrace stackTrace) async {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}
