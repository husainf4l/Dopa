import '../models/vaccine_dose.dart';
import 'api_client.dart';

class VaccinationService {
  VaccinationService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<VaccineDose>> fetchDoses() async {
    final response = await _apiClient.client.get('/vaccinations');
    return (response.data as List)
        .map((json) => VaccineDose.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> createDose(Map<String, dynamic> payload) => _apiClient.client.post('/vaccinations', data: payload);

  static VaccinationService createDefault() => VaccinationService(ApiClient());
}
