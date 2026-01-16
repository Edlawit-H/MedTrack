import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../services/nurse_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/notification_service.dart';


class NurseProfile extends StatefulWidget {
  final bool showBackButton;
  const NurseProfile({super.key, this.showBackButton = true});

  @override
  State<NurseProfile> createState() => _NurseProfileState();
}

class _NurseProfileState extends State<NurseProfile> {
  final _nurseService = NurseService();
  Map<String, dynamic>? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await _nurseService.getNurseProfile();
     if (mounted) {
      setState(() {
        _profile = data;
        _isLoading = false;
      });
    }
  }
  
  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        // Navigate to Landing
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final name = _profile?['full_name'] ?? 'Nurse';
    final email = _profile?['email'] ?? 'nurse@hospital.org';
    final ward = _profile?['ward_id'] ?? 'Unknown';
    final shift = _profile?['shift'] ?? 'Day';
    final dept = _profile?['department'] ?? 'General';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : SingleChildScrollView(
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
                      widget.showBackButton 
                          ? IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white))
                          : const SizedBox(width: 24), 
                      const Text("My Profile", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 48), // Balanced space instead of settings icon
                    ],
                  ),
                  const SizedBox(height: 24),
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
                  ),
                   const SizedBox(height: 12),
                   Text("$name, RN", style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                   const SizedBox(height: 4),
                   Text(ward.toLowerCase().contains('ward') ? "$ward • $dept" : "Ward $ward • $dept", style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Stats (Cleaned up: Only Shift from DB)
            Padding(
               padding: const EdgeInsets.symmetric(horizontal: 24),
               child: Container(
                 padding: const EdgeInsets.all(20),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(20),
                   boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)]
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     _ProfileStat(value: shift, label: "CURRENT SHIFT", icon: Icons.wb_sunny, color: Colors.orange),
                     _ProfileStat(value: dept, label: "DEPARTMENT", icon: Icons.local_hospital, color: Colors.blue),
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
                  const Text("Account Information", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 10),
                   _InfoTile(icon: Icons.email, title: email, subtitle: "Work Email"),
                   
                   const SizedBox(height: 20),
                   _InfoTile(
                     icon: Icons.lock_outline, 
                     title: "Change Password", 
                     subtitle: "Security Settings",
                     onTap: () => Navigator.pushNamed(context, '/password_change', arguments: false), 
                   ),

                   const SizedBox(height: 40),
                   
                   Center(
                     child: TextButton.icon(
                       onPressed: () {
                         NotificationService().showInstantAlert(
                           context, 
                           title: "Shift Update", 
                           body: "Solomon (A-102) is due for Metoprolol (25mg) immediately."
                         );
                       },
                       icon: const Icon(Icons.notifications_active, color: MedColors.nursePrimary),
                       label: const Text("Test Banner Alert", style: TextStyle(color: MedColors.nursePrimary, fontWeight: FontWeight.bold)),
                     ),
                   ),

                   const SizedBox(height: 10),
                   Center(
                     child: TextButton.icon(
                       onPressed: _signOut, 
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
  final VoidCallback? onTap;

  const _InfoTile({required this.icon, required this.title, required this.subtitle, this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100)
        ),
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
