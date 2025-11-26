import 'package:dio/dio.dart';
import '../models/auth_token.dart';
import '../models/user_profile.dart';
import 'api_client.dart';
import 'secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  AuthService(this._apiClient, this._storageService);

  final ApiClient _apiClient;
  final SecureStorageService _storageService;

  Future<UserProfile> register({required String email, required String password, required String name}) async {
    final response = await _apiClient.client.post('/auth/register', data: {
      'email': email,
      'password': password,
      'fullName': name,
    });
    await _persistToken(response.data);
    await _storageService.saveCredentials(email, password);
    return _profileFromResponse(response.data);
  }

  Future<UserProfile> login({required String email, required String password}) async {
    final response = await _apiClient.client.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    await _persistToken(response.data);
    await _storageService.saveCredentials(email, password);
    return _profileFromResponse(response.data);
  }

  Future<void> logout() async {
    await _storageService.clearToken();
    await _storageService.clearCredentials();
  }

  Future<void> _persistToken(Map<String, dynamic> json) async {
    final token = AuthToken.fromJson(json);
    await _storageService.saveToken(token.token);
  }

  UserProfile _profileFromResponse(Map<String, dynamic> json) => UserProfile(
        id: json['userId'] as String,
        email: json['email'] as String,
        fullName: json['fullName'] as String,
      );

  static AuthService createDefault() => AuthService(ApiClient(), SecureStorageService(const FlutterSecureStorage()));
}
