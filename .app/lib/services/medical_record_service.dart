import 'dart:io';

import 'package:dio/dio.dart';
import '../models/medical_record.dart';
import '../models/medication.dart';
import '../models/vaccine_dose.dart';
import '../models/appointment.dart';
import 'api_client.dart';

class MedicalRecordService {
  MedicalRecordService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<MedicalRecord>> fetchRecords() async {
    final records = <MedicalRecord>[];

    try {
      // Fetch medications
      try {
        final medicationResponse = await _apiClient.client.get('/medications');
        final medications = (medicationResponse.data as List)
            .map((json) => Medication.fromJson(json as Map<String, dynamic>))
            .toList();
        records.addAll(medications.map((med) => MedicalRecord.fromMedication(med)));
        print('Fetched ${medications.length} medications');
      } catch (e) {
        print('Error fetching medications: $e');
      }

      // Fetch vaccinations
      try {
        final vaccinationResponse = await _apiClient.client.get('/vaccinations');
        final vaccinations = (vaccinationResponse.data as List)
            .map((json) => VaccineDose.fromJson(json as Map<String, dynamic>))
            .toList();
        records.addAll(vaccinations.map((vac) => MedicalRecord.fromVaccination(vac)));
        print('Fetched ${vaccinations.length} vaccinations');
      } catch (e) {
        print('Error fetching vaccinations: $e');
      }

      // Fetch appointments
      try {
        final appointmentResponse = await _apiClient.client.get('/appointments');
        final appointments = (appointmentResponse.data as List)
            .map((json) => Appointment.fromJson(json as Map<String, dynamic>))
            .toList();
        records.addAll(appointments.map((appt) => MedicalRecord.fromAppointment(appt)));
        print('Fetched ${appointments.length} appointments');
      } catch (e) {
        print('Error fetching appointments: $e');
      }

      print('Total medical records fetched: ${records.length}');

    } catch (e) {
      print('General error fetching medical records: $e');
    }

    return records;
  }

  Future<void> uploadRecord({required String title, String? description, required File file}) async {
    final formData = FormData.fromMap({
      'Title': title,
      'Description': description,
      'file': await MultipartFile.fromFile(file.path, filename: file.uri.pathSegments.last),
    });
    await _apiClient.client.post('/records', data: formData);
  }

  Future<void> updateRecord(String recordId, {required String title, String? description}) async {
    final data = {
      'Title': title,
      'Description': description,
    };
    await _apiClient.client.put('/records/$recordId', data: data);
  }

  Future<void> deleteRecord(String recordId) async {
    await _apiClient.client.delete('/records/$recordId');
  }

  static MedicalRecordService createDefault() => MedicalRecordService(ApiClient());
}
