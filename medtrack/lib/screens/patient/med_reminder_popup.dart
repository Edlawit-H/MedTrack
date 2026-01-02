import 'package:flutter/material.dart';
import '../../core/app_colors.dart'; // Two levels up to core

class MedReminderPopup extends StatelessWidget {
  const MedReminderPopup({super.key});

  static void show(BuildContext context) =>
      showDialog(context: context, builder: (_) => const MedReminderPopup());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.medication, size: 60, color: MedColors.drPrimary),
            const Text(
              "Time for your medication!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: MedColors.drPrimary,
                minimumSize: const Size(double.infinity, 55),
              ),
              child: const Text(
                "I've Taken It",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
