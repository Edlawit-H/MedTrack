import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/app_colors.dart';
import '../../services/nurse_service.dart';
import 'package:intl/intl.dart';
import 'discharge_screen.dart';

class PatientDetailNurse extends StatefulWidget {
  final Map<String, dynamic> patient;

  const PatientDetailNurse({super.key, required this.patient});

  @override
  State<PatientDetailNurse> createState() => _PatientDetailNurseState();
}

class _PatientDetailNurseState extends State<PatientDetailNurse> {
  final _nurseService = NurseService();
  final _noteController = TextEditingController();
  
  Map<String, dynamic>? _patientDetail;
  List<Map<String, dynamic>> _medications = [];
  List<Map<String, dynamic>> _shiftNotes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    final patientId = widget.patient['id'];
    
    // Fetch profile, meds, and notes in parallel
    final results = await Future.wait([
      _nurseService.getDetailedPatient(patientId),
      _nurseService.getPatientMedicationsWithStatus(patientId),
      _nurseService.getShiftNotes(patientId),
    ]);

    if (mounted) {
      setState(() {
        _patientDetail = results[0] as Map<String, dynamic>?;
        _medications = results[1] as List<Map<String, dynamic>>;
        _shiftNotes = results[2] as List<Map<String, dynamic>>;
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
      if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

  Future<void> _handleMedAction(String prescriptionId, String medName, String action) async {
    try {
      final nurseId = Supabase.instance.client.auth.currentUser!.id;
      await _nurseService.administerMedication(
        prescriptionId: prescriptionId,
        nurseId: nurseId,
        status: action,
        notes: action == 'given' ? "Administered routinely" : "Patient declined or sleeping",
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$medName marked as ${action.toUpperCase()}"), 
          backgroundColor: action == 'given' ? Colors.green : Colors.orange
        ),
      );
      
      _loadAllData(); // Refresh list to show updated status
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    }
  }

  Future<void> _sendNote() async {
    if (_noteController.text.trim().isEmpty) return;
    
    try {
      final nurseId = Supabase.instance.client.auth.currentUser!.id;
      await _nurseService.addShiftNote(
        patientId: widget.patient['id'],
        nurseId: nurseId,
        note: _noteController.text.trim(),
      );
      
      _noteController.clear();
      FocusScope.of(context).unfocus();
      _loadAllData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error adding note: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final detail = _patientDetail ?? widget.patient;
    final name = detail['full_name'] ?? 'Unknown';
    final room = detail['room_number'] ?? '304';
    final bed = detail['bed_number'] ?? 'Bed A';
    final gender = detail['gender'] ?? 'Male';
    final age = _calculateAge(detail['date_of_birth']);
    final doctor = detail['doctors']?['profiles']?['full_name'] ?? 'Dr. Sarah Lin';
    final admittedDate = detail['admission_date'] != null 
        ? DateFormat('MMM dd').format(DateTime.parse(detail['admission_date']))
        : 'Oct 24';
    final allergy = detail['allergies'] ?? 'NONE RECORDED';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.blue), onPressed: () => Navigator.pop(context)),
        title: Column(
          children: [
            Text(name, style: const TextStyle(color: MedColors.textMain, fontSize: 16, fontWeight: FontWeight.bold)),
            Text("Room $room • $bed", style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.more_horiz, color: Colors.grey), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Patient Profile Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))]
              ),
              child: Column(
                children: [
                   Row(
                    children: [
                      Stack(
                        children: [
                          const CircleAvatar(radius: 40, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12')),
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: const Icon(Icons.check_circle, color: Colors.green, size: 20),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: MedColors.textMain)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                                  child: Text("$gender, $age", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.medical_services, size: 14, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text("Dr. $doctor", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month, size: 14, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text("Admitted: $admittedDate", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Allergy Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.red),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("ALLERGY ALERT", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.5)),
                            Text("Patient is allergic to $allergy", style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 2. Medications Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.medication, color: Colors.blue),
                    SizedBox(width: 10),
                    Text("Today's Medications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MedColors.textMain)),
                  ],
                ),
                Text(DateFormat('MMM dd').format(DateTime.now()), style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 20),

            _medications.isEmpty 
              ? const Padding(padding: EdgeInsets.all(20), child: Center(child: Text("No medications scheduled.")))
              : Column(
                  children: _medications.map((med) => _MedicationTimelineItem(
                    time: "12:00", // Would need proper scheduling logic for multi-dose
                    name: med['medications']?['name'] ?? 'Medication',
                    dose: "${med['dosage']} • ${med['medications']?['form']}",
                    instructions: med['instructions'],
                    latestLog: med['latest_log'],
                    onAction: (action) => _handleMedAction(med['id'], med['medications']?['name'], action),
                  )).toList(),
                ),

            const SizedBox(height: 30),

            // 3. Shift Notes Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Row(
                    children: [
                      Icon(Icons.notes, color: Colors.blue),
                      SizedBox(width: 10),
                      Text("Shift Notes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // History of notes (if any)
                  if(_shiftNotes.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: _shiftNotes.take(2).map((sn) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                               const Icon(Icons.circle, size: 6, color: Colors.blue),
                               const SizedBox(width: 8),
                               Expanded(child: Text(sn['note'], style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),

                  Container(
                    decoration: BoxDecoration(color: const Color(0xFFF8F9FE), borderRadius: BorderRadius.circular(16)),
                    child: TextField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Add clinical observations or patient comments...",
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                        contentPadding: const EdgeInsets.all(16),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send, color: Colors.blue),
                          onPressed: _sendNote,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            
            // 4. Discharge Button (Activated)
            InkWell(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DischargeScreen(patient: detail),
                  ),
                );
                if (result == true) {
                  Navigator.pop(context); // Go back to dashboard if discharged
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50, 
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade100)
                ),
                child: const Row(
                  children: [
                    Icon(Icons.logout, color: Colors.blue),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Discharge Patient", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
                          Text("Prepare paperwork and record final status", style: TextStyle(color: Colors.blueGrey, fontSize: 10)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.blue)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _MedicationTimelineItem extends StatelessWidget {
  final String time, name, dose;
  final String? instructions;
  final Map<String, dynamic>? latestLog;
  final Function(String) onAction;

  const _MedicationTimelineItem({
    required this.time,
    required this.name,
    required this.dose,
    this.instructions,
    this.latestLog,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    // Determine status and colors
    String statusText = "UPCOMING";
    Color statusColor = Colors.grey;
    bool isDue = true;
    bool isGiven = false;

    if (latestLog != null) {
      if (latestLog!['status'] == 'given') {
        statusText = "GIVEN";
        statusColor = Colors.green;
        isGiven = true;
        isDue = false;
      } else {
        statusText = "MISSED";
        statusColor = Colors.red;
        isDue = false;
      }
    } else {
       // Logic to check if "DUE NOW" (simulated for midday)
       if (DateTime.now().hour >= 11 && DateTime.now().hour <= 14) {
          statusText = "DUE NOW";
          statusColor = Colors.orange;
       }
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isGiven ? Colors.green.shade50 : (statusText == "DUE NOW" ? Colors.blue.shade50 : Colors.white),
                  shape: BoxShape.circle,
                  border: Border.all(color: isGiven ? Colors.green : (statusText == "DUE NOW" ? Colors.blue : Colors.grey.shade300))
                ),
                child: Icon(
                  isGiven ? Icons.check : (statusText == "DUE NOW" ? Icons.access_time : Icons.access_time),
                  size: 16, 
                  color: isGiven ? Colors.green : (statusText == "DUE NOW" ? Colors.blue : Colors.grey)
                ),
              ),
              const SizedBox(height: 8),
              Text(time, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusText == "DUE NOW" ? Colors.blue : Colors.grey)),
              Expanded(child: Container(width: 1, color: Colors.grey.shade200)),
              const SizedBox(height: 8),
            ],
          ),
          const SizedBox(width: 16),
          // Content Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: statusText == "DUE NOW" ? Border.all(color: Colors.blue.withOpacity(0.3), width: 2) : null,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10)]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: MedColors.textMain)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                        child: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 9, letterSpacing: 0.5)),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(dose, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  if (instructions != null && instructions!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(instructions!, style: const TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)),
                  ],
                  
                  if (isGiven && latestLog != null) ...[
                    const SizedBox(height: 12),
                    Divider(color: Colors.grey.shade100),
                    Row(
                      children: [
                        const Icon(Icons.assignment_ind_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          "Given by ${latestLog!['profiles']?['full_name']} at ${DateFormat('hh:mm a').format(DateTime.parse(latestLog!['administered_at']))}",
                          style: const TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      ],
                    ),
                  ],

                  if (statusText == "DUE NOW") ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.medication, size: 16),
                            label: const Text("Give Now"),
                            onPressed: () => onAction('given'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00A67E), // Green from UI
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 12)
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
                          child: IconButton(
                            icon: const Icon(Icons.block, color: Colors.red, size: 18),
                            onPressed: () => onAction('missed'),
                            tooltip: "Mark Missed",
                          ),
                        )
                      ],
                    )
                  ]
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
