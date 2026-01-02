import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedColors.landingBg,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white10,
              child: Icon(
                Icons.medical_services,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "MedTrack",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Hospital Medication Management",
              style: TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 60),
            _btn(
              context,
              "Doctor Portal",
              "Prescribe & Monitor",
              MedColors.drPrimary,
              Icons.person_search,
              '/doctor_login',
            ),
            const SizedBox(height: 15),
            _btn(
              context,
              "Nurse Portal",
              "Administer & Track",
              MedColors.nursePrimary,
              Icons.medical_information,
              '/nurse_login',
            ),
            const SizedBox(height: 15),
            _btn(
              context,
              "Patient Portal",
              "View Schedule",
              MedColors.patPrimary,
              Icons.person,
              '/patient_login',
            ),
            const Spacer(),
            const Text(
              "© 2024 MedTrack v1.0",
              style: TextStyle(color: Colors.white24, fontSize: 10),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _btn(
    BuildContext context,
    String t,
    String s,
    Color c,
    IconData i,
    String r,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(i, color: c, size: 30),
        title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(s, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.pushNamed(context, r),
      ),
    );
  }
}
