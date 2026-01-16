import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../core/app_colors.dart';

class PasswordChangeScreen extends StatefulWidget {
  final bool isMandatory;
  const PasswordChangeScreen({super.key, this.isMandatory = true});

  @override
  State<PasswordChangeScreen> createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  String? _error;

  Future<void> _handleUpdate() async {
    if (_passwordController.text.isEmpty || _confirmController.text.isEmpty) {
      setState(() => _error = "Please fill all fields");
      return;
    }
    if (_passwordController.text.length < 6) {
      setState(() => _error = "Password must be at least 6 characters");
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      setState(() => _error = "Passwords do not match");
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final error = await _authService.updatePassword(_passwordController.text);
    
    if (mounted) {
      if (error == null) {
        // Success - determine route based on role
        final role = await _authService.getUserRole();
        if (mounted) {
          String route = '/landing';
          if (role == 'doctor') route = '/doctor_dashboard';
          else if (role == 'nurse') route = '/nurse_dashboard';
          else if (role == 'patient') route = '/patient_dashboard';
          
          Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
        }
      } else {
        setState(() {
          _error = error;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.lock_reset_rounded, size: 80, color: MedColors.drPrimary),
              const SizedBox(height: 24),
              Text(
                widget.isMandatory ? "Set New Password" : "Change Password",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                widget.isMandatory 
                  ? "For security, you must update your password before accessing your account."
                  : "Enter your new password below.",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 48),
              
              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
                  child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13), textAlign: TextAlign.center),
                ),
                const SizedBox(height: 20),
              ],

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: _isLoading ? null : _handleUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MedColors.drPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: _isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text("Update Password", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              
              if (!widget.isMandatory)
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
