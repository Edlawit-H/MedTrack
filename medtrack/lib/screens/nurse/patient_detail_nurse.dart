import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/primary_button.dart';

class PatientDetailNurse extends StatelessWidget {
  const PatientDetailNurse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedColors.greyBg,
      appBar: AppBar(
        title: const Text("John Doe", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: MedColors.nursePrimary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Patient Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                 boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                ]
              ),
              child: const Row(
                children: [
                  CircleAvatar(radius: 30, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12')),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text("John Doe", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                       Text("Room 304 • ID: #PT304", style: TextStyle(color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Allergy Alert
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.3))
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red),
                  SizedBox(width: 12),
                  Text(
                    "ALLERGY ALERT: PENICILLIN",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today's Medications",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: MedColors.textMain),
              ),
            ),
            const SizedBox(height: 16),
            
            _MedTile(
              time: "09:00",
              name: "Insulin Aspart",
              dose: "10 Units • Subcutaneous (Sub-Q)",
              status: "Due Now",
              isDue: true,
              onTap: () => Navigator.pushNamed(context, '/med_action'),
            ),
            _MedTile(
              time: "13:00",
              name: "Metformin",
              dose: "500mg • Oral",
              status: "Upcoming",
              isDue: false,
               onTap: (){},
            ),
             _MedTile(
              time: "20:00",
              name: "Atorvastatin",
              dose: "20mg • Oral",
              status: "Upcoming",
              isDue: false,
               onTap: (){},
            ),
            
            const SizedBox(height: 40),
            PrimaryButton(
              text: "Initiate Discharge",
              color: Colors.grey, // Disabled look or secondary action
              onTap: () {}, // => Navigator.pushNamed(context, '/discharge_screen'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MedTile extends StatelessWidget {
  final String time, name, dose, status;
  final bool isDue;
  final VoidCallback onTap;

  const _MedTile({
    required this.time,
    required this.name,
    required this.dose,
    required this.status,
    required this.isDue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
       decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
         boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              children: [
                Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Text("AM", style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
            const SizedBox(width: 16),
            Container(height: 40, width: 2, color: Colors.grey.shade100),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(dose, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            if(isDue)
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: MedColors.nursePrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0)
              ),
              child: const Text("Give", style: TextStyle(color: Colors.white)),
            )
            else
             Container(
               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
               decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
               child: Text(status, style: const TextStyle(fontSize: 10, color: Colors.grey)),
             )
          ],
        ),
      ),
    );
  }
}
