import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class MedAdminScreen extends StatelessWidget {
  const MedAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Confirm Action", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Patient Strip
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12)
              ),
              child: const Row(
                children: [
                  CircleAvatar(radius: 20, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12')),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("John Doe", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Room 304 • MRN #12345", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
                ],
              ),
            ),
            const SizedBox(height: 40),

            const Icon(Icons.access_time_filled, color: MedColors.royalBlue, size: 16),
            const SizedBox(height: 8),
            const Text("Scheduled 9:00 AM", style: TextStyle(color: MedColors.royalBlue, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            const Text("Metformin", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const Text("500mg", style: TextStyle(fontSize: 24, color: Colors.grey)),
            
            const SizedBox(height: 40),
            
            // Instruction
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12)
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Icon(Icons.info, color: MedColors.royalBlue),
                   const SizedBox(width: 12),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const Text("Dosage Instructions", style: TextStyle(fontWeight: FontWeight.bold, color: MedColors.royalBlue)),
                         const SizedBox(height: 4),
                         Text("Administer orally with meals to reduce gastrointestinal side effects.", style: TextStyle(color: Colors.blue.shade900)),
                         const SizedBox(height: 12),
                         const Row(
                           children: [
                             _Tag(text: "ORAL"),
                             SizedBox(width: 8),
                             _Tag(text: "TAB"),
                           ],
                         )
                       ],
                     ),
                   )
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Clinical Notes
            const Align(alignment: Alignment.centerLeft, child: Text("Clinical Notes (Optional)", style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: "Tap to add details...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.grey)),
                contentPadding: const EdgeInsets.all(16)
              ),
              maxLines: 3,
            ),
            
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MedColors.nursePrimary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("GIVEN NOW", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(width: 8),
                    Icon(Icons.check_circle, color: Colors.white)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("MARK AS MISSED", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(Icons.cancel, color: Colors.red)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.blue.shade100)
      ),
      child: Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }
}
