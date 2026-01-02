import 'package:flutter/material.dart';
import '../../core/app_colors.dart'; // Two levels up to core
import 'med_reminder_popup.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedColors.patBg,
      appBar: AppBar(
        title: const Text("Hello, John!"),
        actions: [
          IconButton(
            onPressed: () => MedReminderPopup.show(context),
            icon: const Icon(Icons.alarm),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("PROGRESS", style: TextStyle(fontSize: 10)),
                      Text(
                        "3 of 5",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  CircularProgressIndicator(
                    value: 0.6,
                    color: MedColors.patPrimary,
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
