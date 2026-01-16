import 'package:flutter/material.dart';
import '../../services/doctor_service.dart';
import '../../core/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/custom_textfield.dart';

class AddPrescriptionModal extends StatefulWidget {
  final String patientId;

  const AddPrescriptionModal({super.key, required this.patientId});

  @override
  State<AddPrescriptionModal> createState() => _AddPrescriptionModalState();
}

class _AddPrescriptionModalState extends State<AddPrescriptionModal> {
  final _formKey = GlobalKey<FormState>();
  final _doctorService = DoctorService();
  
  bool _isLoading = false;
  List<Map<String, dynamic>> _medications = [];
  String? _selectedMedicationId;
  
  final _dosageController = TextEditingController();
  final _freqController = TextEditingController();
  final _durationController = TextEditingController();
  final _instructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    final meds = await _doctorService.getAvailableMedications();
    if (mounted) {
      setState(() {
        _medications = meds;
      });
    }
  }

  bool _isCustomMed = false;
  final _customMedNameController = TextEditingController();
  final _customMedFormController = TextEditingController();

  Future<void> _savePrescription() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Validate selection or custom input
    if (!_isCustomMed && _selectedMedicationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a medication'), backgroundColor: Colors.red));
      return;
    }
    if (_isCustomMed && _customMedNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter medication name'), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);
    
    String? medId = _selectedMedicationId;

    // Create custom medication if needed
    if (_isCustomMed) {
      medId = await _doctorService.createMedication(
        _customMedNameController.text.trim(),
        _customMedFormController.text.trim().isEmpty ? 'Tablet' : _customMedFormController.text.trim(),
      );
      if (medId == null) {
        if (mounted) {
           setState(() => _isLoading = false);
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to create new medication'), backgroundColor: Colors.red));
        }
        return;
      }
    }

    final error = await _doctorService.addPrescription(
      patientId: widget.patientId,
      medicationId: medId!,
      dosage: _dosageController.text.trim(),
      frequency: _freqController.text.trim(),
      duration: _durationController.text.trim(),
      instructions: _instructionsController.text.trim(),
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (error == null) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prescription added successfully'), backgroundColor: Colors.green),
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
    _dosageController.dispose();
    _freqController.dispose();
    _durationController.dispose();
    _instructionsController.dispose();
    _customMedNameController.dispose();
    _customMedFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add Prescription",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: MedColors.textMain),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                         _isCustomMed = !_isCustomMed;
                         _selectedMedicationId = null; // Reset selection
                      });
                    },
                    child: Text(_isCustomMed ? "Select Existing" : "Add New Med", style: const TextStyle(color: MedColors.royalBlue)),
                  )
                ],
              ),
              const SizedBox(height: 20),
              
              // Medication Input (Toggle between Dropdown and Text)
              if (_isCustomMed)
                Column(
                  children: [
                    CustomTextField(
                      controller: _customMedNameController,
                      label: "Medication Name",
                      hint: "e.g. Asprin",
                      prefixIcon: Icons.medication,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _customMedFormController,
                      label: "Form (Optional)",
                      hint: "e.g. Tablet, Syrup",
                      prefixIcon: Icons.category,
                    ),
                  ],
                )
              else
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Select Medication",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  initialValue: _selectedMedicationId,
                  items: _medications.map((med) {
                    return DropdownMenuItem(
                      value: med['id'] as String,
                      child: Text("${med['name']} (${med['form'] ?? 'Tablet'})"),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedMedicationId = val),
                ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _dosageController,
                      label: "Dosage", // e.g., "500mg"
                      hint: "e.g. 500mg",
                      prefixIcon: Icons.scale,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _freqController,
                      label: "Frequency", // e.g., "Twice Daily"
                      hint: "e.g. 2x Daily",
                      prefixIcon: Icons.access_time,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _durationController,
                label: "Duration",
                hint: "e.g., 7 days",
                prefixIcon: Icons.calendar_today,
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _instructionsController,
                label: "Instructions",
                hint: "e.g. Take after meals",
                prefixIcon: Icons.notes,
              ),
              
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: _isLoading ? "Saving..." : "Prescribe",
                  onTap: _isLoading ? () {} : _savePrescription,
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
