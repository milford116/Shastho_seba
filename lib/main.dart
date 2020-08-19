import 'package:Shastho_Sheba/screens/profile.dart';
import 'package:flutter/material.dart';

import 'models/patient.dart';
import 'screens/splash.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/registration.dart';
import 'screens/feedback.dart';
import 'screens/appointments/appointments.dart';
import 'screens/appointmentDetails/details.dart';
import 'screens/appointmentsToday.dart';
import 'screens/findDoctors/doctorList.dart';
import 'screens/findDoctors/findDoctors.dart';
import 'screens/findDoctors/doctorProfile.dart';
import 'screens/showPrescription.dart';
import 'screens/chamber/chamber.dart';
import 'screens/videoCall.dart';
import 'routes.dart';
import 'utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static Patient patient;
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
        feedbackScreen: (context) => FeedbackScreen(),
        appointmentsScreen: (context) => AppointmentsScreen(),
        appointmentDetailsScreen: (context) => AppointmentDetails(),
        appointmentsTodayScreen: (context) => AppointmentsTodayScreen(),
        showPrescriptionScreen: (context) => ShowPrescriptionScreen(),
        findDoctorsScreen: (context) => FindDoctorsScreen(),
        specialityWiseDoctorListScreen: (context) => DoctorList(),
        doctorProfileScreen: (context) => DoctorProfileScreen(),
        chamberScreen: (context) => ChamberScreen(),
        videoCallScreen: (context) => VideoCallScreen(),
        profileScreen: (context) => ProfileScreen(),
      },
    );
  }
}
