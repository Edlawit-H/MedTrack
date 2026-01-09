import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class NursePatientDetails extends StatelessWidget {
  const NursePatientDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Column(
          children: [
            Text("John Doe", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            Text("Room 304   • Bed A", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.more_horiz))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
                ]
              ),
              child: Row(
                children: [
                  const CircleAvatar(radius: 30, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12')),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("John Doe", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Row(
                           children: [
                             Icon(Icons.person, size: 14, color: Colors.grey),
                             SizedBox(width: 4),
                             Text("Dr. Sarah Lin", style: TextStyle(color: Colors.grey, fontSize: 12)),
                           ],
                        ),
                        Row(
                           children: [
                             Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                             SizedBox(width: 4),
                             Text("Admitted: Oct 24", style: TextStyle(color: Colors.grey, fontSize: 12)),
                           ],
                        )
                      ],
                    ),
                  ),
                  Text("Male, 54", style: TextStyle(color: MedColors.royalBlue, fontWeight: FontWeight.bold))
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Allergy Alert
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade100)
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("ALLERGY ALERT", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10)),
                        Text("Patient is allergic to PENICILLIN", style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Today's Meds
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Today's Medications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Oct 26", style: TextStyle(color: Colors.grey))
              ],
            ),
            const SizedBox(height: 20),

            // Timeline
            _TimelineItem(
              time: "08:00",
              status: "GIVEN",
              statusColor: MedColors.nursePrimary,
              medName: "Metoprolol",
              subtitle: "Given by M. Johnson at 8:02 AM",
              isCompleted: true,
            ),
             _TimelineItem(
              time: "12:00",
              status: "DUE NOW",
              statusColor: Colors.orange,
              medName: "Insulin Aspart",
              subtitle: "10 units • Subcutaneous (SubQ)\nCheck blood glucose before",
              isActive: true,
              onTap: () => Navigator.pushNamed(context, '/nurse_med_admin'),
            ),
             _TimelineItem(
              time: "20:00",
              status: "UPCOMING",
              statusColor: Colors.grey,
              medName: "Atorvastatin",
              subtitle: "20mg • Oral",
            ),
            
            const SizedBox(height: 20),
            // Shift Notes
            const Text("Shift Notes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Add clinical observations or patient comments...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: MedColors.royalBlue, shape: BoxShape.circle),
                  child: const Icon(Icons.send, color: Colors.white, size: 16),
                )
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 30),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/nurse_discharge'),
                icon: const Icon(Icons.exit_to_app),
                label: const Text("Discharge Patient"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey,
                  side: const BorderSide(color: Colors.grey),
                  padding: const EdgeInsets.symmetric(vertical: 16)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String time;
  final String status;
  final Color statusColor;
  final String medName;
  final String subtitle;
  final bool isCompleted;
  final bool isActive;
  final VoidCallback? onTap;

  const _TimelineItem({
    required this.time,
    required this.status,
    required this.statusColor,
    required this.medName,
    required this.subtitle,
    this.isCompleted = false,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Time Column
          Column(
            children: [
              Text(time, style: TextStyle(fontWeight: FontWeight.bold, color: isActive ? MedColors.royalBlue : Colors.grey)),
            ],
          ),
          const SizedBox(width: 16),
          // Line Column
          Column(
            children: [
              Container(
                width: 12, height: 12,
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : (isCompleted ? MedColors.nursePrimary : Colors.grey.shade300),
                  shape: BoxShape.circle,
                  border: isActive ? Border.all(color: MedColors.royalBlue, width: 3) : null
                ),
              ),
              Expanded(child: Container(width: 2, color: Colors.grey.shade200))
            ],
          ),
          const SizedBox(width: 16),
          // Content Card
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: isActive ? Border.all(color: MedColors.royalBlue, width: 2) : null,
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(medName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    
                    if(isActive) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: onTap,
                              style: ElevatedButton.styleFrom(backgroundColor: MedColors.nursePrimary),
                              child: const Text("Give Now", style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 10),
                           Expanded(
                            child: OutlinedButton(
                              onPressed: (){},
                              style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
                              child: const Text("Mark Missed"),
                            ),
                          )
                        ],
                      )
                    ]
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
