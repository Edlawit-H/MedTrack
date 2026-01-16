import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch the current doctor's profile details
  Future<Map<String, dynamic>?> getDoctorProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    try {
      final data = await _supabase
          .from('profiles')
          .select('full_name, doctors(specialty)')
          .eq('id', user.id)
          .single();
      
      // Flatten the response for easier UI usage
      return {
        'full_name': data['full_name'],
        'specialty': data['doctors']?['specialty'] ?? 'General',
      };
    } catch (e) {
      print('Error fetching doctor profile: $e');
      return null;
    }
  }

  // Fetch patients assigned to this doctor
  Future<List<Map<String, dynamic>>> getAssignedPatients() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    try {
      final data = await _supabase
          .from('patients')
          .select()
          .eq('primary_doctor_id', user.id)
          .order('full_name', ascending: true);
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error fetching patients: $e');
      return [];
    }
  }

  // Create a patient record (Enhanced with Clinical Data)
  Future<String?> addPatient({
    required String fullName,
    required String email,
    required String mrn,
    required String dob, // YYYY-MM-DD
    required String gender,
    required String contact,
    String? bloodType,
    String? medicalCondition,
    String? doctorNotes,
    String stayType = 'outpatient',
    String? roomNumber,
    String? bedNumber,
    String? wardId,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return 'Not authenticated';

    try {
      await _supabase.from('patients').insert({
        'full_name': fullName,
        'email': email,
        'mrn': mrn,
        'date_of_birth': dob,
        'gender': gender,
        'emergency_contact': contact,
        'primary_doctor_id': user.id,
        'is_activated': true,
        'blood_type': bloodType ?? 'O Positive',
        'medical_condition': medicalCondition ?? 'General Checkup',
        'doctor_notes': doctorNotes ?? 'No notes added.',
        'stay_type': stayType,
        'room_number': roomNumber,
        'bed_number': bedNumber,
        'ward_id': wardId ?? 'A1',
      });
      
      return null;
    } catch (e) {
      return 'Error creating patient: $e';
    }
  }

  // Calculate medication adherence statistics
  Future<Map<String, dynamic>> getPatientAdherence(String patientId) async {
    try {
      final logs = await _supabase
          .from('medication_logs')
          .select('status, prescription_id, prescriptions!inner(patient_id)')
          .eq('prescriptions.patient_id', patientId);

      final total = (logs as List).length;
      if (total == 0) return {'rate': 0, 'taken': 0, 'missed': 0, 'total': 0};

      final taken = logs.where((l) => l['status'] == 'given').length;
      final missed = logs.where((l) => l['status'] == 'missed').length;
      final rate = (taken / total) * 100;

      return {
        'rate': rate.round(),
        'taken': taken,
        'missed': missed,
        'total': total,
      };
    } catch (e) {
      print('Adherence error: $e');
      return {'rate': 0, 'taken': 0, 'missed': 0, 'total': 0};
    }
  }

  // Fetch patient's prescriptions
  Future<List<Map<String, dynamic>>> getPatientPrescriptions(String patientId) async {
    try {
      final data = await _supabase
          .from('prescriptions')
          .select('*, medications(name, form)')
          .eq('patient_id', patientId)
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error fetching prescriptions: $e');
      return [];
    }
  }

  // Fetch available medications for dropdown
  Future<List<Map<String, dynamic>>> getAvailableMedications() async {
    try {
      final data = await _supabase
          .from('medications')
          .select()
          .order('name', ascending: true);
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      return [];
    }
  }

  // Add a new prescription
  Future<String?> addPrescription({
    required String patientId,
    required String medicationId,
    required String dosage,
    required String frequency,
    required String duration,
    required String instructions,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return 'Not authenticated';

    try {
      await _supabase.from('prescriptions').insert({
        'patient_id': patientId,
        'doctor_id': user.id,
        'medication_id': medicationId,
        'dosage': dosage,
        'frequency': frequency,
        'duration': duration,
        'instructions': instructions,
        'status': 'active',
        'start_date': DateTime.now().toIso8601String(),
      });
      return null;
    } catch (e) {
      return 'Error creating prescription: $e';
    }
  }
  // Create a new medication
  Future<String?> createMedication(String name, String form) async {
    try {
      final response = await _supabase.from('medications').insert({
        'name': name,
        'form': form,
        'description': 'Added by doctor',
      }).select().single();
      
      return response['id'] as String;
    } catch (e) {
      print('Error creating medication: $e');
      return null;
    }
  }

  // Fetch appointments for the doctor
  Future<List<Map<String, dynamic>>> getAppointments() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    try {
      final data = await _supabase
          .from('appointments')
          .select('*, patients(full_name)')
          .eq('doctor_id', user.id)
          .order('scheduled_time', ascending: true);
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }

  // Add a new appointment
  Future<String?> addAppointment({
    required String patientId,
    required DateTime date,
    required String type,
    required String notes,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return 'Not authenticated';

    try {
      await _supabase.from('appointments').insert({
        'doctor_id': user.id,
        'patient_id': patientId,
        'scheduled_time': date.toIso8601String(),
        'status': 'scheduled',
        'type': type.isEmpty ? 'Regular Visit' : type,
        'notes': notes,
      });
      return null;
    } catch (e) {
      return 'Error creating appointment: $e';
    }
  }
}
