import 'package:flutter/material.dart';
import '../../core/app_colors.dart'; // Two levels up to core

class PatientLogin extends StatelessWidget {
  const PatientLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Start Your Journey",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Enter activation code", textAlign: TextAlign.center),
            const SizedBox(height: 40),
            TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "8 2 9 4 0 1",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/patient_dashboard'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E676),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: const StadiumBorder(),
              ),
              child: const Text("Activate Account"),
            ),
          ],
        ),
      ),
    );
  }
}
