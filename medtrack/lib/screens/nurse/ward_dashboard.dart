import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'package:medtrack/screens/nurse/nurse_profile.dart';

class WardDashboard extends StatefulWidget {
  const WardDashboard({super.key});

  @override
  State<WardDashboard> createState() => _WardDashboardState();
}

class _WardDashboardState extends State<WardDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _WardHome(),
    const Center(child: Text("Schedule (Coming Soon)")), // Placeholder
    const Center(child: Text("Chat (Coming Soon)")), // Placeholder
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
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded), label: "Chat"),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "Settings"),
          ],
        ),
      ),
    );
  }
}

class _WardHome extends StatelessWidget {
  const _WardHome();

  @override
  Widget build(BuildContext context) {
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
                    const Row(
                      children: [
                        CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5')), // Nurse Pic
                        SizedBox(width: 10),
                        Text("Nurse: Mary Johnson", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                      ],
                    ),
                    IconButton(
                      onPressed: () {}, // Can be used for notifications
                      icon: const Icon(Icons.notifications_none, color: Colors.white)
                    )
                  ],
                ),
                const SizedBox(height: 24),
                
                const Text("Ward 3A", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const Text("General Medicine", style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 30),

                // Stats Row
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                       _WardStat(value: "12", label: "PATIENTS", color: Colors.black),
                       _WardStat(value: "5", label: "DUE", color: Colors.orange),
                       _WardStat(value: "18", label: "DONE", color: MedColors.nursePrimary),
                    ],
                  ),
                )
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                 _PatientMedCard(
                   room: "Room 304", 
                   status: "OVERDUE", 
                   statusColor: Colors.red,
                   name: "John Doe", 
                   time: "09:00 AM", 
                   med: "Insulin", 
                   onTap: () => Navigator.pushNamed(context, '/nurse_patient_details'),
                 ),
                 _PatientMedCard(
                   room: "Room 305", 
                   status: "DUE SOON", 
                   statusColor: Colors.orange,
                   name: "Jane Smith", 
                   time: "10:00 AM", 
                   med: "Amoxicillin", 
                   onTap: () => Navigator.pushNamed(context, '/nurse_patient_details'),
                 ),
                 _PatientMedCard(
                   room: "Room 306", 
                   status: "ON TIME", 
                   statusColor: Colors.green,
                   name: "Robert Brown", 
                   time: "02:00 PM", 
                   med: "Paracetamol", 
                   isUpcoming: true,
                   onTap: () => Navigator.pushNamed(context, '/nurse_patient_details'),
                 ),
              ],
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                   backgroundColor: isUpcoming ? Colors.white : const Color(0xFF304FFE), // Blue from design
                   foregroundColor: isUpcoming ? Colors.grey : Colors.white,
                   elevation: isUpcoming ? 0 : 4,
                   side: isUpcoming ? const BorderSide(color: Colors.grey) : BorderSide.none,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                   padding: const EdgeInsets.symmetric(vertical: 14)
                ),
                child: Text(isUpcoming ? "Upcoming" : "Give Medication", style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
