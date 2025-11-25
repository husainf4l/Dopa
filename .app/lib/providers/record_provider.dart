import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/medical_record.dart';
import '../services/medical_record_service.dart';

final medicalRecordProvider = FutureProvider.autoDispose<List<MedicalRecord>>((ref) async {
  return MedicalRecordService.createDefault().fetchRecords();
});
