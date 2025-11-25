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
      state = AuthState(error: e.toString());
    }
  }

  Future<void> register({required String email, required String password, required String name}) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _authService.register(email: email, password: password, name: name);
      state = AuthState(user: user);
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(AuthService.createDefault());
});
