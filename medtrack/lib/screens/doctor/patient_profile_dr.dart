import 'package:flutter/material.dart';

class PatientProfileDr extends StatelessWidget {
  const PatientProfileDr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2FE8),
        title: const Text("Patient Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: CircleAvatar(radius: 28),
              title: Text(
                "Jane Doe",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Age: 68 • Blood Type: O+"),
            ),

            const SizedBox(height: 20),
            const Text(
              "Medication Adherence",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.93,
              color: Colors.green,
              backgroundColor: Colors.grey.shade300,
            ),

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text("Message"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D2FE8),
                    ),
                    icon: const Icon(Icons.call),
                    label: const Text("Call Patient"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
