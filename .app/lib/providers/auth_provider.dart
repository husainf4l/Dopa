import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';

class AuthState {
  const AuthState({this.user, this.error, this.isLoading = false});

  final UserProfile? user;
  final String? error;
  final bool isLoading;

  AuthState copyWith({UserProfile? user, String? error, bool? isLoading}) => AuthState(
        user: user ?? this.user,
        error: error,
        isLoading: isLoading ?? this.isLoading,
      );
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._authService) : super(const AuthState());

  final AuthService _authService;

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _authService.login(email: email, password: password);
      state = AuthState(user: user);
    } catch (e) {
      String errorMsg = 'Login failed';
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
          errorMsg = 'Connection timeout. Check your network.';
        } else if (e.type == DioExceptionType.connectionError) {
          errorMsg = 'Cannot connect to server. Check API URL.';
        } else if (e.response != null) {
          errorMsg = e.response?.data['message'] ?? 'Server error: ${e.response?.statusCode}';
        }
      }
      state = AuthState(error: errorMsg);
    }
  }

  Future<void> register({required String email, required String password, required String name}) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _authService.register(email: email, password: password, name: name);
      state = AuthState(user: user);
    } catch (e) {
      String errorMsg = 'Registration failed';
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
          errorMsg = 'Connection timeout. Check your network.';
        } else if (e.type == DioExceptionType.connectionError) {
          errorMsg = 'Cannot connect to server. Check API URL.';
        } else if (e.response != null) {
          errorMsg = e.response?.data['message'] ?? 'Server error: ${e.response?.statusCode}';
        }
      }
      state = AuthState(error: errorMsg);
    }
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(AuthService.createDefault());
});
