import 'package:flutter/material.dart';
import '../../core/app_colors.dart'; // Two levels up to core
import '../../widgets/shared_widgets.dart';

class DoctorLogin extends StatelessWidget {
  const DoctorLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: MedColors.drPrimary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(60),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.medical_services, color: Colors.white, size: 60),
                  Text(
                    "Doctor Portal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const MedTextField(
                    label: "Email",
                    hint: "doctor@hospital.com",
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 20),
                  const MedTextField(
                    label: "Password",
                    hint: "••••••••",
                    isPassword: true,
                    icon: Icons.lock,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(
                      context,
                      '/doctor_dashboard',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MedColors.drPrimary,
                      minimumSize: const Size(double.infinity, 55),
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
