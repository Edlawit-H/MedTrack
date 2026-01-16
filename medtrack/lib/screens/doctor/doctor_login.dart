import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/shared_widgets.dart';
import '../../services/auth_service.dart';




class DoctorLogin extends StatefulWidget {
  const DoctorLogin({super.key});

  @override
  State<DoctorLogin> createState() => _DoctorLoginState();
}

class _DoctorLoginState extends State<DoctorLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    // Basic validation
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      setState(() => _isLoading = false);
      return;
    }

    // Call Auth Service
    final authService = AuthService(); // Ensure you import this
    final error = await authService.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      }
    } else {
      // Check role
      final role = await authService.getUserRole();
      if (mounted) {
        if (role == 'doctor') {
          // Check for mandatory password change
          final needsChange = await authService.checkNeedsPasswordChange();
          if (mounted) {
            if (needsChange) {
              Navigator.pushReplacementNamed(context, '/password_change');
            } else {
              Navigator.pushReplacementNamed(context, '/doctor_dashboard');
            }
          }
        } else {
          await authService.signOut();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Access denied: Role is ${role ?? "NULL"}. Expected: doctor'), backgroundColor: Colors.red),
          );
        }
      }
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedColors.greyBg,
      body: Stack(
        children: [
          // Blue Background Header
          Container(
            height: 300,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [MedColors.drStart, MedColors.drEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Column(
                        children: [
                          Icon(Icons.medical_services_rounded, color: Colors.white, size: 48),
                          SizedBox(height: 16),
                          Text(
                            "Doctor Portal",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Hospital Medication Management",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Login Form Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      MedTextField(
                        controller: _emailController,
                        label: "Email",
                        hint: "edlawit@gmail.com",
                        icon: Icons.email,
                      ),
                      const SizedBox(height: 20),
                      MedTextField(
                        controller: _passwordController,
                        label: "Password",
                        hint: "••••••••",
                        isPassword: true,
                        icon: Icons.lock,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MedColors.drPrimary,
                          minimumSize: const Size(double.infinity, 55),
                        ),
                        child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Sign In",
                              style: TextStyle(color: Colors.white),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
