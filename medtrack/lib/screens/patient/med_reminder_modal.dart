import 'package:flutter/material.dart';

class MedReminderModal extends StatelessWidget {
  const MedReminderModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5), // Simulate modal overlay if pushed as page
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Align(alignment: Alignment.topRight, child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, size: 20, color: Colors.grey))),
               
               Container(
                 padding: const EdgeInsets.all(20),
                 decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
                 child: const Icon(Icons.medical_services, size: 40, color: Color(0xFF304FFE)),
               ),
               const SizedBox(height: 20),
               
               const Text("Time for your\nmedication!", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
               const SizedBox(height: 8),
               const Text("Staying on track helps your recovery.", style: TextStyle(color: Colors.grey, fontSize: 12)),
               
               const SizedBox(height: 24),
               
               Container(
                 padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(16),
                   border: Border.all(color: Colors.grey.shade200),
                   boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)]
                 ),
                 child: Row(
                   children: [
                     Container(height: 40, width: 40, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8))),
                     const SizedBox(width: 12),
                     const Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text("Metformin", style: TextStyle(fontWeight: FontWeight.bold)),
                         Text("500mg • 1 Tablet", style: TextStyle(color: Colors.grey, fontSize: 11)),
                       ],
                     )
                   ],
                 ),
               ),
               
               const SizedBox(height: 20),
               
               const _DetailRow(icon: Icons.access_time_filled, text: "10:00 AM Today", label: "SCHEDULED"),
               const SizedBox(height: 12),
               const _DetailRow(icon: Icons.restaurant, text: "Take with food", label: "INSTRUCTIONS", color: Colors.orange),

               const SizedBox(height: 30),
               
               SizedBox(
                 width: double.infinity,
                 child: ElevatedButton.icon(
                   onPressed: () => Navigator.pop(context),
                   icon: const Icon(Icons.check_circle, size: 18),
                   label: const Text("I've Taken It"),
                   style: ElevatedButton.styleFrom(
                     backgroundColor: const Color(0xFF304FFE), 
                     foregroundColor: Colors.white,
                     padding: const EdgeInsets.symmetric(vertical: 16),
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                   ),
                 ),
               ),
               const SizedBox(height: 16),
               GestureDetector(
                 onTap: () => Navigator.pop(context),
                 child: const Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Icon(Icons.snooze, size: 16, color: Colors.grey),
                     SizedBox(width: 8),
                     Text("Remind Me Later", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                   ],
                 ),
               )
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final String label;
  final Color? color;
  const _DetailRow({required this.icon, required this.text, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color ?? const Color(0xFF304FFE)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(label, style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1)),
             Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        )
      ],
    );
  }
}
