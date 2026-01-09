import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
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
            // Green Header Card
            Container(
              width: double.infinity,
              height: 340,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
              decoration: const BoxDecoration(
                color: MedColors.nursePrimary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                    child: const Icon(Icons.medical_services, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text("Nurse Portal", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text("Medication Management System", style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MedTextField(label: "Ward ID", hint: "Enter Ward ID", icon: Icons.local_hospital_outlined),
                  const SizedBox(height: 20),
                  MedTextField(label: "Email Address", hint: "nurse@hospital.com", icon: Icons.email_outlined),
                  const SizedBox(height: 20),
                  MedTextField(label: "Password", hint: "Enter Password", isPassword: true, icon: Icons.lock_outline),
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {}, 
                      child: const Text("Forgot Password?", style: TextStyle(color: MedColors.nursePrimary, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/ward_dashboard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A), // Dark blue button from image
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      shadowColor: Colors.blue.withOpacity(0.3),
                    ),
                    child: const Text("Sign In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  
                   const SizedBox(height: 40),
                   const Center(
                     child: Column(
                       children: [
                          Icon(Icons.local_hospital, color: Colors.grey, size: 24),
                          SizedBox(height: 8),
                          Text("ST. JUDE MEDICAL CENTER", style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
                       ],
                     ),
                   )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
