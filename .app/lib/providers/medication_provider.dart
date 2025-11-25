import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/medication.dart';
import '../services/medication_service.dart';

final medicationProvider = FutureProvider.autoDispose<List<Medication>>((ref) async {
  final service = MedicationService.createDefault();
  return service.getMedications();
});
