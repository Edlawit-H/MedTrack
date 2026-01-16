import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../services/patient_service.dart';
import '../../services/auth_service.dart';
import 'package:intl/intl.dart';


class PatientProfile extends StatefulWidget {
  const PatientProfile({super.key});

  @override
  State<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  final _patientService = PatientService();
  final _authService = AuthService();
  Map<String, dynamic>? _profile;
  List<Map<String, dynamic>> _meds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final profile = await _patientService.getPatientProfile();
    final meds = await _patientService.getPrescriptions();
    
    if (mounted) {
      setState(() {
        _profile = profile;
        _meds = meds;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    // Extract Data safely
    final fullName = _profile?['full_name'] ?? 'Guest';
    final mrn = _profile?['mrn'] ?? 'N/A';
    final dobString = _profile?['date_of_birth'];
    
    // Calculate Age
    String age = "N/A";
    String dobFormatted = "N/A";
    if (dobString != null) {
      final dob = DateTime.parse(dobString);
      dobFormatted = DateFormat('MMM dd, yyyy').format(dob);
      final now = DateTime.now();
      final years = now.year - dob.year;
      age = "$years Yrs";
    }

    final doctorName = _profile?['doctors']?['profiles']?['full_name'] ?? 'Not Assigned';    
    final doctorSpecialty = _profile?['doctors']?['specialty'] ?? 'General';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: const [
          SizedBox(width: 20)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'), // Generic avatar
            ),
            const SizedBox(height: 12),
            Text(fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("MRN: $mrn", style: const TextStyle(color: Colors.grey, fontSize: 12)),
            
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TagP(label: "Active Patient", color: Colors.green),
              ],
            ),
            
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                 _InfoCol(label: "DATE OF BIRTH", value: dobFormatted),
                 Container(height: 30, width: 1, color: Colors.grey.shade300),
                 _InfoCol(label: "AGE", value: age),
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
              child: ListTile(
                leading: const CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5')),
                title: Text(doctorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text("$doctorSpecialty\nMedTrack Hospital", style: const TextStyle(fontSize: 12)),
                trailing: const CircleAvatar(backgroundColor: Color(0xFFE8EAF6), child: Icon(Icons.call, color: MedColors.royalBlue, size: 18)),
              ),
            ),
            
             const SizedBox(height: 24),
             
             // My Medications
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 const _SectionHeader(title: "My Medications", icon: Icons.medication),
                 Text("${_meds.length} Active", style: TextStyle(color: Colors.blue.shade700, fontSize: 11, fontWeight: FontWeight.bold))
               ],
             ),
             const SizedBox(height: 12),

             _meds.isEmpty 
               ? const Text("No active medications.", style: TextStyle(color: Colors.grey))
               : Column(
                  children: _meds.map((m) {
                    final name = m['medications']?['name'] ?? 'Medication';
                    final dose = m['dosage'] ?? '';
                    final freq = m['frequency'] ?? '';
                    return _MedRow(name: name, dose: dose, next: freq);
                  }).toList(),
               ),
             
             const SizedBox(height: 24),
             
             // Medical Info
             const _SectionHeader(title: "Medical Information", icon: Icons.info_outline),
             const SizedBox(height: 10),
             const Align(alignment: Alignment.centerLeft, child: Text("DETAILS", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))),
             const SizedBox(height: 6),
              // Dummy tags for now as allergies aren't in DB yet
             const Row(children: [_TagP(label: "Routine Checkup", color: Colors.blue)]),
             
             const SizedBox(height: 30),
             
             // Preferences
             const _SectionHeader(title: "Preferences", icon: Icons.settings),
             const SwitchListTile(value: true, onChanged: null, title: Text("Push Notifications", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), subtitle: Text("Receive alerts on lock screen", style: TextStyle(fontSize: 11))),
             
             const SizedBox(height: 30),
             TextButton.icon(
                onPressed: () async {
                   await _authService.signOut();
                   if (mounted) Navigator.pushReplacementNamed(context, '/'); 
                }, 
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
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
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
              const Text("Frequency", style: TextStyle(color: Colors.grey, fontSize: 9)),
              Text(next, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
            ],
          )
        ],
      ),
    );
  }
}
