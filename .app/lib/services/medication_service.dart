import 'package:dio/dio.dart';
import '../models/medication.dart';
import 'api_client.dart';

class MedicationService {
  MedicationService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Medication>> getMedications() async {
    final Response<dynamic> response = await _apiClient.client.get('/medications');
    return (response.data as List)
        .map((json) => Medication.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> createMedication(Map<String, dynamic> payload) => _apiClient.client.post('/medications', data: payload);

  static MedicationService createDefault() => MedicationService(ApiClient());
}
