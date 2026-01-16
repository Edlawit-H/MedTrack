import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  static String? _pseudoPatientId;
  static String? get currentPatientId => _pseudoPatientId;

  // Sign in with email and password (For Doctors/Nurses)
  Future<String?> signIn({required String email, required String password}) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return 'Login failed: No user found';
      }

      _pseudoPatientId = null; // Clear pseudo ID if real login occurs
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }

  // Direct Login for Patients via MRN (Admission Code)
  Future<String?> signInWithMRN(String mrn) async {
    try {
      final data = await _supabase
          .from('patients')
          .select('id')
          .eq('mrn', mrn)
          .maybeSingle();

      if (data != null) {
        _pseudoPatientId = data['id'].toString();
        return null; // Success!
      } else {
        return 'Invalid Admission Code. Please check the code provided by your doctor.';
      }
    } catch (e) {
      print('MRN Login Error: $e');
      return 'Connection error. Please try again.';
    }
  }

  // Pseudo-Login for Patients (Legacy - keep for backward compatibility if needed)
  Future<String?> patientPseudoLogin({required String email, required String mrn}) async {
    try {
      final data = await _supabase
          .from('patients')
          .select('id')
          .eq('email', email)
          .eq('mrn', mrn)
          .maybeSingle();

      if (data != null) {
        _pseudoPatientId = data['id'].toString();
        return null; // Success!
      } else {
        return 'Invalid Email or MRN. Please check your credentials.';
      }
    } catch (e) {
      return 'Database connection error. Please try again.';
    }
  }

  // Verify Role using Secure Function (Bypasses Table RLS)
  Future<String?> getUserRole() async {
    if (_pseudoPatientId != null) return 'patient';
    
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    try {
      final data = await _supabase.rpc('get_user_role', params: {'target_id': user.id});
      return data as String?;
    } catch (e) {
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _pseudoPatientId = null;
    await _supabase.auth.signOut();
  }

  // Check if user needs to change password
  Future<bool> checkNeedsPasswordChange() async {
    if (_pseudoPatientId != null) return false; // Pseudo-users bypass this
    
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    try {
      final data = await _supabase
          .from('profiles')
          .select('needs_password_change')
          .eq('id', user.id)
          .maybeSingle();
      
      return data?['needs_password_change'] ?? false;
    } catch (e) {
      return false;
    }
  }

  // Update password and clear flag
  Future<String?> updatePassword(String newPassword) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return 'Not authenticated';

    try {
      // 1. Update Auth Password
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));

      // 2. Clear flag in public.profiles
      await _supabase.from('profiles').update({
        'needs_password_change': false,
      }).eq('id', user.id);

      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unexpected error occurred: $e';
    }
  }
}
