import 'package:flutter/material.dart';
import '../../core/app_colors.dart'; // Two levels up to core

class DischargeScreen extends StatelessWidget {
  const DischargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discharge Patient"),
        leading: const Icon(Icons.close),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150',
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "John Doe",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Room 304B • ID #948392",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              "Safety Protocol",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: MedColors.drPrimary,
              ),
            ),
            const SizedBox(height: 15),
            _CheckListItem(
              label: "All medications administered",
              isChecked: true,
            ),
            _CheckListItem(label: "Discharge papers signed", isChecked: true),
            _CheckListItem(
              label: "Patient education completed",
              isChecked: true,
            ),
            _CheckListItem(label: "Belongings collected", isChecked: false),
            const SizedBox(height: 30),
            const Text(
              "Medication Plan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: MedColors.drPrimary,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _PlanAction(
                  icon: Icons.send_to_mobile,
                  label: "Send to Patient App",
                ),
                _PlanAction(icon: Icons.email_outlined, label: "Email PDF"),
                _PlanAction(icon: Icons.print_outlined, label: "Print Summary"),
              ],
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Complete Discharge",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const Center(
              child: TextButton(
                onPressed: null,
                child: Text(
                  "Cancel Discharge",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckListItem extends StatelessWidget {
  final String label;
  final bool isChecked;
  const _CheckListItem({required this.label, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isChecked ? MedColors.drPrimary : Colors.grey,
          ),
          const SizedBox(width: 15),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class _PlanAction extends StatelessWidget {
  final IconData icon;
  final String label;
  const _PlanAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: MedColors.drPrimary),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: 80,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}
