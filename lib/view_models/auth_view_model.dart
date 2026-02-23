import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:notely/core/services/auth_service.dart';

enum AuthState { idle, loading, success, error }

class AuthViewModel extends StateNotifier<AuthState> {
  AuthViewModel() : super(AuthState.idle);

  Future<bool> login(String email, String password) async {
    state = AuthState.loading;

    final result = await AuthService.login(email, password);

    if (result) {
      state = AuthState.success;
      return true;
    } else {
      state = AuthState.error;
      return false;
    }
  }
}

final authProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel();
});