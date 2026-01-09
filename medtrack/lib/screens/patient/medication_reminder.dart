import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class MedicationReminder extends StatelessWidget {
  const MedicationReminder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedColors.patBg,
      appBar: AppBar(
        title: const Text("My Medications", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _MedReminderCard(
            name: "Metformin",
            dosage: "500mg • 1 pill",
            time: "08:00 AM",
            instruction: "Take with food",
            isTaken: true,
          ),
          _MedReminderCard(
            name: "Lisinopril",
            dosage: "10mg • 1 pill",
            time: "08:00 AM",
            instruction: "Take with water",
            isTaken: true,
          ),
          _MedReminderCard(
            name: "Metformin",
            dosage: "500mg • 1 pill",
            time: "01:00 PM",
            instruction: "Take with food",
            isNext: true,
          ),
           _MedReminderCard(
            name: "Atorvastatin",
            dosage: "20mg • 1 pill",
            time: "08:00 PM",
            instruction: "Before bed",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: MedColors.patPrimary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _MedReminderCard extends StatelessWidget {
  final String name, dosage, time, instruction;
  final bool isTaken;
  final bool isNext;

  const _MedReminderCard({
    required this.name,
    required this.dosage,
    required this.time,
    required this.instruction,
    this.isTaken = false,
    this.isNext = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isNext ? MedColors.patPrimary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
           BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ]
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isNext ? Colors.white.withOpacity(0.2) : MedColors.patPrimary.withOpacity(0.1),
              shape: BoxShape.circle
            ),
            child: Icon(
              isTaken ? Icons.check : Icons.medication,
              color: isNext ? Colors.white : MedColors.patPrimary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isNext ? Colors.white : MedColors.textMain)),
                Text("$dosage • $instruction", style: TextStyle(color: isNext ? Colors.white70 : Colors.grey)),
              ],
            ),
          ),
          Column(
            children: [
              Text(time, style: TextStyle(fontWeight: FontWeight.bold, color: isNext ? Colors.white : MedColors.textMain)),
              if(!isTaken)
              Switch(value: isTaken, onChanged: (v){}, activeColor: Colors.white)
            ],
          )
        ],
      ),
    );
  }
}
