import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/secure_storage_service.dart';

class SettingsState {
  final bool notificationsEnabled;
  final bool dataSharingEnabled;
  final String language;
  final bool biometricEnabled;
  final bool autoBackupEnabled;

  const SettingsState({
    this.notificationsEnabled = true,
    this.dataSharingEnabled = false,
    this.language = 'en',
    this.biometricEnabled = false,
    this.autoBackupEnabled = true,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    bool? dataSharingEnabled,
    String? language,
    bool? biometricEnabled,
    bool? autoBackupEnabled,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dataSharingEnabled: dataSharingEnabled ?? this.dataSharingEnabled,
      language: language ?? this.language,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier(this._storageService) : super(const SettingsState()) {
    _loadSettings();
  }

  final SecureStorageService _storageService;
  static const _settingsKey = 'app_settings';

  Future<void> _loadSettings() async {
    try {
      final settingsJson = await _storageService.readSettings();
      if (settingsJson != null) {
        final settings = jsonDecode(settingsJson) as Map<String, dynamic>;
        state = SettingsState(
          notificationsEnabled: settings['notificationsEnabled'] ?? true,
          dataSharingEnabled: settings['dataSharingEnabled'] ?? false,
          language: settings['language'] ?? 'en',
          biometricEnabled: settings['biometricEnabled'] ?? false,
          autoBackupEnabled: settings['autoBackupEnabled'] ?? true,
        );
      }
    } catch (e) {
      // Use default settings if loading fails
      print('Error loading settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final settings = {
        'notificationsEnabled': state.notificationsEnabled,
        'dataSharingEnabled': state.dataSharingEnabled,
        'language': state.language,
        'biometricEnabled': state.biometricEnabled,
        'autoBackupEnabled': state.autoBackupEnabled,
      };
      final settingsJson = jsonEncode(settings);
      await _storageService.writeSettings(settingsJson);
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    state = state.copyWith(notificationsEnabled: enabled);
    await _saveSettings();
  }

  Future<void> setDataSharingEnabled(bool enabled) async {
    state = state.copyWith(dataSharingEnabled: enabled);
    await _saveSettings();
  }

  Future<void> setLanguage(String language) async {
    state = state.copyWith(language: language);
    await _saveSettings();
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    state = state.copyWith(biometricEnabled: enabled);
    await _saveSettings();
  }

  Future<void> setAutoBackupEnabled(bool enabled) async {
    state = state.copyWith(autoBackupEnabled: enabled);
    await _saveSettings();
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final storage = SecureStorageService(const FlutterSecureStorage());
  return SettingsNotifier(storage);
});