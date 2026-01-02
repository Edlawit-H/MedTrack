import 'package:flutter/material.dart';
import '../../core/app_colors.dart'; // Two levels up to core

class NurseProfile extends StatelessWidget {
  const NurseProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedColors.nurseBg,
      appBar: AppBar(
        backgroundColor: MedColors.nursePrimary,
        title: const Text("My Profile", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
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
              "Mary Johnson, RN",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              "ID: #88219 • Ward 3A",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 25),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NurseStat(label: "Meds Given", value: "1,247"),
                _NurseStat(label: "Current Shift", value: "Day"),
                _NurseStat(label: "Years Exp.", value: "8"),
              ],
            ),
            const SizedBox(height: 30),
            _buildContactCard(),
            const SizedBox(height: 20),
            _buildCertifications(),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: () {},
              child: const Text("Log Out"),
            ),
            const SizedBox(height: 10),
            const Text(
              "v2.4.1 (Build 892)",
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Column(
        children: [
          _NurseInfoTile(icon: Icons.phone, value: "(555) 123-4567"),
          Divider(),
          _NurseInfoTile(icon: Icons.email, value: "m.johnson@hospital.org"),
        ],
      ),
    );
  }

  Widget _buildCertifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Certifications",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _CertTile(
          label: "BLS (Basic Life Support)",
          expiry: "Exp: 12/2024",
          isValid: true,
        ),
        _CertTile(
          label: "ACLS (Advanced Cardiac)",
          expiry: "Exp: 06/2025",
          isValid: true,
        ),
      ],
    );
  }
}

class _NurseStat extends StatelessWidget {
  final String label, value;
  const _NurseStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MedColors.nursePrimary,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}

class _NurseInfoTile extends StatelessWidget {
  final IconData icon;
  final String value;
  const _NurseInfoTile({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: MedColors.nursePrimary),
        const SizedBox(width: 15),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _CertTile extends StatelessWidget {
  final String label, expiry;
  final bool isValid;
  const _CertTile({
    required this.label,
    required this.expiry,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                expiry,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          if (isValid)
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
        ],
      ),
    );
  }
}
