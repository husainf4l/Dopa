import 'dart:io';

import 'package:dio/dio.dart';
import '../models/medical_record.dart';
import 'api_client.dart';

class MedicalRecordService {
  MedicalRecordService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<MedicalRecord>> fetchRecords() async {
    final response = await _apiClient.client.get('/records');
    return (response.data as List)
        .map((json) => MedicalRecord.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> uploadRecord({required String title, String? description, required File file}) async {
    final formData = FormData.fromMap({
      'Title': title,
      'Description': description,
      'file': await MultipartFile.fromFile(file.path, filename: file.uri.pathSegments.last),
    });
    await _apiClient.client.post('/records', data: formData);
  }

  static MedicalRecordService createDefault() => MedicalRecordService(ApiClient());
}
