import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/primary_button.dart';

import '../../services/doctor_service.dart';

class AddNewPatient extends StatefulWidget {
  const AddNewPatient({super.key});

  @override
  State<AddNewPatient> createState() => _AddNewPatientState();
}

class _AddNewPatientState extends State<AddNewPatient> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _bloodController = TextEditingController();
  final _contactController = TextEditingController();
  final _conditionController = TextEditingController();
  final _notesController = TextEditingController();
  final _roomController = TextEditingController();
  final _bedController = TextEditingController();
  final _wardController = TextEditingController();

  bool _isLoading = false;
  bool _isInpatient = false;

  Future<void> _createPatient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    final mrn = "MRN-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";
    final doctorService = DoctorService();
    final error = await doctorService.addPatient(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      mrn: mrn, 
      dob: _dobController.text.trim(), 
      gender: _genderController.text.trim(),
      contact: _contactController.text.trim(),
      bloodType: _bloodController.text.trim(),
      medicalCondition: _conditionController.text.trim(),
      doctorNotes: _notesController.text.trim(),
      stayType: _isInpatient ? 'inpatient' : 'outpatient',
      roomNumber: _isInpatient ? _roomController.text.trim() : null,
      bedNumber: _isInpatient ? _bedController.text.trim() : null,
      wardId: _isInpatient ? _wardController.text.trim() : null,
    );

    if (error == null) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 10),
                Text("Patient Created", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Give this code to the patient for portal access:"),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Text(
                      mrn,
                      style: const TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold, 
                        letterSpacing: 1.5,
                        color: Colors.green
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Close add patient screen
                },
                child: const Text("Done", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
      }
    }
    
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _bloodController.dispose();
    _contactController.dispose();
    _conditionController.dispose();
    _notesController.dispose();
    _roomController.dispose();
    _bedController.dispose();
    _wardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text("Add New Patient", style: TextStyle(color: MedColors.textMain, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Basic Information", style: TextStyle(fontWeight: FontWeight.bold, color: MedColors.textMain)),
                      const SizedBox(height: 16),
                      CustomTextField(controller: _nameController, label: "Full Name", prefixIcon: Icons.person_outline),
                      CustomTextField(controller: _emailController, label: "Email Address", prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                      Row(
                        children: [
                          Expanded(child: CustomTextField(controller: _dobController, label: "DOB (YYYY-MM-DD)", prefixIcon: Icons.calendar_today)),
                          const SizedBox(width: 16),
                          Expanded(child: CustomTextField(controller: _genderController, label: "Gender", prefixIcon: Icons.wc)),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      const Text("Clinical Details", style: TextStyle(fontWeight: FontWeight.bold, color: MedColors.textMain)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: CustomTextField(controller: _bloodController, label: "Blood Type", prefixIcon: Icons.bloodtype)),
                          const SizedBox(width: 16),
                          Expanded(child: CustomTextField(controller: _contactController, label: "Emerg. Contact", prefixIcon: Icons.contact_phone)),
                        ],
                      ),
                      CustomTextField(controller: _conditionController, label: "Medical Condition (e.g. Hypertension)", prefixIcon: Icons.medical_information),
                      
                      const SizedBox(height: 10),
                      SwitchListTile(
                        title: const Text("Requires Admission (Inpatient)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        subtitle: const Text("Enable to assign room and bed", style: TextStyle(fontSize: 12)),
                        value: _isInpatient,
                        activeColor: MedColors.royalBlue,
                        onChanged: (val) => setState(() => _isInpatient = val),
                        contentPadding: EdgeInsets.zero,
                      ),
                      
                      if (_isInpatient) ...[
                        const SizedBox(height: 10),
                        CustomTextField(controller: _wardController, label: "Ward (e.g. A1, B2)", prefixIcon: Icons.local_hospital_outlined),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: CustomTextField(controller: _roomController, label: "Room Number", prefixIcon: Icons.meeting_room)),
                            const SizedBox(width: 16),
                            Expanded(child: CustomTextField(controller: _bedController, label: "Bed Number", prefixIcon: Icons.bed)),
                          ],
                        ),
                      ],

                      const SizedBox(height: 20),
                      const Text("Doctor Notes", style: TextStyle(fontWeight: FontWeight.bold, color: MedColors.textMain)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: TextField(
                          controller: _notesController,
                          maxLines: 4,
                          decoration: const InputDecoration.collapsed(hintText: "Initial observations and assessment...", hintStyle: TextStyle(color: Colors.grey, fontSize: 13)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: PrimaryButton(
                text: _isLoading ? "Creating..." : "Create Patient Record",
                onTap: _isLoading ? () {} : _createPatient,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
