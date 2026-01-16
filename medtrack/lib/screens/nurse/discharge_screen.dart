import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../services/nurse_service.dart';

class DischargeScreen extends StatefulWidget {
  final Map<String, dynamic> patient;
  const DischargeScreen({super.key, required this.patient});

  @override
  State<DischargeScreen> createState() => _DischargeScreenState();
}

class _DischargeScreenState extends State<DischargeScreen> {
  final _nurseService = NurseService();
  bool isProtocol1 = true;
  bool isProtocol2 = true;
  bool isProtocol3 = true;
  bool isProtocol4 = false;
  bool _isLoading = false;

  Future<void> _completeDischarge() async {
    setState(() => _isLoading = true);
    try {
      await _nurseService.dischargePatient(widget.patient['id']);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Patient Discharged Successfully"), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true); // Return true to signal refresh
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.patient['full_name'] ?? 'Unknown';
    final room = widget.patient['room_number'] ?? 'N/A';
    final id = widget.patient['id'].toString().substring(0, 8);

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
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                     Row(children: [const Icon(Icons.meeting_room, size: 14, color: Colors.grey), const SizedBox(width: 4), Text("Room $room • ID #$id", style: const TextStyle(color: Colors.grey))]),
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
                 const _ActionIcon(icon: Icons.mobile_screen_share, label: "Send to\nApp"),
                 const _ActionIcon(icon: Icons.email, label: "Email\nPDF"),
                 const _ActionIcon(icon: Icons.print, label: "Print\nSummary"),
               ],
             ),

             const SizedBox(height: 50),
             
             const Text("Discharge recording follows\nHospital Discharge Policy", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
             const SizedBox(height: 20),
             
              SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _completeDischarge,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MedColors.nursePrimary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(_isLoading) const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    else ...[
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 8),
                      const Text("Complete Discharge", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ]
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
