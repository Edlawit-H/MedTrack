import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../services/patient_service.dart';
import 'package:intl/intl.dart';

class PatientAppointments extends StatefulWidget {
  const PatientAppointments({super.key});

  @override
  State<PatientAppointments> createState() => _PatientAppointmentsState();
}

class _PatientAppointmentsState extends State<PatientAppointments> {
  final _patientService = PatientService();
  List<Map<String, dynamic>> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final data = await _patientService.getAppointments();
    if (mounted) {
      setState(() {
        _appointments = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Appointments", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: _appointments.length,
            itemBuilder: (context, index) {
              final appt = _appointments[index];
              final doctorName = appt['doctors']?['profiles']?['full_name'] ?? 'Doctor';
              final specialty = appt['doctors']?['specialty'] ?? 'General';
              final date = DateTime.parse(appt['scheduled_time']);
              
              final day = DateFormat('dd').format(date);
              final month = DateFormat('MMM').format(date).toUpperCase();
              final time = DateFormat('hh:mm\na').format(date);
              final status = appt['status'] ?? 'scheduled';
              final notes = appt['notes'] ?? '';

              return _ApptCard(
                day: day, 
                month: month, 
                time: time, 
                doctor: doctorName, 
                specialty: "$specialty • $status", 
                loc: "Hospital",
                color: Colors.white
              );
            },
          ),
    );
  }
}

class _ApptCard extends StatelessWidget {
  final String day;
  final String month;
  final String time;
  final String doctor;
  final String specialty;
  final String loc;
  final Color color;

  const _ApptCard({
    required this.day, required this.month, required this.time, 
    required this.doctor, required this.specialty, required this.loc, 
    required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0,4))],
        border: Border.all(color: Colors.grey.shade100)
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Text(month, style: const TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
                    Text(day, style: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(time, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.blue)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(doctor, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                     Text(specialty, style: const TextStyle(color: MedColors.royalBlue, fontSize: 12, fontWeight: FontWeight.bold)),
                   ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
