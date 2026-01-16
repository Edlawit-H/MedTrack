import 'package:flutter/material.dart';
import 'package:medtrack/services/nurse_service.dart';
import '../../core/app_colors.dart';
import '../../screens/nurse/nurse_profile.dart';
import 'patient_detail_nurse.dart';
import 'nurse_schedule.dart'; // Added Import

class WardDashboard extends StatefulWidget {
  const WardDashboard({super.key});

  @override
  State<WardDashboard> createState() => _WardDashboardState();
}

class _WardDashboardState extends State<WardDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _WardHome(),
    const NurseSchedule(), // Replaced Placeholder
    const NurseProfile(showBackButton: false),
  ];

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: MedColors.nursePrimary,
          unselectedItemColor: Colors.grey.shade400,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: "Schedule"),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "Profile"),
          ],
        ),
      ),
    );
  }
}

class _WardHome extends StatefulWidget {
  const _WardHome();

  @override
  State<_WardHome> createState() => _WardHomeState();
}

class _WardHomeState extends State<_WardHome> {
  final _nurseService = NurseService();
  
  Map<String, dynamic>? _nurseProfile;
  List<Map<String, dynamic>> _patients = [];
  Map<String, int> _stats = {'due': 0, 'done': 0, 'attended': 0};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final profile = await _nurseService.getNurseProfile();
    final patients = await _nurseService.getWardPatients();
    final stats = await _nurseService.getWardStats();
    
    if (mounted) {
      setState(() {
        _nurseProfile = profile;
        _patients = patients;
        _stats = stats;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final nurseName = _nurseProfile?['full_name'] ?? 'Nurse';
    final wardId = _nurseProfile?['ward_id'] ?? 'Unknown Ward';
    final department = _nurseProfile?['department'] ?? 'General';

    return Column(
        children: [
          // Custom Header
          Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
            decoration: const BoxDecoration(
              color: MedColors.nursePrimary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5')), // Placeholder Pic
                        const SizedBox(width: 10),
                        Text(nurseName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))

                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                Text(wardId.toLowerCase().contains('ward') ? wardId : "Ward $wardId", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                Text(department, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 30),

                // Stats Row
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                       _WardStat(value: "${_stats['attended']}", label: "ATTENDED", color: Colors.black),
                       _WardStat(value: "${_stats['due']}", label: "DUE", color: Colors.orange),
                       _WardStat(value: "${_stats['done']}", label: "DONE", color: MedColors.nursePrimary),
                    ],
                  ),
                )
              ],
            ),
          ),
          
          Expanded(
            child: _patients.isEmpty
              ? const Center(child: Text("No patients assigned."))
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: _patients.length,
                  itemBuilder: (context, index) {
                    final patient = _patients[index];
                    return _PatientMedCard(
                      room: "Room ${patient['room_number'] ?? '304'} • ${patient['bed_number'] ?? 'Bed A'}", 
                      status: "Stable", 
                      statusColor: Colors.blue,
                      name: patient['full_name'] ?? "Unknown", 
                      time: "Now", 
                      med: "View Details", 
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PatientDetailNurse(patient: patient),
                          ),
                        ).then((_) => _loadData());
                      },
                    );
                  },
                ),
          ),
        ],
      );
  }
}

class _WardStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _WardStat({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
      ],
    );
  }
}

class _PatientMedCard extends StatelessWidget {
  final String room;
  final String status;
  final Color statusColor;
  final String name;
  final String time;
  final String med;
  final bool isUpcoming;
  final VoidCallback onTap;

  const _PatientMedCard({
    required this.room, 
    required this.status, 
    required this.statusColor, 
    required this.name, 
    required this.time, 
    required this.med, 
    this.isUpcoming = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Row(
                   children: [
                     Icon(Icons.meeting_room_outlined, size: 16, color: Colors.grey[600]),
                     const SizedBox(width: 4),
                     Text(room, style: const TextStyle(fontWeight: FontWeight.bold, color: MedColors.textMain)),
                   ],
                 ),
                 Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10)),
              ],
            ),
            const SizedBox(height: 12),
            Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MedColors.textMain)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: statusColor),
                const SizedBox(width: 8),
                Text("$time - $med", style: const TextStyle(color: MedColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                   backgroundColor: isUpcoming ? Colors.white : const Color(0xFF304FFE), // Blue from design
                   foregroundColor: isUpcoming ? Colors.grey : Colors.white,
                   elevation: isUpcoming ? 0 : 4,
                   side: isUpcoming ? const BorderSide(color: Colors.grey) : BorderSide.none,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                   padding: const EdgeInsets.symmetric(vertical: 14)
                ),
                child: Text(isUpcoming ? "Upcoming" : "View Details", style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
