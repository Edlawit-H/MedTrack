import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class PatientsScreen extends StatelessWidget {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedColors.greyBg,
      appBar: AppBar(
        title: const Text("My Patients", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: MedColors.drPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(20),
            color: MedColors.drPrimary,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search patients...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _PatientCard(
                  name: "Sarah Jenkins",
                  id: "#PT5042",
                  condition: "Hypertension",
                  status: "Critical",
                  image: "https://i.pravatar.cc/150?img=5",
                  onTap: () => Navigator.pushNamed(context, '/doctor_patient_profile'),
                ),
                _PatientCard(
                  name: "Michael Ross",
                  id: "#PT9283",
                  condition: "Diabetes Type 2",
                  status: "Stable",
                  image: "https://i.pravatar.cc/150?img=8",
                  onTap: () => Navigator.pushNamed(context, '/doctor_patient_profile'),
                ),
                _PatientCard(
                  name: "Emily Blunt",
                  id: "#PT1029",
                  condition: "Post-Op Recovery",
                  status: "Review",
                  image: "https://i.pravatar.cc/150?img=9",
                  onTap: () => Navigator.pushNamed(context, '/doctor_patient_profile'),
                ),
                 _PatientCard(
                  name: "David Kim",
                  id: "#PT3821",
                  condition: "Fracture",
                  status: "Stable",
                  image: "https://i.pravatar.cc/150?img=11",
                  onTap: () => Navigator.pushNamed(context, '/doctor_patient_profile'),
                ),
                 _PatientCard(
                  name: "Linda Johnson",
                  id: "#PT9932",
                  condition: "Flu",
                  status: "Stable",
                  image: "https://i.pravatar.cc/150?img=1",
                  onTap: () => Navigator.pushNamed(context, '/doctor_patient_profile'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  final String name, id, condition, status, image;
  final VoidCallback onTap;

  const _PatientCard({
    required this.name,
    required this.id,
    required this.condition,
    required this.status,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(image),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$id • $condition"),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: status == "Critical" ? Colors.red[50] : Colors.green[50],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: status == "Critical" ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
