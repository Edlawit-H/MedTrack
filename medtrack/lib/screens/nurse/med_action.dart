import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/primary_button.dart';

class MedActionScreen extends StatelessWidget {
  const MedActionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Confirm Action", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: MedColors.nurseBg,
              child: Icon(Icons.person, size: 40, color: MedColors.nursePrimary),
            ),
            const SizedBox(height: 16),
            const Text("John Doe", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Text("Room 304", style: TextStyle(color: Colors.grey)),
            
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Text("Metformin", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: MedColors.textMain)),
                   SizedBox(height: 8),
                  Text("500mg • Oral Tablet", style: TextStyle(fontSize: 18, color: MedColors.textSecondary)),
                   SizedBox(height: 20),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Icon(Icons.access_time, size: 16, color: MedColors.nursePrimary),
                       SizedBox(width: 8),
                       Text("Scheduled for 09:00 AM", style: TextStyle(fontWeight: FontWeight.bold, color: MedColors.nursePrimary)),
                     ],
                   )
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.2))
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(child: Text("Administer orally with meals to reduce gastrointestinal side effects.", style: TextStyle(color: Colors.blue, fontSize: 12))),
                ],
              ),
            ),

            const Spacer(),
            PrimaryButton(
              text: "GIVEN NOW",
              color: MedColors.nursePrimary,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 16),
             OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              ),
              child: const Text(
                "MARK AS MISSED",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
