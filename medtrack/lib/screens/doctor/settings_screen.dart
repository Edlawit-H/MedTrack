import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedColors.greyBg,
      appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          )
        ],
        automaticallyImplyLeading: false, // Hide back button if using tab
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile & Stats
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            ),
            const SizedBox(height: 16),
            const Text("Dr. Sarah Johnson", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: MedColors.textMain)),
            const Text("Cardiologist", style: TextStyle(color: MedColors.textSecondary, fontSize: 16)),
            const Text("St. Mary's General Hospital", style: TextStyle(color: MedColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 30),
            
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ProfileStat(value: "15", label: "YEARS EXP."),
                Container(height: 40, width: 1, color: Colors.grey.shade300),
                _ProfileStat(value: "1.2k", label: "PATIENTS"),
                 Container(height: 40, width: 1, color: Colors.grey.shade300),
                _ProfileStat(value: "4.9", label: "RATING", isRating: true),
              ],
            ),
            const SizedBox(height: 40),

            // Contact Info
            const _SectionHeader(title: "CONTACT INFORMATION"),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                ]
              ),
              child: const Column(
                children: [
                   _ContactRow(icon: Icons.email_outlined, label: "Email Address", value: "sarah.johnson@stmarys.med"),
                   Divider(height: 30),
                   _ContactRow(icon: Icons.phone_outlined, label: "Phone Number", value: "+1 (555) 012-3456"),
                ],
              ),
            ),
            
             // Work Schedule
            const _SectionHeader(title: "WORK SCHEDULE"),
             Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                ]
              ),
              child: const Column(
                children: [
                   _ContactRow(icon: Icons.calendar_today_outlined, label: "Mon - Fri", value: "08:00 - 16:00"),
                   Divider(height: 30),
                   _ContactRow(icon: Icons.circle, iconColor: Colors.green, label: "On-Call", value: "Thursdays"),
                ],
              ),
            ),

            const SizedBox(height: 20),
              SizedBox(
               width: double.infinity,
               child: ElevatedButton(
                 onPressed: () {},
                 style: ElevatedButton.styleFrom(
                   backgroundColor: MedColors.royalBlue,
                   padding: const EdgeInsets.symmetric(vertical: 16),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                   elevation: 0
                 ),
                 child: const Text("Edit Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
               ),
             ),
             const SizedBox(height: 12),
             TextButton.icon(
               onPressed: () => Navigator.pushReplacementNamed(context, '/'), 
               icon: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
               label: const Text("Logout", style: TextStyle(color: Colors.redAccent)),
             )
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;
  final bool isRating;

  const _ProfileStat({required this.value, required this.label, this.isRating = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: MedColors.royalBlue)),
            if(isRating) const Icon(Icons.star, color: Colors.amber, size: 20),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.video_label, color: MedColors.royalBlue.withOpacity(0.5), size: 16),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final String value;

  const _ContactRow({required this.icon, required this.label, required this.value, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: MedColors.greyBg, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: iconColor ?? MedColors.royalBlue, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: MedColors.textSecondary)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: MedColors.textMain)),
          ],
        )
      ],
    );
  }
}
