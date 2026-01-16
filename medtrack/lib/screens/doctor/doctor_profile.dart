import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../services/doctor_service.dart';


class DoctorProfile extends StatefulWidget {
  const DoctorProfile({super.key});

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  final DoctorService _doctorService = DoctorService();
  Map<String, dynamic>? _profile;
  List<Map<String, dynamic>>? _patients;
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _doctorService.getDoctorProfile();
    final patients = await _doctorService.getAssignedPatients();
    if (mounted) {
      setState(() {
        _profile = profile;
        _patients = patients;
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final String name = _profile?['full_name'] ?? "Doctor";
    final String specialty = _profile?['specialty'] ?? "Specialist";
    final String email = _profile?['email'] ?? "No email provided";
    final String workDays = _profile?['work_days'] ?? "Mon - Fri";
    final String workHours = _profile?['work_hours'] ?? "08:00 - 16:00";
    final String onCall = _profile?['on_call_days'] ?? "N/A";

    return Scaffold(
      backgroundColor: MedColors.greyBg,
      appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: MedColors.drPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: MedColors.drPrimary.withValues(alpha: 0.1),
              child: Text(
                name.isNotEmpty ? name[0] : "D",
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: MedColors.drPrimary),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              specialty,
              style: const TextStyle(
                color: MedColors.drPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Dr. Edlawit Medical Center", // Updated to fit persona
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ProfileStat(label: "Patients", value: "${_patients?.length ?? 0}"),
                const _ProfileStat(label: "Rating", value: "4.8 ★"),
              ],
            ),

            const SizedBox(height: 30),
            _buildInfoSection("CONTACT INFORMATION", [
              _InfoTile(
                icon: Icons.email_outlined,
                label: "Email Address",
                value: email,
              ),
              const _InfoTile(
                icon: Icons.business_outlined,
                label: "Department",
                value: "Cardiology Unit",
              ),
            ]),
            const SizedBox(height: 20),
            _buildInfoSection("WORK SCHEDULE", [
              _InfoTile(
                icon: Icons.calendar_today_outlined,
                label: workDays,
                value: workHours,
              ),
              _InfoTile(
                icon: Icons.access_time_outlined,
                label: "On-Call Days",
                value: onCall,
              ),
            ]),
            const SizedBox(height: 30),
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
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))
            ]
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
