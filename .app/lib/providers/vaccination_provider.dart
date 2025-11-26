import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vaccine_dose.dart';
import '../services/vaccination_service.dart';

final vaccinationProvider = FutureProvider.autoDispose<List<VaccineDose>>((ref) async {
  try {
    return await VaccinationService.createDefault().fetchDoses();
  } catch (e) {
    print('[VaccinationProvider] Error fetching vaccinations: $e');
    return <VaccineDose>[];
  }
});
