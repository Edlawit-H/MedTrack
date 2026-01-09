import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/app_colors.dart';

class DoctorSchedule extends StatefulWidget {
  const DoctorSchedule({super.key});

  @override
  State<DoctorSchedule> createState() => _DoctorScheduleState();
}

class _DoctorScheduleState extends State<DoctorSchedule> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
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
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                decoration: BoxDecoration(color: Colors.white), 
              ),
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: const [
                Text("Today's Appointments", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: MedColors.textMain)),
                SizedBox(height: 16),
                _TimelineTile(
                  time: "09:00 AM",
                  name: "John Doe",
                  type: "Follow-up Visit",
                  color: Colors.blue,
                  duration: "30 min",
                ),
                _TimelineTile(
                  time: "10:30 AM",
                  name: "Jane Smith",
                  type: "Initial Consultation",
                  color: Colors.green,
                  isNew: true,
                  duration: "45 min",
                ),
                _TimelineTile(
                  time: "01:00 PM",
                  name: "Michael Brown",
                  type: "Routine Check-up",
                  color: Colors.orange,
                  duration: "15 min",
                ),
                 _TimelineTile(
                  time: "02:30 PM",
                  name: "Sarah Jenkins",
                  type: "Emergency Review",
                  color: Colors.red,
                  duration: "20 min",
                ),
              ],
            ),
          ),
        ],
      ),
       floatingActionButton: FloatingActionButton(
        backgroundColor: MedColors.drPrimary,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final String time, name, type, duration;
  final Color color;
  final bool isNew;
  const _TimelineTile({
    required this.time,
    required this.name,
    required this.type,
    required this.color,
    this.duration = "30 min",
    this.isNew = false,
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
                      if (isNew)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: const Text("NEW", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                        )
                    ],
                  ),
                   const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.medical_services_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(type, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(width: 12),
                       Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(duration, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
