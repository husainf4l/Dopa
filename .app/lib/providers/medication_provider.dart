import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/medication.dart';
import '../services/medication_service.dart';

final medicationProvider = FutureProvider.autoDispose<List<Medication>>((ref) async {
  try {
    final service = MedicationService.createDefault();
    return await service.getMedications();
  } catch (e) {
    print('[MedicationProvider] Error fetching medications: $e');
    // Return empty list on error instead of throwing
    return <Medication>[];
  }
});
