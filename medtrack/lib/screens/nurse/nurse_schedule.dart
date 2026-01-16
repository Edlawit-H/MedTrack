import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../services/nurse_service.dart';

class NurseSchedule extends StatefulWidget {
  const NurseSchedule({super.key});

  @override
  State<NurseSchedule> createState() => _NurseScheduleState();
}

class _NurseScheduleState extends State<NurseSchedule> {
  final _nurseService = NurseService();
  List<Map<String, dynamic>> _medications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    final meds = await _nurseService.getWardMedications();
     if (mounted) {
      setState(() {
        _medications = meds;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text("Ward Schedule", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _medications.isEmpty
              ? const Center(child: Text("No upcoming medications."))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _medications.length,
                  itemBuilder: (context, index) {
                    final med = _medications[index];
                    final patientName = med['patients']?['full_name'] ?? 'Unknown';
                    final room = med['patients']?['room_number'] ?? 'No Room';
                    final medName = med['medications']?['name'] ?? 'Unknown Med';
                    final dose = med['dosage'] ?? '';
                    final freq = med['frequency'] ?? 'Daily';

                    // Inferred time for demo visibility
                    String timeStr = "09:00"; 
                    if (freq.toLowerCase().contains('noon') || freq.toLowerCase().contains('day')) timeStr = "12:00";
                    if (freq.toLowerCase().contains('evening') || freq.toLowerCase().contains('night')) timeStr = "20:00";
                    if (freq.toLowerCase().contains('twice')) timeStr = "09:00, 21:00";

                    // Logic to determine status for today
                    final logs = List<Map<String, dynamic>>.from(med['medication_logs'] ?? []);
                    final today = DateTime.now();
                    final todayStatus = logs.where((l) {
                      final date = DateTime.parse(l['administered_at']);
                      return date.year == today.year && date.month == today.month && date.day == today.day;
                    }).firstOrNull?['status'] ?? 'upcoming';

                    Color statusColor = Colors.orange;
                    IconData statusIcon = Icons.access_time_rounded;
                    if (todayStatus == 'taken') {
                      statusColor = MedColors.nursePrimary;
                      statusIcon = Icons.check_circle_rounded;
                    } else if (todayStatus == 'missed') {
                      statusColor = Colors.red;
                      statusIcon = Icons.error_rounded;
                    }

                    return GestureDetector(
                      onTap: todayStatus != 'upcoming' ? null : () => _showActionDialog(context, med),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                          ],
                          border: todayStatus != 'upcoming' 
                            ? Border.all(color: statusColor.withOpacity(0.2), width: 1)
                            : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(statusIcon, color: statusColor, size: 20),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        timeStr, 
                                        style: TextStyle(fontWeight: FontWeight.bold, color: statusColor, fontSize: 14)
                                      ),
                                      const Text("  -  ", style: TextStyle(color: Colors.grey)),
                                      Expanded(
                                        child: Text(
                                          "$medName ($dose)", 
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: MedColors.textMain),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "$patientName • Room $room", 
                                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            if (todayStatus == 'upcoming')
                              const Icon(Icons.more_vert, color: Colors.grey, size: 20)
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  todayStatus.toUpperCase(),
                                  style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showActionDialog(BuildContext context, Map<String, dynamic> med) {
    final medName = med['medications']?['name'] ?? 'Medication';
    final patientName = med['patients']?['full_name'] ?? 'Patient';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(medName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Administer to $patientName", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateStatus(med['id'], 'taken'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MedColors.nursePrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text("Mark as Taken", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _updateStatus(med['id'], 'missed'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text("Mark as Missed", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _updateStatus(String prescriptionId, String status) async {
    Navigator.pop(context); // Close sheet
    setState(() => _isLoading = true);

    try {
      final user = _nurseService.getCurrentUser();
      if (user != null) {
        await _nurseService.administerMedication(
          prescriptionId: prescriptionId, 
          nurseId: user.id, 
          status: status
        );
      }
      await _loadSchedule();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
      setState(() => _isLoading = false);
    }
  }
}


