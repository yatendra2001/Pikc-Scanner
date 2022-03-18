import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikc_app/blocs/auth/auth_bloc.dart';
import 'package:pikc_app/blocs/ocr/ocr_bloc.dart';
import 'package:pikc_app/config/named_routes_map.dart';
import 'package:pikc_app/config/route_generator.dart';
import 'package:pikc_app/repositories/auth/app_auth_repository.dart';
import 'package:pikc_app/repositories/auth/auth_repository.dart';
import 'package:pikc_app/repositories/ocr/ocr_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => AppAuthRepository()),
        RepositoryProvider<OcrRepository>(create: (_) => OcrRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) =>
                AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<OcrBloc>(
            create: (context) => OcrBloc(
              ocrRepository: context.read<OcrRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pikc App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: appNamedRoutesMap,
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}
