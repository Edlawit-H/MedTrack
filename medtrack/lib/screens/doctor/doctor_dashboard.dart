import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/custom_textfield.dart';
import 'patients_screen.dart';
import 'doctor_schedule.dart';
import 'settings_screen.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _DashboardHome(),
    const DoctorSchedule(),
    const Center(child: Text("Chat Screen (Coming Soon)")), // Placeholder for Chat
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE), // Light blue-ish grey
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
          selectedItemColor: MedColors.royalBlue,
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
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/doctor_add_patient'),
              backgroundColor: MedColors.royalBlue,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _DashboardHome extends StatelessWidget {
  const _DashboardHome();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom Header with Search
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 240,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
              decoration: const BoxDecoration(
                color: MedColors.royalBlue,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Dashboard",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                        child: const Icon(Icons.notifications_none, color: Colors.white),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text("Good Morning,", style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text("Dr. Smith", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Positioned(
              bottom: -25,
              left: 24,
              right: 24,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Search patients, medications...",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 40),

        // Main Content
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            children: [
              // Stats Row
              const Row(
                children: [
                  Expanded(child: _StatCard(value: "24", label: "Total Patients", icon: Icons.people_outline, isSelected: false)),
                  SizedBox(width: 12),
                  Expanded(child: _StatCard(value: "8", label: "Appointments", icon: Icons.calendar_today, isSelected: true)), // Blue card
                  SizedBox(width: 12),
                  Expanded(child: _StatCard(value: "3", label: "Surgeries", icon: Icons.medical_services_outlined, isSelected: false)),
                ],
              ),
              const SizedBox(height: 30),

              // Your Patients Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Your Patients", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MedColors.textMain)),
                  TextButton(
                    onPressed: () {}, // Navigate to Patients tab via logic if needed, or just view all
                    child: const Text("View All", style: TextStyle(color: MedColors.royalBlue)),
                  )
                ],
              ),
              const SizedBox(height: 10),
              
              _PatientListItem(
                name: "Sarah Jenkins",
                id: "Age 45",
                tag: "HYPERTENSION",
                tagColor: Colors.orange,
                image: "https://i.pravatar.cc/150?img=5",
                onTap: () => Navigator.pushNamed(context, '/doctor_patient_profile'),
              ),
              _PatientListItem(
                name: "Michael Ross",
                id: "Age 32",
                tag: "DIABETES",
                tagColor: Colors.redAccent,
                image: "https://i.pravatar.cc/150?img=8",
                onTap: () => Navigator.pushNamed(context, '/doctor_patient_profile'),
              ),
               _PatientListItem(
                name: "Emily Blunt",
                id: "Age 28",
                tag: "CHECKUP",
                tagColor: Colors.green,
                image: "https://i.pravatar.cc/150?img=9",
                onTap: () => Navigator.pushNamed(context, '/doctor_patient_profile'),
              ),
               _PatientListItem(
                name: "David Kim",
                id: "Age 35",
                tag: "FLU",
                tagColor: Colors.blue,
                image: "https://i.pravatar.cc/150?img=11",
                onTap: () => Navigator.pushNamed(context, '/doctor_patient_profile'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final bool isSelected;

  const _StatCard({required this.value, required this.label, required this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: isSelected ? MedColors.royalBlue : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
           if(!isSelected) BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
        ]
      ),
      child: Column(
        children: [
          Icon(icon, color: isSelected ? Colors.white : MedColors.royalBlue, size: 28),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : MedColors.textMain)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white70 : MedColors.textSecondary), textAlign: TextAlign.center, maxLines: 1),
        ],
      ),
    );
  }
}

class _PatientListItem extends StatelessWidget {
  final String name;
  final String id;
  final String tag;
  final Color tagColor;
  final String image;
  final VoidCallback onTap;

  const _PatientListItem({
    required this.name,
    required this.id,
    required this.tag,
    required this.tagColor,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))
        ]
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(image),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(id, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: tagColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(tag, style: TextStyle(color: tagColor, fontWeight: FontWeight.bold, fontSize: 10)),
        ),
        onTap: onTap,
      ),
    );
  }
}


