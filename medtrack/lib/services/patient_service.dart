import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medtrack/services/auth_service.dart';

class PatientService {
  final _supabase = Supabase.instance.client;

  // Helper to get active ID (Pseudo or Real)
  String? _getActiveId() {
    return AuthService.currentPatientId ?? _supabase.auth.currentUser?.id;
  }

  // Fetch the current patient's profile details & Linked Data
  Future<Map<String, dynamic>?> getPatientProfile() async {
    final activeId = _getActiveId();
    if (activeId == null) {
      print('DEBUG: No logged in user.');
      return null;
    }

    try {
      // 1. Get Patient Record (Works for both Pseudo and Auth)
      // Check if ID matches 'id' or 'profile_id'
      final patientRecord = await _supabase
          .from('patients')
          .select('*, doctors(specialty, profiles(full_name))')
          .or('id.eq.$activeId,profile_id.eq.$activeId')
          .maybeSingle();
      
      if (patientRecord == null) {
        print('DEBUG: No patient record found for ID: $activeId');
        return null;
      }

      return patientRecord;
    } catch (e) {
      print('DEBUG: Error fetching patient profile: $e');
      return null;
    }
  }

  // Fetch active prescriptions
  Future<List<Map<String, dynamic>>> getPrescriptions() async {
    try {
      final activeId = _getActiveId();
      if (activeId == null) return [];

      // Get Patient ID specifically
      final patient = await _supabase
          .from('patients')
          .select('id')
          .or('id.eq.$activeId,profile_id.eq.$activeId')
          .maybeSingle();
          
      if (patient == null) return [];

      final data = await _supabase
          .from('prescriptions')
          .select('*, medications(name, form, strength), doctors(profiles(full_name))')
          .eq('patient_id', patient['id'])
          .eq('status', 'active')
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error fetching prescriptions: $e');
      return [];
    }
  }

  // Fetch appointments
  Future<List<Map<String, dynamic>>> getAppointments() async {
    try {
      final activeId = _getActiveId();
      if (activeId == null) return [];
      
      final patient = await _supabase
          .from('patients')
          .select('id')
          .or('id.eq.$activeId,profile_id.eq.$activeId')
          .maybeSingle();
          
      if (patient == null) return [];

      final data = await _supabase
          .from('appointments')
          .select('*, doctors(specialty, hospital_id, profiles(full_name))') 
          .eq('patient_id', patient['id'])
          .gte('scheduled_time', DateTime.now().toIso8601String())
          .order('scheduled_time', ascending: true);
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }

  // Fetch medication administration history (Taken meds)
  Future<List<Map<String, dynamic>>> getMedicationHistory() async {
    try {
      final activeId = _getActiveId();
      if (activeId == null) return [];

      final patient = await _supabase
          .from('patients')
          .select('id')
          .or('id.eq.$activeId,profile_id.eq.$activeId')
          .maybeSingle();

      if (patient == null) return [];

      final data = await _supabase
          .from('medication_logs')
          .select('*, prescriptions!inner(*, medications(*))')
          .eq('prescriptions.patient_id', patient['id'])
          .order('administered_at', ascending: false);

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error fetching medication history: $e');
      return [];
    }
  }
}
