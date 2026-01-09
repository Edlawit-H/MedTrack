import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/primary_button.dart';

class AddNewPatient extends StatelessWidget {
  const AddNewPatient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add New Patient",
          style: TextStyle(color: MedColors.textMain, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Enter patient details to create record", style: TextStyle(color: MedColors.textSecondary)),
                    const SizedBox(height: 20),
                    const CustomTextField(label: "Full Name", prefixIcon: Icons.person_outline),
                    const CustomTextField(label: "Email Address", prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                    const CustomTextField(label: "Phone Number", prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone),
                    Row(
                      children: [
                        Expanded(child: CustomTextField(label: "Date of Birth", prefixIcon: Icons.calendar_today)),
                        SizedBox(width: 16),
                        Expanded(child: CustomTextField(label: "Gender", prefixIcon: Icons.wc)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: CustomTextField(label: "Blood Type", prefixIcon: Icons.bloodtype)),
                        SizedBox(width: 16),
                        Expanded(child: CustomTextField(label: "Emerg. Contact", prefixIcon: Icons.contact_phone)),
                      ],
                    ),
                    
                    const SizedBox(height: 10),
                    const Text("Initial Assessment", style: TextStyle(fontWeight: FontWeight.bold, color: MedColors.textMain)),
                    const SizedBox(height: 10),
                    Container(
                      height: 100,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                        ],
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const TextField(
                        maxLines: 5,
                        decoration: InputDecoration.collapsed(hintText: "Brief description of symptoms and initial observations...", hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel", style: TextStyle(color: MedColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: PrimaryButton(
                      text: "Create Patient",
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
