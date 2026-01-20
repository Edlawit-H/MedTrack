# MedTrack - Hospital Medication Management System

A comprehensive Flutter-based medical ecosystem designed to improve medication adherence and streamline hospital ward management through real-time synchronization between doctors, nurses, and patients.

## 🎯 Project Overview

MedTrack is a multi-portal healthcare application that enables:
- **Doctors** to manage patients, prescribe medications, and schedule appointments
- **Nurses** to administer medications, track ward statistics, and monitor patient compliance
- **Patients** to view their medications, receive reminders, and track their health journey

## 🚀 Features

### Doctor Portal
- **Patient Management**: View and manage patient records with detailed medical history
- **Prescription System**: Create and edit medication prescriptions with real-time sync
- **Appointment Scheduling**: Schedule and manage patient appointments
- **Dashboard Analytics**: View active prescriptions, upcoming appointments, and patient statistics

### Nurse Portal
- **Ward Dashboard**: Real-time statistics (Attended, Due, Done medications)
- **Medication Schedule**: View all ward medications with time-based organization
- **Administration Tracking**: Mark medications as Taken/Missed with instant database updates
- **Time-Locked Actions**: 30-minute grace window before scheduled medication times

### Patient Portal
- **Medication Reminders**: Session-based tracking with automatic filtering
- **Appointment Calendar**: View upcoming doctor appointments
- **Medication History**: Track taken and missed medications
- **Progress Dashboard**: Visual adherence percentage and daily goals
- **Smart Notifications**: Time-based medication reminders

## 📱 Demo Credentials

### Doctor Portal
- **Email**: `edlawit@gmail.com`
- **Password**: `123456`
- **Role**: Senior Cardiologist

### Nurse Portal
- **Email**: `selam@gmail.com`
- **Password**: `password123`
- **Ward**: Ward A

### Patient Portal (MRN-based Login)
**Patient 1: Abel Tesfaye**
- **MRN Code**: `MRN-001`
- **Medications**: Aspirin (Twice Daily)
- **Doctor**: Dr. Edlawit Gebre

**Patient 2: Solomon Gebre**
- **MRN Code**: `MRN-002`
- **Doctor**: Dr. Edlawit Gebre

**Patient 3: Hiwot Belay**
- **MRN Code**: `MRN-9002`
- **Doctor**: Dr.Fresh


## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK
- Android Studio / VS Code
- Supabase Account

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd medtrack
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase**
   - Create a Supabase project at [supabase.com](https://supabase.com)
   - Update `lib/main.dart` with your Supabase URL and Anon Key
   - Run the SQL scripts in `supabase/` folder in this order:
     1. `final_presentation_consolidation.sql` (Core data setup)
     2. `fix_patient_appointments.sql` (Appointments & medications)
     3. `final_fix_for_submission.sql` (Status constraints)

4. **Run the application**
   ```bash
   # For Android
   flutter run

   # For Web (recommended for demo)
   flutter run -d chrome
   ```

## 📊 Database Setup

The application uses Supabase (PostgreSQL) with the following main tables:
- `profiles` - User authentication and roles
- `doctors` - Doctor-specific information
- `nurses` - Nurse assignments and ward details
- `patients` - Patient records and medical information
- `medications` - Medication catalog
- `prescriptions` - Active and historical prescriptions
- `medication_logs` - Administration tracking
- `appointments` - Scheduled appointments

**Important**: Run all SQL scripts in the `supabase/` folder to populate demo data.

## 🎨 Key Technical Features

### Real-Time Synchronization
- Doctor edits to prescriptions appear instantly in patient and nurse portals
- No manual refresh needed - powered by Supabase real-time database

### Session-Based Medication Tracking
- Medications with multiple daily doses (e.g., "Twice Daily") appear as separate sessions
- Each session can be independently marked as Taken/Missed
- Automatic filtering removes completed sessions from upcoming list

### Time-Lock System
- Prevents early medication logging (30-minute grace window)
- Applies to both Patient and Nurse portals
- Ensures clinical accuracy and prevents data errors

### Smart Progress Calculation
- Dashboard percentage based on daily required doses vs. completed doses
- Capped at 100% to prevent overflow
- Real-time updates as medications are logged

## 🧪 Testing Notifications

### On Android Phone
1. Log in as a patient (use MRN codes above)
2. Navigate to **Patient Profile**
3. Scroll down and tap **"Test Notification"**
4. A native Android notification will appear

### On Web/Chrome
1. Run `flutter run -d chrome`
2. Log in as a patient
3. The app checks every minute for scheduled medication times
4. A custom banner slides in from the top at scheduled times (9 AM, 9 PM, etc.)

## 📁 Project Structure

```
lib/
├── core/               # Shared utilities and constants
│   ├── app_colors.dart
│   └── med_frequency_utils.dart
├── screens/
│   ├── doctor/        # Doctor portal screens
│   ├── nurse/         # Nurse portal screens
│   └── patient/       # Patient portal screens
├── services/          # Business logic and API calls
│   ├── auth_service.dart
│   ├── doctor_service.dart
│   ├── nurse_service.dart
│   ├── patient_service.dart
│   └── notification_service.dart
└── widgets/           # Reusable UI components
```

## 📄 License

This project is developed for educational purposes.

---
