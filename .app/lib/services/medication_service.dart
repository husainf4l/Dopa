import 'package:dio/dio.dart';
import '../models/medication.dart';
import 'api_client.dart';

class MedicationService {
  MedicationService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Medication>> getMedications() async {
    try {
      final Response<dynamic> response = await _apiClient.client.get('/medications');
      
      // Handle null or empty response
      if (response.data == null) {
        return [];
      }
      
      // Handle non-list responses (like errors)
      if (response.data is! List) {
        print('[MedicationService] Unexpected response type: ${response.data.runtimeType}');
        return [];
      }
      
      return (response.data as List)
          .map((json) => Medication.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        print('[MedicationService] Server error (500): ${e.message}');
        // Return empty list for server errors instead of crashing
        return [];
      }
      rethrow;
    }
  }

  Future<void> createMedication(Map<String, dynamic> payload) async {
    try {
      await _apiClient.client.post('/medications', data: payload);
      print('[MedicationService] Medication created successfully');
    } on DioException catch (e) {
      print('[MedicationService] Failed to create medication: ${e.response?.statusCode}');
      print('[MedicationService] Error data: ${e.response?.data}');
      rethrow;
    }
  }

  Future<void> updateMedication(String id, Map<String, dynamic> payload) async {
    try {
      await _apiClient.client.put('/medications/$id', data: payload);
      print('[MedicationService] Medication updated successfully');
    } on DioException catch (e) {
      print('[MedicationService] Failed to update medication: ${e.response?.statusCode}');
      print('[MedicationService] Error data: ${e.response?.data}');
      rethrow;
    }
  }

  static MedicationService createDefault() => MedicationService(ApiClient());
}
