import 'package:flutter/material.dart';

import 'screens/splash.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/prescriptions/prescriptions.dart';
import 'screens/appointments/appointments.dart';
import 'screens/registration.dart';
import 'routes.dart';
import 'utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: TextTheme(
        bodyText2: TextStyle(color: blue),
        subtitle1: TextStyle(color: blue),
      )),
      initialRoute: splashScreen,
      routes: {
        splashScreen: (context) => SplashScreen(),
        loginScreen: (context) => LoginScreen(),
        homeScreen: (context) => HomeScreen(),
        registrationScreen: (context) => Registration(),
        prescriptionsScreen: (context) => PrescriptionsScreen(),
        appointmentsScreen: (context) => AppointmentsScreen(),
      },
    );
  }
}
