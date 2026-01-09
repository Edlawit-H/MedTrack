import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/primary_button.dart';

class PatientProfileSettings extends StatelessWidget {
  const PatientProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedColors.patBg,
       appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
             const CircleAvatar(
               radius: 50,
               backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
             ),
             const SizedBox(height: 16),
             const Text("John Doe", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
             const Text("ID: #PT304", style: TextStyle(color: Colors.grey)),
             
             const SizedBox(height: 32),
             _SettingTile(icon: Icons.person_outline, title: "Personal Details", onTap: (){}),
             _SettingTile(icon: Icons.history, title: "Medical History", onTap: (){}),
             _SettingTile(icon: Icons.notifications_outlined, title: "Notifications", onTap: (){}),
             _SettingTile(icon: Icons.lock_outline, title: "Privacy & Security", onTap: (){}),
             _SettingTile(icon: Icons.help_outline, title: "Help & Support", onTap: (){}),
             
             const SizedBox(height: 40),
             PrimaryButton(
               text: "Log Out",
               color: Colors.red.shade400,
               onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
             )
          ],
        ),
      )
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16)
      ),
      child: ListTile(
        leading: Icon(icon, color: MedColors.patPrimary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
