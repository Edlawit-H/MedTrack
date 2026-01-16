import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

import '../../services/patient_service.dart';
import 'package:intl/intl.dart';

class MedicationReminder extends StatefulWidget {
  const MedicationReminder({super.key});

  @override
  State<MedicationReminder> createState() => _MedicationReminderState();
}

class _MedicationReminderState extends State<MedicationReminder> {
  final _patientService = PatientService();
  List<Map<String, dynamic>> _prescriptions = [];
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final meds = await _patientService.getPrescriptions();
    final hist = await _patientService.getMedicationHistory();
    if (mounted) {
      setState(() {
        _prescriptions = meds;
        _history = hist;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FE),
        appBar: AppBar(
          title: const Text("Medication Portal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            labelColor: MedColors.patPrimary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: MedColors.patPrimary,
            tabs: [
              Tab(text: "Upcoming"),
              Tab(text: "Taken History"),
            ],
          ),
        ),
        body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              children: [
                _buildUpcomingList(),
                _buildHistoryList(),
              ],
            ),
      ),
    );
  }

  Widget _buildUpcomingList() {
    if (_prescriptions.isEmpty) return const _EmptyState(text: "No active prescriptions.");
    
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _prescriptions.length,
      itemBuilder: (context, index) {
        final med = _prescriptions[index];
        return _MedCard(
          name: med['medications']?['name'] ?? 'Medication',
          dosage: "${med['dosage']} • ${med['strength'] ?? ''}",
          time: med['frequency'] ?? 'As prescribed',
          instruction: med['instructions'] ?? '',
          isUpcoming: true,
        );
      },
    );
  }

  Widget _buildHistoryList() {
    if (_history.isEmpty) return const _EmptyState(text: "No medication history found.");

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final log = _history[index];
        final med = log['prescriptions']?['medications'];
        final date = DateTime.parse(log['administered_at']);
        
        return _MedCard(
          name: med?['name'] ?? 'Medication',
          dosage: "${log['prescriptions']?['dosage'] ?? ''}",
          time: DateFormat('MMM dd, hh:mm a').format(date),
          instruction: log['notes'] ?? 'Dose taken successfully',
          isHistory: true,
        );
      },
    );
  }
}

class _MedCard extends StatelessWidget {
  final String name, dosage, time, instruction;
  final bool isUpcoming;
  final bool isHistory;

  const _MedCard({
    required this.name,
    required this.dosage,
    required this.time,
    required this.instruction,
    this.isUpcoming = false,
    this.isHistory = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUpcoming ? MedColors.patPrimary.withOpacity(0.1) : Colors.green.withOpacity(0.1),
              shape: BoxShape.circle
            ),
            child: Icon(
              isUpcoming ? Icons.medication : Icons.check_circle,
              color: isUpcoming ? MedColors.patPrimary : Colors.green,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: MedColors.textMain)),
                const SizedBox(height: 4),
                Text(dosage, style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500)),
                if (instruction.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(instruction, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ),
              ],
            ),
          ),
          Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: MedColors.patPrimary)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;
  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(text, style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }
}
