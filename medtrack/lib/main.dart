import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/landing_screen.dart';
import 'screens/doctor/doctor_login.dart';
import 'screens/doctor/doctor_dashboard.dart';
import 'screens/doctor/patient_profile_dr.dart';
import 'screens/doctor/add_patient.dart';

import 'screens/nurse/nurse_login.dart';
import 'screens/nurse/ward_dashboard.dart';
import 'screens/nurse/patient_detail_nurse.dart';
import 'screens/nurse/med_action.dart';
import 'screens/nurse/nurse_patient_details.dart';
import 'screens/nurse/med_admin_screen.dart';
import 'screens/nurse/nurse_profile.dart';
import 'screens/nurse/discharge_screen.dart';

import 'package:medtrack/screens/patient/patient_login.dart';
import 'package:medtrack/screens/patient/patient_dashboard.dart';
import 'package:medtrack/screens/patient/patient_appointments.dart';
import 'package:medtrack/screens/patient/patient_profile.dart';
import 'package:medtrack/screens/patient/med_reminder_modal.dart';

void main() => runApp(const MedTrackApp());

class MedTrackApp extends StatelessWidget {
  const MedTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedTrack',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingScreen(),
        '/doctor_login': (context) => const DoctorLogin(),

        // ❌ REMOVED const (IMPORTANT)
        '/doctor_dashboard': (context) => DoctorDashboard(),
        '/doctor_patient_profile': (context) => PatientProfileDr(),
        '/doctor_add_patient': (context) => AddNewPatient(),

        '/nurse_login': (context) => const NurseLogin(),
        '/ward_dashboard': (context) => const WardDashboard(),
        '/nurse_patient_details': (context) => const NursePatientDetails(),
        '/nurse_med_admin': (context) => const MedAdminScreen(),
        '/nurse_profile': (context) => const NurseProfile(),
        '/nurse_discharge': (context) => const DischargeScreen(),
        '/nurse_patient_detail': (context) => const PatientDetailNurse(),
        '/med_action': (context) => const MedActionScreen(),

        '/patient_login': (context) => const PatientLogin(),
        '/patient_dashboard': (context) => const PatientDashboard(),
        '/patient_appointments': (context) => const PatientAppointments(),
        '/patient_profile': (context) => const PatientProfile(),
        '/patient_med_reminder': (context) => const MedReminderModal(),
      },
    );
  }
}
