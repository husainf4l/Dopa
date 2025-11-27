import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/family_member.dart';
import '../services/family_service.dart';

class FamilyState {
  const FamilyState({
    this.members = const [],
    this.isLoading = false,
    this.error,
  });

  final List<FamilyMember> members;
  final bool isLoading;
  final String? error;

  FamilyState copyWith({
    List<FamilyMember>? members,
    bool? isLoading,
    String? error,
  }) {
    return FamilyState(
      members: members ?? this.members,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class FamilyController extends StateNotifier<FamilyState> {
  FamilyController(this._familyService) : super(const FamilyState());

  final FamilyService _familyService;

  Future<void> loadFamilyMembers(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final members = await _familyService.getFamilyMembers(userId);
      state = FamilyState(members: members);
    } catch (e) {
      state = FamilyState(error: e.toString());
    }
  }

  Future<void> addFamilyMember(String userId, FamilyMember member) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newMember = await _familyService.addFamilyMember(userId, member);
      final updatedMembers = [...state.members, newMember];
      state = FamilyState(members: updatedMembers);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> updateFamilyMember(String userId, String memberId, Map<String, dynamic> updates) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedMember = await _familyService.updateFamilyMember(userId, memberId, updates);
      final updatedMembers = state.members.map((member) {
        return member.id == memberId ? updatedMember : member;
      }).toList();
      state = FamilyState(members: updatedMembers);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> deleteFamilyMember(String userId, String memberId) async {
    try {
      await _familyService.deleteFamilyMember(userId, memberId);
      final updatedMembers = state.members.where((member) => member.id != memberId).toList();
      state = state.copyWith(members: updatedMembers);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> uploadFamilyMemberPhoto(String userId, String memberId, String imagePath) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final photoUrl = await _familyService.uploadFamilyMemberPhoto(userId, memberId, imagePath);
      if (photoUrl != null) {
        final updatedMembers = state.members.map((member) {
          return member.id == memberId ? member.copyWith(profilePhotoUrl: photoUrl) : member;
        }).toList();
        state = FamilyState(members: updatedMembers);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> deleteFamilyMemberPhoto(String memberId) async {
    try {
      await _familyService.deleteFamilyMemberPhoto(memberId);
      final updatedMembers = state.members.map((member) {
        return member.id == memberId ? member.copyWith(profilePhotoUrl: null) : member;
      }).toList();
      state = state.copyWith(members: updatedMembers);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void updateLocalMembers(List<FamilyMember> members) {
    state = state.copyWith(members: members);
  }
}

final familyControllerProvider = StateNotifierProvider<FamilyController, FamilyState>((ref) {
  return FamilyController(FamilyService.createDefault());
});