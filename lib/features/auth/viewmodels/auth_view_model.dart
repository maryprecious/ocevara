import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/models/user.dart';
import 'package:ocevara/core/repositories/i_auth_repository.dart';
import 'package:ocevara/features/auth/repositories/auth_repository.dart';


/// Represents all possible states of the authentication flow.
/// Using a sealed/union-style class keeps state transitions explicit.
class AuthState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  /// Initial idle state
  const AuthState.initial()
      : user = null,
        isLoading = false,
        errorMessage = null;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}


/// Provides the [AuthViewModel] to the widget tree.
/// Screens watch this provider to react to auth state changes.
final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel(ref.read(authRepositoryProvider));
});


/// Manages the authentication state for the entire app.
class AuthViewModel extends StateNotifier<AuthState> {
  final IAuthRepository _repository;

  AuthViewModel(this._repository) : super(const AuthState.initial());

  /// Logs in a user with [identifier] and [password].
  Future<bool> login(String identifier, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.login(identifier, password);
      if (user != null) {
        state = state.copyWith(user: user, isLoading: false);
        return true;
      }
      state = state.copyWith(isLoading: false, errorMessage: 'Login failed');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Registers a new user account.
  Future<bool> register({
    required String fullName,
    required String phoneNumber,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final success = await _repository.register(
        fullName: fullName,
        phoneNumber: phoneNumber,
        password: password,
      );
      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Verifies OTP and transitions to authenticated state on success.
  Future<bool> verifyOTP({
    String? email,
    String? phone_number,
    required String otp,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.verifyOTP(
        email: email,
        phone_number: phone_number,
        otp: otp,
      );
      if (user != null) {
        state = state.copyWith(user: user, isLoading: false);
        return true;
      }
      state = state.copyWith(
          isLoading: false, errorMessage: 'OTP verification failed');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Resends OTP code.
  Future<bool> resendOTP({
    String? email,
    String? phone_number,
    required String purpose,
  }) async {
    try {
      return await _repository.resendOTP(
        email: email,
        phone_number: phone_number,
        purpose: purpose,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  /// Requests a password reset for the given identifier.
  Future<bool> requestPasswordReset(String identifier) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final success = await _repository.requestPasswordReset(identifier);
      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Confirms a password reset with an OTP and new password.
  Future<bool> resetPassword({
    String? email,
    String? phone_number,
    required String otp,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final success = await _repository.resetPassword(
        email: email,
        phone_number: phone_number,
        otp: otp,
        newPassword: newPassword,
      );
      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Logs the current user out and resets auth state.
  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState.initial();
  }

  /// Clears any displayed error message.
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
