import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'patient_appointments.dart';
import 'patient_profile.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _PatientHome(),
    const PatientAppointments(),
    const Center(child: Text("Medications (Coming Soon)")), // Placeholder for Meds Tab
    const PatientProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
             BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))
          ]
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedItemColor: MedColors.patPrimary,
          unselectedItemColor: Colors.grey.shade400,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Schedule"),
            BottomNavigationBarItem(icon: Icon(Icons.medication), label: "Meds"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}

class _PatientHome extends StatelessWidget {
  const _PatientHome();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               const Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text("Hello, John!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: MedColors.textMain)),
                   Text("Welcome back", style: TextStyle(color: Colors.grey)),
                 ],
               ),
               const CircleAvatar(
                 backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
                 radius: 20,
               )
            ],
          ),
          const SizedBox(height: 30),

          // Daily Progress Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))]
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("DAILY PROGRESS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                      const SizedBox(height: 8),
                      const Text("3 of 5", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const Text("Medications taken", style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.timer_outlined, size: 16, color: Colors.green),
                            SizedBox(width: 8),
                            Text("NEXT DOSE\n2 hours (10:00 AM)", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 80, width: 80,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(value: 0.6, strokeWidth: 8, backgroundColor: Colors.grey.shade100, color: MedColors.patPrimary),
                      const Center(child: Text("60%", style: TextStyle(fontWeight: FontWeight.bold)))
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick Actions
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/patient_appointments'),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: const Column(
                      children: [
                        Icon(Icons.calendar_month, color: Colors.blue),
                        SizedBox(height: 10),
                        Text("View Schedule", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/patient_profile'),
                   child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: const Column(
                      children: [
                        Icon(Icons.person, color: Colors.purple),
                         SizedBox(height: 10),
                        Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
           const SizedBox(height: 30),

           // Today's Medications
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               const Text("Today's Medications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
               const Text("Oct 24", style: TextStyle(color: Colors.grey, fontSize: 12)),
             ],
           ),
           const SizedBox(height: 16),

           const _MedItem(time: "08:00\nAM", name: "Amoxicillin", dose: "500mg • 1 Tablet", status: _MedStatus.taken),
           const _MedItem(time: "10:00\nAM", name: "Ibuprofen", dose: "200mg • 1 Tablet", status: _MedStatus.upcoming),
           const _MedItem(time: "01:00\nPM", name: "Vitamin D3", dose: "1000 IU • 1 Softgel", status: _MedStatus.taken),
           const _MedItem(time: "02:00\nPM", name: "Lisinopril", dose: "10mg • 1 Tablet", status: _MedStatus.upcoming),
           const _MedItem(time: "07:00\nAM", name: "Morning Aspirin", dose: "Missed", status: _MedStatus.missed),

        ],
      ),
    );
  }
}

enum _MedStatus { taken, upcoming, missed }

class _MedItem extends StatelessWidget {
  final String time;
  final String name;
  final String dose;
  final _MedStatus status;

  const _MedItem({required this.time, required this.name, required this.dose, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.white;
    Color iconColor = Colors.grey.shade300;
    IconData icon = Icons.circle_outlined;
    
    if(status == _MedStatus.taken) {
      iconColor = Colors.green;
      icon = Icons.check_circle;
    } else if (status == _MedStatus.missed) {
      bg = Colors.red.shade50;
      iconColor = Colors.red;
      icon = Icons.cancel;
    }

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/patient_med_reminder'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: status == _MedStatus.missed ? [] : [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)]
        ),
        child: Row(
          children: [
            Text(time, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: status == _MedStatus.missed ? Colors.red : Colors.grey)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: status == _MedStatus.missed ? Colors.red : MedColors.textMain)),
                   Text(dose, style: TextStyle(fontSize: 12, color: status == _MedStatus.missed ? Colors.red.shade300 : Colors.grey)),
                ],
              ),
            ),
            Icon(icon, color: iconColor)
          ],
        ),
      ),
    );
  }
}
