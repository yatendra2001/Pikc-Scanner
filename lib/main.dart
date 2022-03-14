import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pikc_app/config/named_routes_map.dart';
import 'package:pikc_app/config/route_generator.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pikc App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: appNamedRoutesMap,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
