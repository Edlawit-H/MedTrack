import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../services/doctor_service.dart';
import '../../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _doctorService = DoctorService();
  final _authService = AuthService();
  
  Map<String, dynamic>? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await _doctorService.getDoctorProfile();
    final patients = await _doctorService.getAssignedPatients();
    if (mounted) {
      setState(() {
        _profile = data;
        if (_profile != null) {
          _profile!['patients'] = patients;
        }
        _isLoading = false;
      });
    }
  }


  Future<void> _handleLogout() async {
     await _authService.signOut();
     if (mounted) {
       Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedColors.greyBg,
      appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, 
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile & Stats
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'), // Placeholder for now
            ),
            const SizedBox(height: 16),
            Text(
              _profile?['full_name'] ?? "Doctor", 
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: MedColors.textMain)
            ),
            Text(
              _profile?['specialty'] ?? "Specialist", 
              style: const TextStyle(color: MedColors.textSecondary, fontSize: 16)
            ),
            const Text("MedTrack Hospital", style: TextStyle(color: MedColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 30),
            
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const _ProfileStat(value: "8+", label: "YEARS EXP."),
                const SizedBox(height: 40, child: VerticalDivider()),
                _ProfileStat(value: "${_profile?['patients']?.length ?? '24'}", label: "PATIENTS"),
                const SizedBox(height: 40, child: VerticalDivider()),
                const _ProfileStat(value: "5.0", label: "RATING", isRating: true),
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
              child: Column(
                children: [
                   _ContactRow(icon: Icons.email_outlined, label: "Email Address", value: _profile?['email'] ?? "edlawit@gmail.com"),
                   const Divider(height: 30),
                   const _ContactRow(icon: Icons.phone_outlined, label: "Phone Number", value: "+251 911 234 567"),
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
              child: Column(
                children: [
                   _ContactRow(
                     icon: Icons.calendar_today_outlined, 
                     label: _profile?['work_days'] ?? "Mon - Fri", 
                     value: _profile?['work_hours'] ?? "08:00 - 16:00"
                   ),
                   const Divider(height: 30),
                   _ContactRow(
                      icon: Icons.circle, 
                      iconColor: Colors.green, 
                      label: "On-Call Days", 
                      value: _profile?['on_call_days'] ?? "Thursdays"
                    ),
                ],
              ),

            ),

              const SizedBox(height: 20),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/password_change', arguments: false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: MedColors.royalBlue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Change Password", style: TextStyle(color: MedColors.royalBlue, fontWeight: FontWeight.bold)),
                ),
              ),
             const SizedBox(height: 12),
             TextButton.icon(
               onPressed: _handleLogout, 
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
