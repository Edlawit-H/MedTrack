import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class PatientAppointments extends StatelessWidget {
  const PatientAppointments({super.key});

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
        actions: const [
          Icon(Icons.notifications, color: Colors.black),
          SizedBox(width: 16)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             // Calendar Strip (Simplified Visual)
             Padding(
               padding: const EdgeInsets.all(20.0),
               child: Column(
                 children: [
                   const Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Icon(Icons.chevron_left),
                       Text("October 2023", style: TextStyle(fontWeight: FontWeight.bold)),
                       Icon(Icons.chevron_right),
                     ],
                   ),
                   const SizedBox(height: 20),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     children: ["S","M","T","W","T","F","S"].map((e) => Text(e, style: const TextStyle(color: Colors.grey, fontSize: 12))).toList(),
                   ),
                   const SizedBox(height: 10),
                   // Dummy Week Row
                    Row(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     children: List.generate(7, (index) {
                       bool isSelected = index == 2; // e.g. 12th
                       return Container(
                         width: 30, height: 30,
                         alignment: Alignment.center,
                         decoration: BoxDecoration(
                           color: isSelected ? const Color(0xFF304FFE) : Colors.transparent,
                           shape: BoxShape.circle
                         ),
                         child: Text("${10 + index}", style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: isSelected?FontWeight.bold:FontWeight.normal)),
                       );
                     }),
                   ),
                 ],
               ),
             ),
             
             Container(color: Colors.grey.shade100, height: 8),

             Padding(
               padding: const EdgeInsets.all(24),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Row(
                     children: [
                       const Text("Upcoming", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                       const SizedBox(width: 8),
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                         decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(8)),
                         child: const Text("2", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 10)),
                       )
                     ],
                   ),
                   const SizedBox(height: 20),
                   
                   _ApptCard(
                     day: "12", month: "OCT", time: "10:30\nAM", 
                     doctor: "Dr. Sarah Jenkins", 
                     specialty: "Cardiology Checkup", 
                     loc: "City General Hospital, Room 304",
                     color: const Color(0xFF304FFE)
                   ),
                   _ApptCard(
                     day: "15", month: "OCT", time: "02:00\nPM", 
                     doctor: "Dr. Mark Lee", 
                     specialty: "Follow-up Consultation", 
                     loc: "North Wing Clinic, Suite 12",
                     color: Colors.white
                   ),
                   _ApptCard(
                     day: "20", month: "OCT", time: "09:15\nAM", 
                     doctor: "Radiology Center", 
                     specialty: "MRI Scan", 
                     loc: "Main Hospital, B1",
                     color: Colors.white,
                     isLab: true,
                   ),

                 ],
               ),
             )
          ],
        ),
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
  final bool isLab;

  const _ApptCard({
    required this.day, required this.month, required this.time, 
    required this.doctor, required this.specialty, required this.loc, 
    required this.color, this.isLab = false});

  @override
  Widget build(BuildContext context) {
    bool isDark = color != Colors.white;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0,4))],
        border: isDark ? null : Border.all(color: Colors.grey.shade100)
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
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(doctor, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                         CircleAvatar(radius: 12, backgroundImage: NetworkImage(isLab ? 'https://i.pravatar.cc/150?img=33' : 'https://i.pravatar.cc/150?img=5'))
                       ],
                     ),
                     Text(specialty, style: const TextStyle(color: MedColors.royalBlue, fontSize: 12, fontWeight: FontWeight.bold)),
                     const SizedBox(height: 8),
                     Row(
                       children: [
                         const Icon(Icons.location_on, size: 14, color: Colors.grey),
                         const SizedBox(width: 4),
                         Expanded(child: Text(loc, style: const TextStyle(color: Colors.grey, fontSize: 11)))
                       ],
                     )
                   ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: (){}, 
              icon: const Icon(Icons.calendar_today, size: 16),
              label: const Text("Add to Calendar"),
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white : Colors.black,
                backgroundColor: isDark ? color : Colors.white,
                side: isDark ? BorderSide.none : const BorderSide(color: Colors.grey),
              ),
            ),
          )
        ],
      ),
    );
  }
}
