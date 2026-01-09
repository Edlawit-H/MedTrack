import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class DischargeScreen extends StatefulWidget {
  const DischargeScreen({super.key});

  @override
  State<DischargeScreen> createState() => _DischargeScreenState();
}

class _DischargeScreenState extends State<DischargeScreen> {
  bool isProtocol1 = true;
  bool isProtocol2 = true;
  bool isProtocol3 = true;
  bool isProtocol4 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Discharge Patient", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
             // Patient Header
             Row(
               children: [
                 const CircleAvatar(radius: 30, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12')),
                 const SizedBox(width: 16),
                 const Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text("John Doe", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                     Row(children: [Icon(Icons.meeting_room, size: 14, color: Colors.grey), SizedBox(width: 4), Text("Room 304 • ID #448392", style: TextStyle(color: Colors.grey))]),
                     Text("DOB: Jan 12, 1980 (44y)", style: TextStyle(color: Colors.grey, fontSize: 12)),
                   ],
                 ),
               ],
             ),
             const SizedBox(height: 30),

             // Safety Protocol
             const _SectionHeader(title: "Safety Protocol", icon: Icons.security),
             const SizedBox(height: 16),
             _CheckItem(label: "All medications administered", val: isProtocol1, onChanged: (v) => setState(() => isProtocol1 = v!)),
             _CheckItem(label: "Discharge papers signed", val: isProtocol2, onChanged: (v) => setState(() => isProtocol2 = v!)),
             _CheckItem(label: "Patient education completed", val: isProtocol3, onChanged: (v) => setState(() => isProtocol3 = v!)),
             _CheckItem(label: "Belongings collected", val: isProtocol4, onChanged: (v) => setState(() => isProtocol4 = v!)),
             
             const SizedBox(height: 30),
             
             // Medication Plan
             const _SectionHeader(title: "Medication Plan", icon: Icons.medication_liquid),
             const SizedBox(height: 16),
             
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 _ActionIcon(icon: Icons.mobile_screen_share, label: "Send to\nApp"),
                 _ActionIcon(icon: Icons.email, label: "Email\nPDF"),
                 _ActionIcon(icon: Icons.print, label: "Print\nSummary"),
               ],
             ),

             const SizedBox(height: 50),
             
             const Text("Discharge recorded by\nNurse Sarah Jenkins - 10:42 AM", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
             const SizedBox(height: 20),
             
              SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MedColors.nursePrimary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text("Complete Discharge", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ),
             const SizedBox(height: 16),
             TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel Discharge", style: TextStyle(color: Colors.grey)))

          ],
        ),
      ),
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
        Icon(icon, color: MedColors.royalBlue, size: 20),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String label;
  final bool val;
  final ValueChanged<bool?> onChanged;

  const _CheckItem({required this.label, required this.val, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: val ? Colors.blue.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: val ? Colors.blue.shade100 : Colors.transparent)
      ),
      child: CheckboxListTile(
        value: val,
        onChanged: onChanged,
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        activeColor: MedColors.royalBlue,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        checkboxShape: const CircleBorder(),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
          child: Icon(icon, color: MedColors.royalBlue),
        ),
        const SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
