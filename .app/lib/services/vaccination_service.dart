import 'package:dio/dio.dart';
import '../models/vaccine_dose.dart';
import 'api_client.dart';

class VaccinationService {
  VaccinationService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<VaccineDose>> fetchDoses() async {
    try {
      final response = await _apiClient.client.get('/vaccinations');
      
      if (response.data == null || response.data is! List) {
        print('[VaccinationService] Unexpected response type: ${response.data?.runtimeType}');
        return [];
      }
      
      return (response.data as List)
          .map((json) => VaccineDose.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        print('[VaccinationService] Server error (500): ${e.message}');
        return [];
      }
      rethrow;
    }
  }

  Future<void> createDose(Map<String, dynamic> payload) async {
    try {
      await _apiClient.client.post('/vaccinations', data: payload);
      print('[VaccinationService] Vaccination created successfully');
    } on DioException catch (e) {
      print('[VaccinationService] Failed to create vaccination: ${e.response?.statusCode}');
      print('[VaccinationService] Error data: ${e.response?.data}');
      rethrow;
    }
  }

  Future<void> updateDose(String id, Map<String, dynamic> payload) async {
    try {
      await _apiClient.client.put('/vaccinations/$id', data: payload);
      print('[VaccinationService] Vaccination updated successfully');
    } on DioException catch (e) {
      print('[VaccinationService] Failed to update vaccination: ${e.response?.statusCode}');
      print('[VaccinationService] Error data: ${e.response?.data}');
      rethrow;
    }
  }

  static VaccinationService createDefault() => VaccinationService(ApiClient());
}
