import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedColors.landingBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Logo Section
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: MedColors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.local_hospital_rounded,
                  color: MedColors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "MedTrack",
                style: TextStyle(
                  color: MedColors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Hospital Medication Management",
                style: TextStyle(
                  color: MedColors.white.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              
              // Portal Selection Cards
              _PortalCard(
                title: "Doctor Portal",
                subtitle: "Prescribe & Monitor",
                icon: Icons.monitor_heart_outlined,
                color: MedColors.drPrimary,
                onTap: () => Navigator.pushNamed(context, '/doctor_login'),
              ),
              const SizedBox(height: 16),
              _PortalCard(
                title: "Nurse Portal",
                subtitle: "Administer & Track",
                icon: Icons.medical_services_outlined,
                color: MedColors.nursePrimary,
                onTap: () => Navigator.pushNamed(context, '/nurse_login'),
              ),
              const SizedBox(height: 16),
              _PortalCard(
                title: "Patient Portal",
                subtitle: "View Schedule & History",
                icon: Icons.person_outline,
                color: MedColors.patPrimary,
                onTap: () => Navigator.pushNamed(context, '/patient_login'),
              ),
              
              const Spacer(),
              Text(
                "© 2024 MedTrack Systems v2.0",
                style: TextStyle(
                  color: MedColors.white.withOpacity(0.3),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _PortalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _PortalCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: MedColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: MedColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey[300],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
