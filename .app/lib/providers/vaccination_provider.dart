import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vaccine_dose.dart';
import '../services/vaccination_service.dart';

final vaccinationProvider = FutureProvider.autoDispose<List<VaccineDose>>((ref) async {
  return VaccinationService.createDefault().fetchDoses();
});
