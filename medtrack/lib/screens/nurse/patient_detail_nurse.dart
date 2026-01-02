import 'package:flutter/material.dart';
import '../../core/app_colors.dart'; // Two levels up to core

class PatientDetailNurse extends StatelessWidget {
  const PatientDetailNurse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("John Doe"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "ALLERGY ALERT: Penicillin",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today's Medications",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text("Insulin Aspart"),
              subtitle: const Text("Due Now • 12:00 PM"),
              trailing: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/med_action'),
                child: const Text("Give Now"),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/discharge_screen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: MedColors.nursePrimary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Initiate Discharge"),
            ),
          ],
        ),
      ),
    );
  }
}
