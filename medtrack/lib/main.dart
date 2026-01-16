import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/landing_screen.dart';
import 'screens/doctor/doctor_login.dart';
import 'screens/doctor/doctor_dashboard.dart';
import 'screens/doctor/patient_profile_dr.dart';
import 'screens/doctor/add_patient.dart';

import 'screens/nurse/nurse_login.dart';
import 'screens/nurse/ward_dashboard.dart';
import 'screens/nurse/med_action.dart';
import 'screens/nurse/nurse_patient_details.dart';
import 'screens/nurse/med_admin_screen.dart';
import 'screens/nurse/nurse_profile.dart';


import 'package:medtrack/screens/patient/patient_login.dart';
import 'package:medtrack/screens/patient/patient_dashboard.dart';
import 'package:medtrack/screens/patient/patient_appointments.dart';
import 'package:medtrack/screens/patient/patient_profile.dart';
import 'package:medtrack/screens/patient/med_reminder_modal.dart';
import 'screens/auth/password_change_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://wsikiyzzfeyaetcwktuc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndzaWtpeXp6ZmV5YWV0Y3drdHVjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgyMDcxNzcsImV4cCI6MjA4Mzc4MzE3N30.zUWQ4L0QOdWcRlnPbcsvnq72Dxhq4n8jZGCD10tTP3E',
  );
  
  runApp(const MedTrackApp());
}

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
        // Removed '/nurse_discharge' as it requires dynamic patient data
        '/med_action': (context) => const MedActionScreen(),

        '/patient_login': (context) => const PatientLogin(),
        '/patient_dashboard': (context) => const PatientDashboard(),
        '/patient_appointments': (context) => const PatientAppointments(),
        '/patient_profile': (context) => const PatientProfile(),
        '/patient_med_reminder': (context) => const MedReminderModal(),
        '/password_change': (context) => const PasswordChangeScreen(),
      },
    );
  }
}
