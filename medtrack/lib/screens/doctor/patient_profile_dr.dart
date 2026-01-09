import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/app_colors.dart';
import '../../widgets/primary_button.dart';

class PatientProfileDr extends StatelessWidget {
  const PatientProfileDr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedColors.greyBg,
      appBar: AppBar(
        title: const Text("Patient Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: MedColors.drPrimary,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profile Section
            Container(
              color: MedColors.drPrimary,
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sarah Jenkins",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "ID: #PT5042",
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 8),
                      Text("Age: 45 • Blood Type: O+", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Adherence Chart
                   Container(
                     padding: const EdgeInsets.all(20),
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(16)
                     ),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const Text(
                           "Medication Adherence",
                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                         ),
                         const SizedBox(height: 20),
                         Row(
                           children: [
                             SizedBox(
                               height: 100,
                               width: 100,
                               child: Stack(
                                 children: [
                                   PieChart(
                                     PieChartData(
                                       sections: [
                                         PieChartSectionData(
                                           color: Colors.green,
                                           value: 93,
                                           radius: 10,
                                           showTitle: false,
                                         ),
                                         PieChartSectionData(
                                           color: Colors.grey[200],
                                           value: 7,
                                           radius: 10,
                                           showTitle: false,
                                         )
                                       ]
                                     )
                                   ),
                                   const Center(
                                     child: Text(
                                       "93%",
                                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                     ),
                                   )
                                 ],
                               ),
                             ),
                             const SizedBox(width: 20),
                             const Expanded(
                               child: Column(
                                 children: [
                                   _AdherenceStat(label: "Taken", count: "42", color: Colors.green),
                                    SizedBox(height: 8),
                                   _AdherenceStat(label: "Missed", count: "03", color: Colors.red),
                                     SizedBox(height: 8),
                                   _AdherenceStat(label: "Total", count: "45", color: Colors.blue),
                                 ],
                               ),
                             )
                           ],
                         )
                       ],
                     ),
                   ),
                   const SizedBox(height: 20),

                  // Contact Info
                  _SectionHeader(title: "Contact Information"),
                  const Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _InfoRow(icon: Icons.phone, value: "(555) 123-4567"),
                          Divider(),
                          _InfoRow(icon: Icons.email, value: "sarah.j@email.com"),
                          Divider(),
                          _InfoRow(icon: Icons.home, value: "123 Maple Ave, Springfield"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Medications
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _SectionHeader(title: "Medications"),
                      TextButton.icon(
                        onPressed: (){}, 
                        icon: const Icon(Icons.add, size: 16), 
                        label: const Text("Add"),
                      )
                    ],
                  ),
                  _MedicationCard(
                    name: "Lisinopril",
                    dosage: "10mg, 1 Tablet",
                    freq: "Once Daily", 
                    adherence: "98%",
                  ),
                   _MedicationCard(
                    name: "Metformin",
                    dosage: "500mg, 1 Tablet",
                    freq: "Twice Daily", 
                    adherence: "85%",
                    isLow: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: MedColors.drPrimary),
                ),
                child: const Text("Message", style: TextStyle(color: MedColors.drPrimary)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PrimaryButton(
                text: "Edit Prescription", 
                onTap: (){}
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MedColors.textMain)),
    );
  }
}

class _AdherenceStat extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _AdherenceStat({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 8),
        Text(label),
        const Spacer(),
        Text(count, style: const TextStyle(fontWeight: FontWeight.bold))
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String value;
  const _InfoRow({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}

class _MedicationCard extends StatelessWidget {
  final String name;
  final String dosage;
  final String freq;
  final String adherence;
  final bool isLow;

  const _MedicationCard({
    required this.name, 
    required this.dosage, 
    required this.freq, 
    required this.adherence,
    this.isLow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200)
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MedColors.drBg,
              borderRadius: BorderRadius.circular(10)
            ),
            child: const Icon(Icons.medication, color: MedColors.drPrimary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("$dosage • $freq", style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                adherence, 
                style: TextStyle(
                  color: isLow ? Colors.orange : Colors.green,
                  fontWeight: FontWeight.bold
                )
              ),
              const Text("Adherence", style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }
}
