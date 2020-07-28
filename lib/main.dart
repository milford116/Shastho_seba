import 'package:flutter/material.dart';

import 'screens/splash.dart';
import 'screens/login.dart';
import 'routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: splashScreen,
      routes: {
        splashScreen: (context) => SplashScreen(),
        loginScreen: (context) => LoginScreen(),
      },
    );
  }
}