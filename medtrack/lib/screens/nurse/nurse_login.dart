import 'package:flutter/material.dart';
import '../../core/app_colors.dart'; // Two levels up to core
import '../../widgets/shared_widgets.dart';

class NurseLogin extends StatelessWidget {
  const NurseLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                // Removed const here
                color: MedColors.nursePrimary, // CHANGED TO MedColors
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.medical_information_outlined,
                    color: Colors.white,
                    size: 60,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Nurse Portal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Medication Management System",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  const MedTextField(
                    label: "Ward ID",
                    hint: "Enter Ward ID",
                    icon: Icons.domain,
                  ),
                  const SizedBox(height: 20),
                  const MedTextField(
                    label: "Email Address",
                    hint: "nurse@hospital.com",
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 20),
                  const MedTextField(
                    label: "Password",
                    hint: "••••••••",
                    isPassword: true,
                    icon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          MedColors.nursePrimary, // CHANGED TO MedColors
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/ward_dashboard',
                      );
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: MedColors.textSecondary),
                    ), // CHANGED TO MedColors
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
