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
import '../features/records/medical_records_screen.dart';
import '../features/resources/resources_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/onboarding/onboarding_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/medications', builder: (context, state) => const MedicationsListScreen()),
      GoRoute(path: '/medications/create', builder: (context, state) => const MedicationFormScreen()),
      GoRoute(path: '/appointments', builder: (context, state) => const AppointmentsListScreen()),
      GoRoute(path: '/appointments/create', builder: (context, state) => const AppointmentFormScreen()),
      GoRoute(path: '/vaccinations', builder: (context, state) => const VaccinationListScreen()),
      GoRoute(path: '/vaccinations/create', builder: (context, state) => const VaccinationFormScreen()),
      GoRoute(path: '/records', builder: (context, state) => const MedicalRecordsScreen()),
      GoRoute(path: '/resources', builder: (context, state) => const ResourcesScreen()),
      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
    ],
  );
});
