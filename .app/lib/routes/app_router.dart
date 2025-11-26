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
import '../features/records/medical_records_screen.dart';
import '../features/resources/resources_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/emergency/emergency_card_screen.dart';
import '../features/family/family_mode_screen.dart';
import '../features/insights/insights_screen.dart';
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
          GoRoute(path: 'resources', builder: (context, state) => const ResourcesScreen()),
          GoRoute(path: 'profile', builder: (context, state) => const ProfileScreen()),
          GoRoute(path: 'emergency', builder: (context, state) => const EmergencyCardScreen()),
          GoRoute(path: 'family', builder: (context, state) => const FamilyModeScreen()),
          GoRoute(path: 'insights', builder: (context, state) => const InsightsScreen()),
          GoRoute(path: 'settings', builder: (context, state) => const SettingsScreen()),
        ],
      ),
    ],
  );
});
