import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class NurseProfile extends StatelessWidget {
  final bool showBackButton;
  const NurseProfile({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Custom Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
              decoration: const BoxDecoration(
                color: MedColors.nursePrimary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      showBackButton 
                          ? IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white))
                          : const SizedBox(width: 48), // Placeholder to keep title centered if needed, or just remove
                      const Text("My Profile", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const Icon(Icons.settings, color: Colors.white)
                    ],
                  ),
                  const SizedBox(height: 24),
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
                  ),
                   const SizedBox(height: 12),
                   const Text("Mary Johnson, RN", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                   const SizedBox(height: 4),
                   const Text("ID: #88219 • Ward 3A", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Stats
            Padding(
               padding: const EdgeInsets.symmetric(horizontal: 24),
               child: Container(
                 padding: const EdgeInsets.all(20),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(20),
                   boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)]
                 ),
                 child: const Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     _ProfileStat(value: "1,247", label: "MEDS GIVEN", icon: Icons.medication),
                     _ProfileStat(value: "Day", label: "CURRENT SHIFT", icon: Icons.wb_sunny, color: Colors.orange),
                     _ProfileStat(value: "8", label: "YEARS EXP", icon: Icons.star, color: Colors.purple),
                   ],
                 ),
               ),
            ),
             const SizedBox(height: 30),

            // Details List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Contact Details", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 10),
                  const _InfoTile(icon: Icons.phone, title: "(555) 123-4567", subtitle: "Mobile"),
                   const _InfoTile(icon: Icons.email, title: "m.johnson@hospital.org", subtitle: "Work Email"),
                   const _InfoTile(icon: Icons.person, title: "John Doe (Husband)", subtitle: "Emergency Contact", iconColor: Colors.red),
                   
                   const SizedBox(height: 30),
                   
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       const Text("Certifications", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                       Text("View All", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                     ],
                   ),
                   const SizedBox(height: 10),
                   
                   _CertItem(title: "BLS (Basic Life Support)", exp: "Exp: 11/2026"),
                   _CertItem(title: "ACLS (Advanced Cardiac)", exp: "Exp: 06/2025"),
                   
                   const SizedBox(height: 40),
                   
                   Center(
                     child: TextButton.icon(
                       onPressed: () => Navigator.pushReplacementNamed(context, '/'), 
                       icon: const Icon(Icons.logout, color: Colors.red),
                       label: const Text("Log Out", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                     ),
                   )
                ],
              ),
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
  final IconData icon;
  final Color? color;

  const _ProfileStat({required this.value, required this.label, required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color ?? MedColors.nursePrimary, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;

  const _InfoTile({required this.icon, required this.title, required this.subtitle, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
             padding: const EdgeInsets.all(8),
             decoration: BoxDecoration(color: (iconColor ?? MedColors.nursePrimary).withOpacity(0.1), shape: BoxShape.circle),
             child: Icon(icon, color: iconColor ?? MedColors.nursePrimary, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)
        ],
      ),
    );
  }
}

class _CertItem extends StatelessWidget {
  final String title;
  final String exp;

  const _CertItem({required this.title, required this.exp});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.2))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.verified, color: Colors.green, size: 20),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(exp, style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: const Text("VALID", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
