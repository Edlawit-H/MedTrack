import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/doctor_service.dart';
import 'add_prescription_modal.dart';

class PatientProfileDr extends StatefulWidget {
  const PatientProfileDr({super.key});

  @override
  State<PatientProfileDr> createState() => _PatientProfileDrState();
}

class _PatientProfileDrState extends State<PatientProfileDr> {
  final _doctorService = DoctorService();
  Map<String, dynamic>? _patientData;
  List<Map<String, dynamic>> _prescriptions = [];
  List<Map<String, dynamic>> _appointments = [];
  Map<String, dynamic> _adherenceStats = {'rate': 0, 'taken': 0, 'missed': 0, 'total': 0};
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_patientData == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        _patientData = args;
        _loadAllData();
      }
    }
  }

  Future<void> _loadAllData() async {
    if (_patientData == null) return;
    
    setState(() => _isLoading = true);
    
    final results = await Future.wait([
      _doctorService.getPatientPrescriptions(_patientData!['id']),
      _doctorService.getPatientAdherence(_patientData!['id']),
      // Mocking appointments for now or can fetch if service has it
      Future.value([
        {'date': '2026-10-24', 'time': '09:30 AM', 'notes': 'Regular BP Checkup & Medication Review'},
        {'date': '2026-11-15', 'time': '02:00 PM', 'notes': 'Follow-up: Cardiology'}
      ]),
    ]);
    
    if (mounted) {
      setState(() {
        _prescriptions = results[0] as List<Map<String, dynamic>>;
        _adherenceStats = results[1] as Map<String, dynamic>;
        _appointments = results[2] as List<Map<String, dynamic>>;
        _isLoading = false;
      });
    }
  }

  int _calculateAge(String? dobString) {
    if (dobString == null) return 0;
    try {
      final dob = DateTime.parse(dobString);
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) age--;
      return age;
    } catch (e) { return 0; }
  }

  void _showAddPrescription() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddPrescriptionModal(patientId: _patientData!['id']),
    );
    if (result == true) _loadAllData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_patientData == null) return const Scaffold(body: Center(child: Text("No Patient Data")));

    final age = _calculateAge(_patientData!['date_of_birth']);
    final bloodType = _patientData!['blood_type'] ?? 'O Positive';
    final condition = _patientData!['medical_condition'] ?? 'General Checkup';
    final allergies = _patientData!['allergies'] ?? 'NONE RECORDED';
    final notes = _patientData!['doctor_notes'] ?? 'No observations recorded.';
    final room = _patientData!['stay_type'] == 'inpatient' 
        ? "${_patientData!['room_number']}-${_patientData!['bed_number']}"
        : "Outpatient";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text("Patient Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1. Patient Information Main Card
            _buildSectionCard(
              title: "Patient Information",
              icon: Icons.person,
              trailing: const Icon(Icons.edit, color: Colors.blue, size: 20),
              child: Column(
                children: [
                   Row(
                    children: [
                      CircleAvatar(radius: 35, backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=${_patientData!['id']}")),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_patientData!['full_name'] ?? "Jane Doe", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("ID: #${_patientData!['id'].toString().substring(0, 6).toUpperCase()}", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoTile("AGE", "$age Years"),
                      _buildInfoTile("BLOOD TYPE", bloodType),
                    ],
                  ),
                  const SizedBox(height: 16),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoTile("ROOM", room),
                      _buildInfoTile("EMAIL", _patientData!['email'] ?? "N/A"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSubLabel("MEDICAL CONDITION"),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                      child: Text(condition, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSubLabel("⚠️ ALLERGIES", color: Colors.red),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Text(allergies, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  const SizedBox(height: 20),
                  _buildSubLabel("EMERGENCY CONTACT"),
                  const SizedBox(height: 8),
                  Align(alignment: Alignment.centerLeft, child: Text(_patientData!['emergency_contact'] ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                  const SizedBox(height: 20),
                  _buildSubLabel("DOCTOR NOTES"),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
                    child: Text(notes, style: const TextStyle(color: Colors.black87, fontSize: 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Medication Adherence Card
            _buildSectionCard(
              title: "Medication Adherence",
              icon: Icons.show_chart,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${_adherenceStats['rate']}%", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                        child: const Text("Excellent", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11)),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _adherenceStats['rate'] / 100,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Align(alignment: Alignment.centerRight, child: Text("Last 30 Days", style: TextStyle(color: Colors.grey, fontSize: 11))),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildStatBox("Taken", "${_adherenceStats['taken']}", Colors.green),
                      const SizedBox(width: 12),
                      _buildStatBox("Missed", "${_adherenceStats['missed']}", Colors.red),
                      const SizedBox(width: 12),
                      _buildStatBox("Total", "${_adherenceStats['total']}", Colors.blue),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Medications Card
            _buildSectionCard(
              title: "Medications",
              icon: Icons.medication,
              trailing: TextButton.icon(
                onPressed: _showAddPrescription,
                icon: const Icon(Icons.add, size: 16),
                label: const Text("Add", style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(backgroundColor: Colors.blue.shade50, padding: const EdgeInsets.symmetric(horizontal: 12)),
              ),
              child: Column(
                children: _prescriptions.isEmpty 
                  ? [const Text("No medications added.")]
                  : _prescriptions.map((p) => _buildMedEntry(p)).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // 4. Scheduled Checkups Card
            _buildSectionCard(
              title: "Scheduled Checkups",
              icon: Icons.calendar_today,
              trailing: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(backgroundColor: Colors.blue.shade50, padding: const EdgeInsets.symmetric(horizontal: 12)),
                child: const Text("Schedule", style: TextStyle(fontSize: 12)),
              ),
              child: Column(
                children: _appointments.map((a) => _buildCheckupEntry(a)).toList(),
              ),
            ),
            const SizedBox(height: 30),

            // 5. Bottom Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.message_outlined, size: 20),
                    label: const Text("Message"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                   child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.call, size: 20, color: Colors.white),
                    label: const Text("Call Patient", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, Widget? trailing, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                if (trailing != null) trailing,
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildSubLabel(String label, {Color color = Colors.grey}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
    );
  }

  Widget _buildStatBox(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
             Row(mainAxisAlignment: MainAxisAlignment.center, children: [
               Icon(Icons.check_circle, size: 12, color: color),
               const SizedBox(width: 4),
               Text(count, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
             ]),
             Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildMedEntry(Map<String, dynamic> med) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade100), borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(med['medications']?['name'] ?? 'Med', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text("${med['dosage']} • ${med['frequency']}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text("Adherence: ", style: TextStyle(fontSize: 11, color: Colors.grey)),
              const Text("96%", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
              const Spacer(),
              Row(children: [
                const Icon(Icons.check, size: 10, color: Colors.green),
                const Text(" 24", style: TextStyle(fontSize: 10, color: Colors.grey)),
                const SizedBox(width: 8),
                const Icon(Icons.close, size: 10, color: Colors.red),
                const Text(" 1", style: TextStyle(fontSize: 10, color: Colors.grey)),
              ])
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(value: 0.96, minHeight: 4, backgroundColor: Color(0xFFF0F0F0), valueColor: AlwaysStoppedAnimation(Colors.green)),
          )
        ],
      ),
    );
  }

  Widget _buildCheckupEntry(Map<String, dynamic> appt) {
    final date = DateTime.parse(appt['date']);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade100), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                Text(DateFormat('MMM').format(date).toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue)),
                Text(DateFormat('dd').format(date), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(appt['time'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(appt['notes'], style: const TextStyle(color: Colors.grey, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const Icon(Icons.close, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
