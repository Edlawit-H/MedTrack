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
                    final form = med['medications']?['form'] ?? '';
                    final dose = med['dosage'] ?? '';
                    final freq = med['frequency'] ?? 'Daily';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                        ]
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: MedColors.nursePrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child: Column(
                              children: [
                                Text(freq, style: const TextStyle(fontWeight: FontWeight.bold, color: MedColors.nursePrimary, fontSize: 12)),
                                const Text("ACTIVE", style: TextStyle(fontSize: 10, color: MedColors.nursePrimary, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("$patientName ($room)", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text("$medName $dose", style: const TextStyle(fontSize: 14)),
                                Text(form, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey)
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
