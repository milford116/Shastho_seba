import 'package:flutter/material.dart';

import 'screens/splash.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/registration.dart';
import 'screens/prescriptions/prescriptions.dart';
import 'screens/appointments/appointments.dart';
import 'screens/appointmentDetails/details.dart';
import 'screens/appointmentsToday.dart';
import 'screens/findDoctors/doctorList.dart';
import 'screens/findDoctors/findDoctors.dart';
import 'screens/findDoctors/doctorProfile.dart';
import 'screens/showPrescription.dart';
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
        ),
      ),
      initialRoute: splashScreen,
      routes: {
        splashScreen: (context) => SplashScreen(),
        loginScreen: (context) => LoginScreen(),
        homeScreen: (context) => HomeScreen(),
        registrationScreen: (context) => Registration(),
        prescriptionsScreen: (context) => PrescriptionsScreen(),
        appointmentsScreen: (context) => AppointmentsScreen(),
        appointmentDetailsScreen: (context) => AppointmentDetails(),
        appointmentsTodayScreen: (context) => AppointmentsTodayScreen(),
        showPrescriptionScreen: (context) => ShowPrescriptionScreen(),
        findDoctorsScreen: (context) => FindDoctorsScreen(),
        specialityWiseDoctorListScreen: (context) => DoctorList(),
        doctorProfileScreen: (context) => DoctorProfileScreen(),
      },
    );
  }
}
