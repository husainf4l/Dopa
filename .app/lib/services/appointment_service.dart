import '../models/appointment.dart';
import 'api_client.dart';

class AppointmentService {
  AppointmentService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Appointment>> fetchAppointments() async {
    final response = await _apiClient.client.get('/appointments');
    return (response.data as List)
        .map((json) => Appointment.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> createAppointment(Map<String, dynamic> payload) => _apiClient.client.post('/appointments', data: payload);

  static AppointmentService createDefault() => AppointmentService(ApiClient());
}
