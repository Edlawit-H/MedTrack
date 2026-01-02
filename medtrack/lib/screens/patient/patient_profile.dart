import 'package:flutter/material.dart';
import '../../core/app_colors.dart'; // Two levels up to core

class PatientProfile extends StatelessWidget {
  const PatientProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: MedColors.drPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            const SizedBox(height: 15),
            const Text(
              "Sarah Jenkins",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text("ID: #898223", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Tag(label: "A+ Blood", color: Colors.blue),
                const SizedBox(width: 10),
                _Tag(label: "Active Status", color: Colors.green),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ProfileInfo(label: "Date of Birth", value: "Jan 12, 1980"),
                _ProfileInfo(label: "Age", value: "44 Yrs"),
              ],
            ),
            const SizedBox(height: 30),
            _buildSectionHeader("My Doctor", null),
            const Card(
              child: ListTile(
                leading: CircleAvatar(child: Icon(Icons.person)),
                title: Text("Dr. Emily Chen"),
                subtitle: Text("Cardiologist • St. Mary's"),
                trailing: Icon(Icons.phone, color: MedColors.drPrimary),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionHeader("My Medications", "View Schedule"),
            _medItem("Atorvastatin", "20mg • 1 Tablet", "Next Dose: 8:00 PM"),
            _medItem("Metoprolol", "50mg • 1 Tablet", "Next Dose: Tomorrow"),
            const SizedBox(height: 20),
            _buildSectionHeader("Medical Information", null),
            _infoCard("ALLERGIES", "Penicillin, Peanuts", Colors.red),
            _infoCard(
              "CONDITIONS",
              "Hypertension, High Cholesterol",
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        if (action != null)
          Text(
            action,
            style: const TextStyle(color: MedColors.drPrimary, fontSize: 12),
          ),
      ],
    );
  }

  Widget _medItem(String name, String dose, String time) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: const Icon(Icons.medication, color: MedColors.drPrimary),
        title: Text(name),
        subtitle: Text(dose),
        trailing: Text(
          time,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _infoCard(String label, String value, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  final String label, value;
  const _ProfileInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
