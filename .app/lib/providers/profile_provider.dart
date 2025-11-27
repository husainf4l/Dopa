import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';

class ProfileState {
  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.error,
  });

  final UserProfile? profile;
  final bool isLoading;
  final String? error;

  ProfileState copyWith({
    UserProfile? profile,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class ProfileController extends StateNotifier<ProfileState> {
  ProfileController(this._profileService) : super(const ProfileState());

  final ProfileService _profileService;

  Future<void> loadProfile(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final profile = await _profileService.getProfile(userId);
      state = ProfileState(profile: profile);
    } catch (e) {
      state = ProfileState(error: e.toString());
    }
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> updates) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedProfile = await _profileService.updateProfile(userId, updates);
      state = ProfileState(profile: updatedProfile);
    } catch (e) {
      state = ProfileState(error: e.toString());
    }
  }

  Future<void> uploadProfilePhoto(String userId, String imagePath) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final photoUrl = await _profileService.uploadProfilePhoto(userId, imagePath);
      if (photoUrl != null && state.profile != null) {
        final updatedProfile = state.profile!.copyWith(profilePhotoUrl: photoUrl);
        state = ProfileState(profile: updatedProfile);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> deleteProfilePhoto(String userId) async {
    try {
      await _profileService.deleteProfilePhoto(userId);
      if (state.profile != null) {
        final updatedProfile = state.profile!.copyWith(profilePhotoUrl: null);
        state = state.copyWith(profile: updatedProfile);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void updateLocalProfile(UserProfile updatedProfile) {
    state = state.copyWith(profile: updatedProfile);
  }
}

final profileControllerProvider = StateNotifierProvider<ProfileController, ProfileState>((ref) {
  return ProfileController(ProfileService.createDefault());
});