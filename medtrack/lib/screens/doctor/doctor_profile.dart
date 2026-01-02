import 'package:flutter/material.dart';
import '../../core/app_colors.dart'; // Two levels up to core

class DoctorProfile extends StatelessWidget {
  const DoctorProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedColors.drBg,
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
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
              "Dr. Sarah Johnson",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Cardiologist",
              style: TextStyle(
                color: MedColors.drPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "St. Mary's General Hospital",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 25),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ProfileStat(label: "Years Exp.", value: "15"),
                _ProfileStat(label: "Patients", value: "1.2k"),
                _ProfileStat(label: "Rating", value: "4.9 ★"),
              ],
            ),
            const SizedBox(height: 30),
            _buildInfoSection("CONTACT INFORMATION", [
              const _InfoTile(
                icon: Icons.email_outlined,
                label: "Email Address",
                value: "sarah.johnson@stmarys.med",
              ),
              const _InfoTile(
                icon: Icons.phone_outlined,
                label: "Phone Number",
                value: "+1 (555) 012-3456",
              ),
            ]),
            const SizedBox(height: 20),
            _buildInfoSection("WORK SCHEDULE", [
              const _InfoTile(
                icon: Icons.calendar_today_outlined,
                label: "Mon - Fri",
                value: "08:00 - 16:00",
              ),
              const _InfoTile(
                icon: Icons.access_time_outlined,
                label: "On-Call",
                value: "Thursdays",
              ),
            ]),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MedColors.drPrimary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: () {},
              child: const Text("Edit Profile"),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Change Password",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label, value;
  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MedColors.drPrimary,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
