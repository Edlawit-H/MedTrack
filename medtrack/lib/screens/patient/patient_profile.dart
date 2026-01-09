import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class PatientProfile extends StatelessWidget {
  const PatientProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: const [
          Icon(Icons.edit, color: Colors.blue),
          SizedBox(width: 20)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
            ),
            const SizedBox(height: 12),
            const Text("Sarah Jenkins", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text("ID: 4983225", style: TextStyle(color: Colors.grey, fontSize: 12)),
            
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TagP(label: "A+ Blood", color: Colors.blue),
                SizedBox(width: 10),
                _TagP(label: "Active Status", color: Colors.green),
              ],
            ),
            
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 _InfoCol(label: "DATE OF BIRTH", value: "Jan 12, 1980"),
                 Container(height: 30, width: 1, color: Colors.grey.shade300),
                 _InfoCol(label: "AGE", value: "44 Yrs"),
              ],
            ),
            
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),

            // My Doctor
            const _SectionHeader(title: "My Doctor", icon: Icons.medical_services_outlined),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(12)),
              child: const ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5')),
                title: Text("Dr. Emily Chen", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text("Cardiologist\nSt. Mary's Hospital", style: TextStyle(fontSize: 12)),
                trailing: CircleAvatar(backgroundColor: Color(0xFFE8EAF6), child: Icon(Icons.call, color: MedColors.royalBlue, size: 18)),
              ),
            ),
            
             const SizedBox(height: 24),
             
             // My Medications
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 const _SectionHeader(title: "My Medications", icon: Icons.medication),
                 Text("View Schedule", style: TextStyle(color: Colors.blue.shade700, fontSize: 11, fontWeight: FontWeight.bold))
               ],
             ),
             const SizedBox(height: 12),
             _MedRow(name: "Atorvastatin", dose: "20mg • 1 Tablet", next: "8:00 PM"),
             _MedRow(name: "Metoprolol", dose: "50mg • 1 Tablet", next: "Tomorrow"),
             
             const SizedBox(height: 24),
             
             // Medical Info
             const _SectionHeader(title: "Medical Information", icon: Icons.info_outline),
             const SizedBox(height: 10),
             const Align(alignment: Alignment.centerLeft, child: Text("ALLERGIES", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))),
             const SizedBox(height: 6),
             const Row(children: [_TagP(label: "Warning: Penicillin", color: Colors.red), SizedBox(width: 8), _TagP(label: "Peanuts", color: Colors.red)]),
             const SizedBox(height: 12),
             const Align(alignment: Alignment.centerLeft, child: Text("CONDITIONS", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))),
             const SizedBox(height: 6),
             const Row(children: [_TagP(label: "Hypertension", color: Colors.blue), SizedBox(width: 8), _TagP(label: "High Cholesterol", color: Colors.blue)]),
             
             const SizedBox(height: 30),
             
             // Preferences
             const _SectionHeader(title: "Preferences", icon: Icons.settings),
             const SwitchListTile(value: true, onChanged: null, title: Text("Push Notifications", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), subtitle: Text("Receive alerts on lock screen", style: TextStyle(fontSize: 11))),
             const SwitchListTile(value: true, onChanged: null, title: Text("Refill Reminders", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), subtitle: Text("Alert 3 days before expiry", style: TextStyle(fontSize: 11))),
             
             const SizedBox(height: 30),
             TextButton.icon(
               onPressed: () => Navigator.pushReplacementNamed(context, '/'), 
               icon: const Icon(Icons.logout, color: Colors.black), 
               label: const Text("Log Out", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
             )

          ],
        ),
      ),
    );
  }
}

class _TagP extends StatelessWidget {
  final String label;
  final Color color;
  const _TagP({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}

class _InfoCol extends StatelessWidget {
  final String label;
  final String value;
  const _InfoCol({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: MedColors.royalBlue),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
      ],
    );
  }
}

class _MedRow extends StatelessWidget {
  final String name;
  final String dose;
  final String next;
  const _MedRow({required this.name, required this.dose, required this.next});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.medication, color: Colors.purple, size: 16)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(dose, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("Next Dose", style: TextStyle(color: Colors.grey, fontSize: 9)),
              Text(next, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
            ],
          )
        ],
      ),
    );
  }
}
