import 'package:dio/dio.dart';
import '../models/appointment.dart';
import 'api_client.dart';

class AppointmentService {
  AppointmentService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Appointment>> fetchAppointments() async {
    try {
      final response = await _apiClient.client.get('/appointments');
      
      if (response.data == null || response.data is! List) {
        print('[AppointmentService] Unexpected response type: ${response.data?.runtimeType}');
        return [];
      }
      
      return (response.data as List)
          .map((json) => Appointment.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        print('[AppointmentService] Server error (500): ${e.message}');
        return [];
      }
      rethrow;
    }
  }

  Future<void> createAppointment(Map<String, dynamic> payload) async {
    try {
      await _apiClient.client.post('/appointments', data: payload);
      print('[AppointmentService] Appointment created successfully');
    } on DioException catch (e) {
      print('[AppointmentService] Failed to create appointment: ${e.response?.statusCode}');
      print('[AppointmentService] Error data: ${e.response?.data}');
      rethrow;
    }
  }

  Future<void> updateAppointment(String id, Map<String, dynamic> payload) async {
    try {
      await _apiClient.client.put('/appointments/$id', data: payload);
      print('[AppointmentService] Appointment updated successfully');
    } on DioException catch (e) {
      print('[AppointmentService] Failed to update appointment: ${e.response?.statusCode}');
      print('[AppointmentService] Error data: ${e.response?.data}');
      rethrow;
    }
  }

  static AppointmentService createDefault() => AppointmentService(ApiClient());
}
