import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'patient_appointments.dart';
import 'patient_profile.dart'; 
import 'medication_reminder.dart';
import '../../services/patient_service.dart';
import '../../services/notification_service.dart';
import 'package:intl/intl.dart';
import 'dart:async';


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
    const MedicationReminder(),
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
             BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -5))
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

class _PatientHome extends StatefulWidget {
  const _PatientHome();

  @override
  State<_PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<_PatientHome> {
  final _patientService = PatientService();
  final _notificationService = NotificationService();
  
  Map<String, dynamic>? _profile;
  List<Map<String, dynamic>> _prescriptions = [];
  bool _isLoading = true;
  Timer? _medicationCheckTimer;
  final Set<String> _notifiedMeds = {}; // Prevent double-notifying in same minute


  @override
  void initState() {
    super.initState();
    _initializeApp();
    _startMedicationTimer();
  }

  void _startMedicationTimer() {
    _medicationCheckTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) _checkReminders();
    });
  }

  void _checkReminders() {
    final now = DateTime.now();
    final currentTimeStr = DateFormat('HH:mm').format(now);

    for (var med in _prescriptions) {
      final name = med['medications']?['name'] ?? 'Medication';
      final freq = (med['frequency'] ?? '').toString().toLowerCase();
      final medKey = "${med['id']}_$currentTimeStr";

      if (_notifiedMeds.contains(medKey)) continue;

      // Simple time matching logic for demo
      bool isMatch = false;
      if (freq.contains('morning') && currentTimeStr == "09:00") isMatch = true;
      if (freq.contains('evening') && currentTimeStr == "21:00") isMatch = true;
      if (currentTimeStr == "09:00") isMatch = true; // Default match for 9AM

      if (isMatch) {
         _notificationService.showInstantAlert(
           context, 
           title: "Medication Reminder", 
           body: "It's time to take your $name"
         );
         _notifiedMeds.add(medKey);
      }
    }
  }

  @override
  void dispose() {
    _medicationCheckTimer?.cancel();
    super.dispose();
  }


  Future<void> _initializeApp() async {
    await _initNotifications();
    await _loadData();
  }
  
  Future<void> _initNotifications() async {
    await _notificationService.init();
    await _notificationService.requestPermissions();
  }

    List<Map<String, dynamic>> _appointments = [];
  List<Map<String, dynamic>> _history = [];

  Future<void> _loadData() async {
    final profile = await _patientService.getPatientProfile();
    final meds = await _patientService.getPrescriptions();
    final appointments = await _patientService.getAppointments();
    final history = await _patientService.getMedicationHistory();
    
    // Schedule Reminders
    _scheduleReminders(meds);
    
    if (mounted) {
      setState(() {
        _profile = profile;
        _prescriptions = meds;
        _appointments = appointments;
        _history = history;
        _isLoading = false;
      });
    }
  }
  
  Future<void> _scheduleReminders(List<Map<String, dynamic>> meds) async {
    // Clear old reminders to avoid duplicates
    await _notificationService.cancelAll();
    
    for (var med in meds) {
      final name = med['medications']?['name'] ?? 'Medication';
      final freq = (med['frequency'] ?? '').toString().toLowerCase();
      final instructions = med['instructions'] ?? 'Time to take your $name';
      final medId = med['id'].hashCode; // Unique base ID for this medication

      List<TimeOfDay> schedule = [];

      // Logic for parsing frequencies
      if (freq.contains('twice') || freq.contains('bid') || freq.contains('12 hours')) {
        schedule = [const TimeOfDay(hour: 9, minute: 0), const TimeOfDay(hour: 21, minute: 0)];
      } else if (freq.contains('thrice') || freq.contains('tid') || freq.contains('8 hours')) {
        schedule = [
          const TimeOfDay(hour: 9, minute: 0), 
          const TimeOfDay(hour: 14, minute: 0), 
          const TimeOfDay(hour: 21, minute: 0)
        ];
      } else if (freq.contains('four') || freq.contains('qid') || freq.contains('6 hours')) {
        schedule = [
          const TimeOfDay(hour: 8, minute: 0), 
          const TimeOfDay(hour: 12, minute: 0), 
          const TimeOfDay(hour: 16, minute: 0), 
          const TimeOfDay(hour: 20, minute: 0)
        ];
      } else if (freq.contains('morning') && freq.contains('evening')) {
        schedule = [const TimeOfDay(hour: 8, minute: 30), const TimeOfDay(hour: 20, minute: 30)];
      } else if (freq.contains('morning')) {
        schedule = [const TimeOfDay(hour: 8, minute: 30)];
      } else if (freq.contains('evening') || freq.contains('night')) {
        schedule = [const TimeOfDay(hour: 20, minute: 30)];
      } else {
        // Default: Once daily at 9 AM
        schedule = [const TimeOfDay(hour: 9, minute: 0)];
      }

      // Schedule all times for this med
      await _notificationService.scheduleMultipleDailyNotifications(
        baseId: medId,
        title: 'Heads up: Time for $name',
        body: instructions,
        times: schedule,
      );
    }
    print("DEBUG: Scheduled reminders for ${meds.length} medications with a total of ${meds.fold(0, (sum, m) => sum + 1)} entries.");
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    final name = _profile?['full_name'] ?? 'Patient';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text("Hello, $name!", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: MedColors.textMain)),
                   const Text("Welcome back", style: TextStyle(color: Colors.grey)),
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
          _buildDailyProgress(),
          const SizedBox(height: 24),

          // Quick Actions (Navigation)
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Switch to the appointments tab or navigate
                    Navigator.pushNamed(context, '/patient_appointments');
                  },
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
                  onTap: () {
                    // Logic to switch tab would be better, but for now we can navigate
                    Navigator.pushNamed(context, '/patient_profile');
                  },
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

           // Active Medications List
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               const Text("My Medications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
               Text(DateFormat('MMM dd').format(DateTime.now()), style: const TextStyle(color: Colors.grey, fontSize: 12)),
             ],
           ),
           const SizedBox(height: 16),

           _prescriptions.isEmpty 
             ? const Center(child: Text("No active medications found."))
             : Column(
                children: _prescriptions.map((p) {
                   final medName = p['medications']?['name'] ?? 'Unknown';
                   final dose = p['dosage'] ?? '';
                   final freq = p['frequency'] ?? '';
                   // Create a simple status flow. For now show "Active"
                   return _MedItem(
                     time: freq, 
                     name: medName, 
                     dose: dose, 
                     status: _MedStatus.upcoming // Assume upcoming for all for now
                   );
                }).toList(),
              ),
            ],
          ),
        );
      }

  Widget _buildDailyProgress() {
    final int totalMeds = _prescriptions.length;
    // For MVP, we'll count logs from 'today' as 'Taken'
    final today = DateTime.now();
    final takenToday = _history.where((log) {
      final logDate = DateTime.parse(log['administered_at']);
      return logDate.year == today.year && logDate.month == today.month && logDate.day == today.day;
    }).length;

    final double percent = totalMeds > 0 ? (takenToday / totalMeds) : 0;
    final int displayPercent = (percent * 100).round();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("DAILY PROGRESS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                const SizedBox(height: 8),
                Text("$totalMeds Meds", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text("Active Schedule", style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Text("$takenToday Taken", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green))
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 100, width: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 35,
                    startDegreeOffset: -90,
                    sections: [
                      PieChartSectionData(color: MedColors.patPrimary, value: percent > 0 ? percent : 0.001, showTitle: false, radius: 8),
                      PieChartSectionData(color: Colors.grey.shade200, value: (1 - percent) > 0 ? (1 - percent) : 0.001, showTitle: false, radius: 8),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("$displayPercent%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: MedColors.textMain)),
                    const Text("Done", style: TextStyle(color: Colors.grey, fontSize: 8)),
                  ],
                )
              ],
            ),
          )
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
    
    // Simplification for MVP
    if(status == _MedStatus.upcoming) {
      // Keep blue/grey
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.05), blurRadius: 10)]
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(time, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: MedColors.textMain)),
                 Text(dose, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Icon(icon, color: iconColor)
        ],
      ),
    );
  }
}
