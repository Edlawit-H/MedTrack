import 'package:flutter/material.dart';
import '../../core/app_colors.dart'; // Two levels up to core

class PatientAppointments extends StatelessWidget {
  const PatientAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedColors.patBg,
      appBar: AppBar(title: const Text("My Appointments"), centerTitle: true),
      body: Column(
        children: [
          _buildCalendarStrip(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  "Upcoming",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 15),
                _aptCard(
                  "Oct 12",
                  "Dr. Sarah Jenkins",
                  "Cardiology Checkup",
                  "City General Hospital",
                ),
                _aptCard(
                  "Oct 15",
                  "Dr. Mark Lee",
                  "Follow-up Consultation",
                  "North Wing Clinic",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarStrip() => Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [Text("M"), Text("T"), Text("W"), Text("T"), Text("F")],
    ),
  );

  Widget _aptCard(String date, String doc, String type, String loc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: MedColors.drPrimary.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              date,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: MedColors.drPrimary,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  type,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  loc,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
