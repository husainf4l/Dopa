import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/family_member.dart';
import 'api_client.dart';
import 'secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class FamilyService {
  FamilyService(this._apiClient, this._storageService);

  final ApiClient _apiClient;
  final SecureStorageService _storageService;
  final _uuid = const Uuid();

  Future<List<FamilyMember>> getFamilyMembers(String userId) async {
    try {
      final response = await _apiClient.client.get('/users/$userId/family-members');
      final List<dynamic> data = response.data;
      final members = data.map((json) => FamilyMember.fromJson(json)).toList();
      // Save locally as backup
      await _saveLocalFamilyMembers(userId, members);
      return members;
    } catch (e) {
      // If API fails, load from local storage
      print('API get family members failed, loading locally: $e');
      return await _loadLocalFamilyMembers(userId);
    }
  }

  Future<FamilyMember> addFamilyMember(String userId, FamilyMember member) async {
    try {
      final memberData = member.toJson();
      memberData.remove('id'); // Remove ID for creation
      memberData['createdAt'] = DateTime.now().toIso8601String();
      memberData['updatedAt'] = DateTime.now().toIso8601String();

      final response = await _apiClient.client.post('/users/$userId/family-members', data: memberData);
      final newMember = FamilyMember.fromJson(response.data);

      // Update local storage
      final members = await _loadLocalFamilyMembers(userId);
      members.add(newMember);
      await _saveLocalFamilyMembers(userId, members);

      return newMember;
    } catch (e) {
      // If API fails, save locally with generated ID
      print('API add family member failed, saving locally: $e');
      final newMember = member.copyWith(
        id: _uuid.v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final members = await _loadLocalFamilyMembers(userId);
      members.add(newMember);
      await _saveLocalFamilyMembers(userId, members);

      return newMember;
    }
  }

  Future<FamilyMember> updateFamilyMember(String userId, String memberId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = DateTime.now().toIso8601String();
      final response = await _apiClient.client.put('/users/$userId/family-members/$memberId', data: updates);
      final updatedMember = FamilyMember.fromJson(response.data);

      // Update local storage
      final members = await _loadLocalFamilyMembers(userId);
      final index = members.indexWhere((m) => m.id == memberId);
      if (index != -1) {
        members[index] = updatedMember;
        await _saveLocalFamilyMembers(userId, members);
      }

      return updatedMember;
    } catch (e) {
      // If API fails, update locally
      print('API update family member failed, updating locally: $e');
      final members = await _loadLocalFamilyMembers(userId);
      final index = members.indexWhere((m) => m.id == memberId);
      if (index != -1) {
        final currentMember = members[index];
        final updatedMember = currentMember.copyWith(
          fullName: updates['fullName'] as String?,
          relationship: updates['relationship'] as String?,
          dateOfBirth: updates['dateOfBirth'] != null ? DateTime.parse(updates['dateOfBirth']) : null,
          phoneNumber: updates['phoneNumber'] as String?,
          bloodType: updates['bloodType'] as String?,
          address: updates['address'] as String?,
          updatedAt: DateTime.now(),
        );
        members[index] = updatedMember;
        await _saveLocalFamilyMembers(userId, members);
        return updatedMember;
      }
      throw Exception('Family member not found');
    }
  }

  Future<void> deleteFamilyMember(String userId, String memberId) async {
    try {
      await _apiClient.client.delete('/users/$userId/family-members/$memberId');

      // Update local storage
      final members = await _loadLocalFamilyMembers(userId);
      members.removeWhere((m) => m.id == memberId);
      await _saveLocalFamilyMembers(userId, members);
    } catch (e) {
      // If API fails, delete locally
      print('API delete family member failed, deleting locally: $e');
      final members = await _loadLocalFamilyMembers(userId);
      members.removeWhere((m) => m.id == memberId);
      await _saveLocalFamilyMembers(userId, members);
    }
  }

  Future<String?> uploadFamilyMemberPhoto(String userId, String memberId, String imagePath) async {
    try {
      // For now, we'll store the local file path
      // In a real implementation, you'd upload to a server and get back a URL
      await _storageService.saveFamilyMemberPhoto(memberId, imagePath);
      return imagePath;
    } catch (e) {
      print('Family member photo upload failed: $e');
      return null;
    }
  }

  Future<String?> getFamilyMemberPhoto(String memberId) async {
    return await _storageService.readFamilyMemberPhoto(memberId);
  }

  Future<void> deleteFamilyMemberPhoto(String memberId) async {
    await _storageService.clearFamilyMemberPhoto(memberId);
  }

  Future<List<FamilyMember>> _loadLocalFamilyMembers(String userId) async {
    final membersJson = await _storageService.readFamilyMembers(userId);
    if (membersJson != null) {
      final List<dynamic> data = jsonDecode(membersJson);
      return data.map((json) => FamilyMember.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> _saveLocalFamilyMembers(String userId, List<FamilyMember> members) async {
    final membersJson = jsonEncode(members.map((m) => m.toJson()).toList());
    await _storageService.saveFamilyMembers(userId, membersJson);
  }

  static FamilyService createDefault() => FamilyService(
    ApiClient(),
    SecureStorageService(const FlutterSecureStorage()),
  );
}