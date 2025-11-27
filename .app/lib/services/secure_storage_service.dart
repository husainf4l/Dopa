import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;
  static const _tokenKey = 'dopa_token';
  static const _emailKey = 'dopa_email';
  static const _passwordKey = 'dopa_password';

  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);
  Future<String?> readToken() => _storage.read(key: _tokenKey);
  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _passwordKey, value: password);
  }

  Future<Map<String, String?>> readCredentials() async {
    final email = await _storage.read(key: _emailKey);
    final password = await _storage.read(key: _passwordKey);
    return {'email': email, 'password': password};
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _passwordKey);
  }

  Future<void> saveProfile(String userId, Map<String, dynamic> profileData) async {
    final key = 'profile_$userId';
    final jsonString = jsonEncode(profileData);
    await _storage.write(key: key, value: jsonString);
  }

  Future<Map<String, dynamic>?> readProfile(String userId) async {
    final key = 'profile_$userId';
    final jsonString = await _storage.read(key: key);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> saveProfilePhoto(String userId, String photoUrl) async {
    final key = 'profile_photo_$userId';
    await _storage.write(key: key, value: photoUrl);
  }

  Future<String?> readProfilePhoto(String userId) async {
    final key = 'profile_photo_$userId';
    return await _storage.read(key: key);
  }

  Future<void> clearProfilePhoto(String userId) async {
    final key = 'profile_photo_$userId';
    await _storage.delete(key: key);
  }

  Future<void> saveFamilyMembers(String userId, String membersJson) async {
    final key = 'family_members_$userId';
    await _storage.write(key: key, value: membersJson);
  }

  Future<String?> readFamilyMembers(String userId) async {
    final key = 'family_members_$userId';
    return await _storage.read(key: key);
  }

  Future<void> clearFamilyMembers(String userId) async {
    final key = 'family_members_$userId';
    await _storage.delete(key: key);
  }

  Future<void> saveFamilyMemberPhoto(String memberId, String photoUrl) async {
    final key = 'family_member_photo_$memberId';
    await _storage.write(key: key, value: photoUrl);
  }

  Future<String?> readFamilyMemberPhoto(String memberId) async {
    final key = 'family_member_photo_$memberId';
    return await _storage.read(key: key);
  }

  Future<void> clearFamilyMemberPhoto(String memberId) async {
    final key = 'family_member_photo_$memberId';
    await _storage.delete(key: key);
  }

  Future<String?> readSettings() async {
    return await _storage.read(key: 'app_settings');
  }

  Future<void> writeSettings(String settingsJson) async {
    await _storage.write(key: 'app_settings', value: settingsJson);
  }
}
