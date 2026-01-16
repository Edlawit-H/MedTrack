import 'package:supabase_flutter/supabase_flutter.dart';

class NurseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? getCurrentUser() => _supabase.auth.currentUser;


  // Fetch the current nurse's profile details
  Future<Map<String, dynamic>?> getNurseProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    try {
      final data = await _supabase
          .from('profiles')
          .select('full_name, email, nurses(ward_id, department, shift)')
          .eq('id', user.id)
          .single();
      
      return {
        'full_name': data['full_name'],
        'email': data['email'],
        'ward_id': (data['nurses']?['ward_id'] ?? 'Unknown').toString().trim(),
        'department': data['nurses']?['department'] ?? 'General',
        'shift': data['nurses']?['shift'] ?? 'Day',
      };

    } catch (e) {
      print('Error fetching nurse profile: $e');
      return null;
    }
  }

  // Fetch all patients assigned to this ward AND are currently "inpatient"
  Future<List<Map<String, dynamic>>> getWardPatients() async {
    final nurse = await getNurseProfile();
    if (nurse == null) return [];

    try {
      final data = await _supabase
          .from('patients')
          .select()
          .ilike('ward_id', nurse['ward_id'])
          .eq('stay_type', 'inpatient')

          .order('room_number', ascending: true);
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error fetching ward patients: $e');
      return [];
    }
  }

  // Fetch all scheduled medications for the ward (Inpatients only)
  Future<List<Map<String, dynamic>>> getWardMedications() async {
    final nurse = await getNurseProfile();
    if (nurse == null) return [];

    try {
      final today = DateTime.now();
      final startOfToday = DateTime(today.year, today.month, today.day).toIso8601String();

      final data = await _supabase
          .from('prescriptions')
          .select('*, patients!inner(full_name, room_number, ward_id, stay_type), medications(name, form), medication_logs(status, administered_at)')
          .eq('status', 'active')
          .ilike('patients.ward_id', nurse['ward_id'])
          .eq('patients.stay_type', 'inpatient')
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(data);

    } catch (e) {
      print('Error fetching ward medications: $e');
      return [];
    }
  }


  // New: Calculate dashboard statistics (Attended, Due, Done)
  Future<Map<String, int>> getWardStats() async {
    final nurse = await getNurseProfile();
    if (nurse == null) return {'due': 0, 'done': 0, 'attended': 0};

    try {
      final today = DateTime.now();
      final startOfToday = DateTime(today.year, today.month, today.day).toIso8601String();

      // 1. Total active prescriptions for THIS ward's inpatients
      final prescriptions = await _supabase
          .from('prescriptions')
          .select('id, patients!inner(ward_id, stay_type)')
          .eq('status', 'active')
          .ilike('patients.ward_id', nurse['ward_id'])
          .eq('patients.stay_type', 'inpatient');

      // 2. Meds given today for THIS ward's inpatients
      final logs = await _supabase
          .from('medication_logs')
          .select('id, status, prescription_id, prescriptions!inner(id, patient_id, patients!inner(ward_id, stay_type))')
          .gte('administered_at', startOfToday)
          .ilike('prescriptions.patients.ward_id', nurse['ward_id'])
          .eq('prescriptions.patients.stay_type', 'inpatient');

      final medsDone = (logs as List).where((l) => l['status'] == 'taken' || l['status'] == 'given').map((l) => l['prescription_id']).toSet();
      final medsMissed = (logs as List).where((l) => l['status'] == 'missed').map((l) => l['prescription_id']).toSet();
      final patientsAttended = (logs as List).map((l) => (l['prescriptions'] as Map)['patient_id']).toSet();

      return {
        'due': prescriptions.length - medsDone.length - medsMissed.length,
        'done': medsDone.length,
        'attended': patientsAttended.length,
      };

    } catch (e) {
      print('Error calculating ward stats: $e');
      return {'due': 0, 'done': 0, 'attended': 0};
    }
  }

  // New: Fetch detailed patient profile for the enhanced UI
  Future<Map<String, dynamic>?> getDetailedPatient(String patientId) async {
    try {
      final data = await _supabase
          .from('patients')
          .select('*, doctors(profiles(full_name))')
          .eq('id', patientId)
          .single();
      
      return data;
    } catch (e) {
      print('Error fetching detailed patient: $e');
      return null;
    }
  }

  // New: Fetch active prescriptions AND their latest administration log
  Future<List<Map<String, dynamic>>> getPatientMedicationsWithStatus(String patientId) async {
    try {
      // 1. Fetch active prescriptions
      final prescriptions = await _supabase
          .from('prescriptions')
          .select('*, medications(name, form, strength)')
          .eq('patient_id', patientId)
          .eq('status', 'active');

      // 2. For each prescription, fetch the latest log from today
      final List<Map<String, dynamic>> medsWithStatus = [];
      final today = DateTime.now();
      final startOfToday = DateTime(today.year, today.month, today.day).toIso8601String();

      for (var pres in prescriptions) {
        final logs = await _supabase
            .from('medication_logs')
            .select('*, profiles!administered_by(full_name)')
            .eq('prescription_id', pres['id'])
            .gte('administered_at', startOfToday)
            .order('administered_at', ascending: false)
            .limit(1);
        
        pres['latest_log'] = logs.isNotEmpty ? logs.first : null;
        medsWithStatus.add(pres);
      }
      
      return medsWithStatus;
    } catch (e) {
      print('Error fetching medications with status: $e');
      return [];
    }
  }

  // New: Manage Shift Notes
  Future<void> addShiftNote({required String patientId, required String nurseId, required String note}) async {
    try {
      await _supabase.from('shift_notes').insert({
        'patient_id': patientId,
        'nurse_id': nurseId,
        'note': note,
      });
    } catch (e) {
      print('Error adding shift note: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getShiftNotes(String patientId) async {
    try {
      final data = await _supabase
          .from('shift_notes')
          .select('*, profiles!nurse_id(full_name)')
          .eq('patient_id', patientId)
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error fetching shift notes: $e');
      return [];
    }
  }

  // Record administration (Improved)
  Future<void> administerMedication({
    required String prescriptionId,
    required String nurseId,
    required String status,
    String? notes,
  }) async {
    try {
      await _supabase.from('medication_logs').insert({
        'prescription_id': prescriptionId,
        'administered_by': nurseId,
        'administered_at': DateTime.now().toIso8601String(),
        'scheduled_time': DateTime.now().toIso8601String(), // Default to now to prevent NOT NULL error
        'status': status,
        'notes': notes,
      });
    } catch (e) {
      print('Error logging medication: $e');
      throw e;
    }
  }

  // New: Discharge Patient (Update stay_type to outpatient)
  Future<void> dischargePatient(String patientId) async {
    try {
      await _supabase
          .from('patients')
          .update({'stay_type': 'outpatient'})
          .eq('id', patientId);
    } catch (e) {
      print('Error discharging patient: $e');
      throw e;
    }
  }
}
