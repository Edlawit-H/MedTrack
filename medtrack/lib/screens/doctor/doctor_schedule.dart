import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../core/app_colors.dart';
import '../../services/doctor_service.dart';
import 'add_appointment_modal.dart';

class DoctorSchedule extends StatefulWidget {
  const DoctorSchedule({super.key});

  @override
  State<DoctorSchedule> createState() => _DoctorScheduleState();
}

class _DoctorScheduleState extends State<DoctorSchedule> {
  final _doctorService = DoctorService();
  
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  
  List<Map<String, dynamic>> _allAppointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final data = await _doctorService.getAppointments();
    if (mounted) {
      setState(() {
        _allAppointments = data;
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getAppointmentsForDay(DateTime day) {
    return _allAppointments.where((appt) {
      final apptDate = DateTime.parse(appt['scheduled_time']);
      return isSameDay(apptDate, day);
    }).toList();
  }

  void _showAddAppointment() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddAppointmentModal(),
    );

    if (result == true) {
      _loadAppointments(); // Refresh list
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysAppointments = _getAppointmentsForDay(_selectedDay);

    return Scaffold(
      backgroundColor: MedColors.greyBg,
      appBar: AppBar(
        title: const Text("My Schedule", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: MedColors.drPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 20),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: MedColors.drPrimary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: MedColors.drEnd,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                decoration: BoxDecoration(color: Colors.white), 
              ),
            ),
          ),
          
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : daysAppointments.isEmpty 
                ? const Center(child: Text("No appointments for this day."))
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: daysAppointments.length,
                    itemBuilder: (context, index) {
                      final appt = daysAppointments[index];
                      final date = DateTime.parse(appt['scheduled_time']);
                      final timeStr = DateFormat('hh:mm a').format(date);
                      final patientName = appt['patients']?['full_name'] ?? 'Unknown';
                      
                      return _TimelineTile(
                        time: timeStr,
                        name: patientName,
                        type: appt['status']?.toUpperCase() ?? 'SCHEDULED', // Using status as type/tag for now
                        color: Colors.blue, // Could vary color by status
                        duration: "30 min",
                        notes: appt['notes'],
                      );
                    },
                  ),
          ),
        ],
      ),
       floatingActionButton: FloatingActionButton(
        backgroundColor: MedColors.drPrimary,
        onPressed: _showAddAppointment,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final String time, name, type, duration;
  final String? notes;
  final Color color;
  
  const _TimelineTile({
    required this.time,
    required this.name,
    required this.type,
    required this.color,
    this.duration = "30 min",
    this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: MedColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 2,
                height: 60,
                color: Colors.grey.withOpacity(0.3),
              )
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border(left: BorderSide(color: color, width: 4)),
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
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: Text(type, style: const TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                   const SizedBox(height: 4),
                  Row(
                    children: [
                       const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(duration, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                  if (notes != null && notes!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(notes!, style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 12)),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
