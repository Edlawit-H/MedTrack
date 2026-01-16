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

  Future<void> _handleAction(String prescriptionId, String status) async {
    setState(() => _isLoading = true);
    final success = await _patientService.logMedicationAction(
      prescriptionId: prescriptionId,
      status: status,
    );
    if (success) {
      await _loadData();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update medication status'), backgroundColor: Colors.red),
        );
      }
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text("Medication Portal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            children: [
              _buildSectionHeader("Today", "Next Doses"),
              ..._buildUpcomingItems(),
              const SizedBox(height: 30),
              _buildSectionHeader("History", "Past Records"),
              ..._buildHistoryItems(),
            ],
          ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: MedColors.textMain)),
          const SizedBox(width: 8),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }

  List<Widget> _buildUpcomingItems() {
    if (_prescriptions.isEmpty) {
      return [const Padding(padding: EdgeInsets.all(24), child: _EmptyState(text: "No active prescriptions."))];
    }
    return _prescriptions.map((med) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _MedCard(
          id: med['id'],
          name: med['medications']?['name'] ?? 'Medication',
          dosage: "${med['dosage']} • ${med['strength'] ?? ''}",
          time: med['frequency'] ?? 'As prescribed',
          instruction: med['instructions'] ?? '',
          isUpcoming: true,
          onTake: () => _handleAction(med['id'], 'taken'),
          onMiss: () => _handleAction(med['id'], 'missed'),
        ),
      );
    }).toList();
  }

  List<Widget> _buildHistoryItems() {
    if (_history.isEmpty) {
      return [const Padding(padding: EdgeInsets.all(24), child: _EmptyState(text: "No history found."))];
    }

    // Grouping logic
    final groups = <String, List<Map<String, dynamic>>>{};
    for (var log in _history) {
      final date = DateTime.parse(log['administered_at']);
      final now = DateTime.now();
      String dateKey;
      
      if (date.year == now.year && date.month == now.month && date.day == now.day) {
        dateKey = "Today";
      } else if (date.year == now.year && date.month == now.month && date.day == now.day - 1) {
        dateKey = "Yesterday";
      } else {
        dateKey = DateFormat('EEEE, MMM dd').format(date);
      }
      
      groups.putIfAbsent(dateKey, () => []).add(log);
    }

    final items = <Widget>[];
    groups.forEach((day, logs) {
      items.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
          child: Text(day, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
        )
      );
      for (var log in logs) {
        final med = log['prescriptions']?['medications'];
        final time = DateTime.parse(log['administered_at']);
        final status = log['status'] ?? 'taken';
        
        items.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _MedCard(
              id: log['id'],
              name: med?['name'] ?? 'Medication',
              dosage: "${log['prescriptions']?['dosage'] ?? ''}",
              time: DateFormat('hh:mm a').format(time),
              instruction: log['notes'] ?? 'Status: $status',
              isHistory: true,
              isMissed: status == 'missed',
            ),
          )
        );
      }
    });

    return items;
  }

}

class _MedCard extends StatelessWidget {
  final String id, name, dosage, time, instruction;
  final bool isUpcoming;
  final bool isHistory;
  final bool isMissed;
  final VoidCallback? onTake;
  final VoidCallback? onMiss;

  const _MedCard({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.instruction,
    this.isUpcoming = false,
    this.isHistory = false,
    this.isMissed = false,
    this.onTake,
    this.onMiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isMissed ? Colors.red.withValues(alpha: 0.1) : (isUpcoming ? MedColors.patPrimary.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1)),
                  shape: BoxShape.circle
                ),
                child: Icon(
                  isMissed ? Icons.close : (isUpcoming ? Icons.medication : Icons.check_circle),
                  color: isMissed ? Colors.red : (isUpcoming ? MedColors.patPrimary : Colors.green),
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
          if (isUpcoming) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onMiss,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Missed"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onTake,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MedColors.patPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text("Take Now"),
                  ),
                ),
              ],
            )
          ]
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
