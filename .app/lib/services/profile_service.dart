import 'package:dio/dio.dart';
import '../models/user_profile.dart';
import 'api_client.dart';
import 'secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileService {
  ProfileService(this._apiClient, this._storageService);

  final ApiClient _apiClient;
  final SecureStorageService _storageService;

  Future<UserProfile> updateProfile(String userId, Map<String, dynamic> updates) async {
    try {
      final response = await _apiClient.client.put('/users/$userId/profile', data: updates);
      return UserProfile.fromJson(response.data);
    } catch (e) {
      // If API fails, save locally and return updated profile
      print('API update failed, saving locally: $e');
      final currentProfile = await _loadLocalProfile(userId);
      final updatedProfile = currentProfile.copyWith(
        dateOfBirth: updates['dateOfBirth'] != null ? DateTime.parse(updates['dateOfBirth']) : null,
        phoneNumber: updates['phoneNumber'] as String?,
        bloodType: updates['bloodType'] as String?,
        address: updates['address'] as String?,
      );
      await _saveLocalProfile(userId, updatedProfile);
      return updatedProfile;
    }
  }

  Future<UserProfile> getProfile(String userId) async {
    try {
      final response = await _apiClient.client.get('/users/$userId/profile');
      final profile = UserProfile.fromJson(response.data);
      // Save locally as backup
      await _saveLocalProfile(userId, profile);
      return profile;
    } catch (e) {
      // If API fails, load from local storage
      print('API get failed, loading locally: $e');
      return await _loadLocalProfile(userId);
    }
  }

  Future<UserProfile> _loadLocalProfile(String userId) async {
    final profileJson = await _storageService.readProfile(userId);
    if (profileJson != null) {
      return UserProfile.fromJson(profileJson);
    }
    // Return empty profile if nothing saved locally
    return UserProfile(
      id: userId,
      email: '', // This should be filled from auth
      fullName: '', // This should be filled from auth
    );
  }

  Future<String?> uploadProfilePhoto(String userId, String imagePath) async {
    try {
      // For now, we'll store the local file path
      // In a real implementation, you'd upload to a server and get back a URL
      await _storageService.saveProfilePhoto(userId, imagePath);
      return imagePath;
    } catch (e) {
      print('Photo upload failed: $e');
      return null;
    }
  }

  Future<String?> getProfilePhoto(String userId) async {
    return await _storageService.readProfilePhoto(userId);
  }

  Future<void> deleteProfilePhoto(String userId) async {
    await _storageService.clearProfilePhoto(userId);
  }

  Future<void> _saveLocalProfile(String userId, UserProfile profile) async {
    await _storageService.saveProfile(userId, profile.toJson());
  }

  static ProfileService createDefault() => ProfileService(
    ApiClient(),
    SecureStorageService(const FlutterSecureStorage()),
  );
}