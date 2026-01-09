import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/shared_widgets.dart';

class PatientLogin extends StatelessWidget {
  const PatientLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Illustration Area
            Container(
              height: 400,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                   begin: Alignment.topCenter,
                   end: Alignment.bottomCenter,
                   colors: [Colors.green.shade50, Colors.white]
                )
              ),
              child: Stack(
                children: [
                   Align(
                     alignment: Alignment.topRight,
                     child: Padding(
                       padding: const EdgeInsets.only(top: 60, right: 20),
                       child: Container(
                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                         decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                         child: const Row(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             Icon(Icons.health_and_safety, color: Colors.white, size: 16),
                             SizedBox(width: 6),
                             Text("MEDICARE+", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)) 
                           ],
                         ),
                       ),
                     ),
                   ),
                   Center(
                     child: Icon(Icons.family_restroom, size: 200, color: Colors.green.shade200), // Placeholder for illustration
                   )
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Start Your Journey", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: MedColors.textMain)),
                  const SizedBox(height: 10),
                  const Text("Enter the 6-digit code sent to your email when your doctor created your account.", style: TextStyle(color: MedColors.textSecondary, height: 1.5)),
                  const SizedBox(height: 30),
                  
                  const Text("Activation Code", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  const MedTextField(label: "", hint: "e.g. 829401", icon: Icons.vpn_key_outlined),
                  
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(Icons.info_outline, size: 14, color: Colors.green),
                      SizedBox(width: 6),
                      Text("Check your spam folder if you don't see the email.", style: TextStyle(fontSize: 11, color: Colors.green)) 
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/patient_dashboard'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MedColors.patPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 5,
                        shadowColor: Colors.green.withOpacity(0.4)
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Activate Account", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward)
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Privacy Policy", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text("•", style: TextStyle(color: Colors.grey[400])),
                      ),
                      Text("Terms of Service", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
