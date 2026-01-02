import 'package:flutter/material.dart';
import '../../core/app_colors.dart'; // Two levels up to core

class WardDashboard extends StatelessWidget {
  const WardDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedColors.nurseBg,
      appBar: AppBar(
        backgroundColor: MedColors.nursePrimary,
        title: const Text("Ward 3A", style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          _card(
            context,
            "304 • John Doe",
            "09:00 AM • Insulin",
            "OVERDUE",
            Colors.red,
          ),
          _card(
            context,
            "305 • Jane Smith",
            "10:00 AM • Amoxicillin",
            "DUE SOON",
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, String n, String d, String s, Color c) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(n, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  s,
                  style: TextStyle(color: c, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ListTile(
              title: Text(d),
              trailing: ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/nurse_patient_detail'),
                child: const Text("Give"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
