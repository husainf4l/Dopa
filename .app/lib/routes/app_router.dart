import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/auth_screen.dart';
import '../features/home/home_screen.dart';
import '../features/medications/medications_list_screen.dart';
import '../features/medications/medication_form_screen.dart';
import '../features/appointments/appointments_list_screen.dart';
import '../features/appointments/appointment_form_screen.dart';
import '../features/vaccinations/vaccination_list_screen.dart';
import '../features/vaccinations/vaccination_form_screen.dart';
import '../models/medication.dart';
import '../models/appointment.dart';
import '../models/vaccine_dose.dart';
import '../models/family_member.dart';
import '../features/records/medical_category_detail_screen.dart';
import '../features/records/vital_signs_screen.dart';
import '../features/records/medical_records_screen.dart';
import '../features/records/medical_record_form_screen.dart';
import '../features/records/medical_history_screen.dart';
import '../features/resources/resources_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/emergency/emergency_card_screen.dart';
import '../features/family/family_mode_screen.dart';
import '../features/family/family_member_form_screen.dart';
import '../features/insights/insights_screen.dart';
import '../features/settings/notifications_settings_screen.dart';
import '../features/settings/privacy_settings_screen.dart';
import '../features/settings/export_data_settings_screen.dart';
import '../features/settings/backup_sync_settings_screen.dart';
import '../features/settings/language_settings_screen.dart';
import '../features/settings/account_security_settings_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/splash/splash_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'medications',
            builder: (context, state) => const MedicationsListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const MedicationFormScreen(),
              ),
              GoRoute(
                path: 'edit',
                builder: (context, state) => MedicationFormScreen(
                  medication: state.extra as Medication?,
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'appointments',
            builder: (context, state) => const AppointmentsListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const AppointmentFormScreen(),
              ),
              GoRoute(
                path: 'edit',
                builder: (context, state) => AppointmentFormScreen(
                  appointment: state.extra as Appointment?,
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'vaccinations',
            builder: (context, state) => const VaccinationListScreen(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const VaccinationFormScreen(),
              ),
              GoRoute(
                path: 'edit',
                builder: (context, state) => VaccinationFormScreen(
                  vaccineDose: state.extra as VaccineDose?,
                ),
              ),
            ],
          ),
          GoRoute(path: 'records', builder: (context, state) => const MedicalRecordsScreen()),
          GoRoute(path: 'records/edit', builder: (context, state) => MedicalRecordFormScreen(record: state.extra as dynamic)),
          GoRoute(path: 'medical-history', builder: (context, state) => const MedicalHistoryScreen()),
          GoRoute(path: 'vital-signs', builder: (context, state) => const VitalSignsScreen()),
          GoRoute(
            path: 'medical-history/:category',
            builder: (context, state) {
              final category = state.pathParameters['category']!;
              final categoryTitle = _getCategoryTitle(category);
              return MedicalCategoryDetailScreen(
                categoryTitle: categoryTitle,
                categoryName: category,
              );
            },
          ),
          GoRoute(path: 'resources', builder: (context, state) => const ResourcesScreen()),
          GoRoute(path: 'profile', builder: (context, state) => const ProfileScreen()),
          GoRoute(path: 'emergency', builder: (context, state) => const EmergencyCardScreen()),
          GoRoute(path: 'family', builder: (context, state) => FamilyModeScreen()),
          GoRoute(path: 'family-member', builder: (context, state) => const FamilyMemberFormScreen()),
          GoRoute(path: 'family-member-edit', builder: (context, state) => FamilyMemberFormScreen(familyMember: state.extra as FamilyMember?)),
          GoRoute(path: 'insights', builder: (context, state) => const InsightsScreen()),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
            routes: [
              GoRoute(
                path: 'notifications',
                builder: (context, state) => const NotificationsSettingsScreen(),
              ),
              GoRoute(
                path: 'privacy',
                builder: (context, state) => const PrivacySettingsScreen(),
              ),
              GoRoute(
                path: 'export-data',
                builder: (context, state) => const ExportDataSettingsScreen(),
              ),
              GoRoute(
                path: 'backup-sync',
                builder: (context, state) => const BackupSyncSettingsScreen(),
              ),
              GoRoute(
                path: 'language',
                builder: (context, state) => const LanguageSettingsScreen(),
              ),
              GoRoute(
                path: 'account-security',
                builder: (context, state) => const AccountSecuritySettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

String _getCategoryTitle(String category) {
  switch (category) {
    case 'chronic-diseases':
      return 'Chronic Diseases';
    case 'current-medications':
      return 'Current Medications';
    case 'allergies':
      return 'Allergies';
    case 'past-operations':
      return 'Past Operations';
    case 'recent-illness':
      return 'Recent Illness';
    case 'family-diseases':
      return 'Family Diseases';
    case 'recent-travel':
      return 'Recent Travel';
    case 'recent-vaccination':
      return 'Recent Vaccination';
    case 'lifestyle-factors':
      return 'Lifestyle Factors';
    case 'imaging':
      return 'Imaging';
    case 'lab-records':
      return 'Lab Records';
    case 'emergency-contact':
      return 'Emergency Contact';
    default:
      return category.replaceAll('-', ' ').split(' ').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }
}
