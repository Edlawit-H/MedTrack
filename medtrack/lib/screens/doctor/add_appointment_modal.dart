import 'package:flutter/material.dart';
import '../../services/doctor_service.dart';
import '../../core/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/custom_textfield.dart';
import 'package:intl/intl.dart';

class AddAppointmentModal extends StatefulWidget {
  const AddAppointmentModal({super.key});

  @override
  State<AddAppointmentModal> createState() => _AddAppointmentModalState();
}

class _AddAppointmentModalState extends State<AddAppointmentModal> {
  final _formKey = GlobalKey<FormState>();
  final _doctorService = DoctorService();
  
  bool _isLoading = false;
  List<Map<String, dynamic>> _patients = [];
  String? _selectedPatientId;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  
  final _typeController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    final patients = await _doctorService.getAssignedPatients();
    if (mounted) {
      setState(() {
        _patients = patients;
      });
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _saveAppointment() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPatientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a patient'), backgroundColor: Colors.red));
      return;
    }
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select date and time'), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);

    // Combine Date and Time
    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final error = await _doctorService.addAppointment(
      patientId: _selectedPatientId!,
      date: dateTime,
      type: _typeController.text.trim(),
      notes: _notesController.text.trim(),
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (error == null) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment scheduled successfully'), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _typeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = _selectedDate == null ? "Select Date" : DateFormat('MMM dd, yyyy').format(_selectedDate!);
    String formattedTime = _selectedTime == null ? "Select Time" : _selectedTime!.format(context);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Schedule Appointment",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: MedColors.textMain),
              ),
              const SizedBox(height: 20),
              
              // Patient Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Select Patient",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                initialValue: _selectedPatientId,
                items: _patients.map((p) {
                  return DropdownMenuItem(
                    value: p['id'] as String,
                    child: Text(p['full_name'] ?? "Unknown"),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedPatientId = val),
              ),
              const SizedBox(height: 16),
              
              // Date & Time Row
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _selectDate,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(formattedDate),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: _selectTime,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(formattedTime),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _typeController,
                label: "Type of Visit",
                hint: "e.g. Follow-up, Consultation",
                prefixIcon: Icons.medical_services,
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _notesController,
                label: "Notes (Optional)",
                hint: "Any pre-visit notes",
                prefixIcon: Icons.notes,
              ),
              
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: _isLoading ? "Scheduling..." : "Schedule",
                  onTap: _isLoading ? () {} : _saveAppointment,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
