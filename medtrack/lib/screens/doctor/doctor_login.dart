import 'package:flutter/material.dart';
import '../../core/app_colors.dart'; // Two levels up to core
import '../../widgets/shared_widgets.dart';
import '../../widgets/primary_button.dart';

class DoctorLogin extends StatelessWidget {
  const DoctorLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedColors.greyBg,
      body: Stack(
        children: [
          // Blue Background Header
          Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [MedColors.drStart, MedColors.drEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Column(
                        children: [
                          Icon(Icons.medical_services_rounded, color: Colors.white, size: 48),
                          SizedBox(height: 16),
                          Text(
                            "Doctor Portal",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Hospital Medication Management",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Login Form Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      MedTextField(
                        label: "Email",
                        hint: "doctor@hospital.com",
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 20),
                      MedTextField(
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
