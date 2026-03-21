import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/models/user.dart';
import 'package:ocevara/core/repositories/i_auth_repository.dart';
import 'package:ocevara/core/services/auth_service.dart';

/// Provides the concrete [AuthRepository] to the Riverpod tree.
/// Any class that needs auth data should depend on [authRepositoryProvider].
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository(ref.read(authServiceProvider));
});

/// Concrete implementation of [IAuthRepository].
/// Delegates all work to [AuthService] (the low-level HTTP-knowing service).
/// Screens and ViewModels never touch AuthService directly.
class AuthRepository implements IAuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  @override
  Future<User?> login(String identifier, String password) {
    return _authService.login(identifier, password);
  }

  @override
  Future<bool> register({
    required String fullName,
    required String phoneNumber,
    required String password,
  }) {
    return _authService.register(
      fullName: fullName,
      phoneNumber: phoneNumber,
      password: password,
    );
  }

  @override
  Future<User?> verifyOTP({
    String? email,
    String? phone_number,
    required String otp,
  }) {
    return _authService.verifyOTP(
      email: email,
      phone_number: phone_number,
      otp: otp,
    );
  }

  @override
  Future<bool> resendOTP({
    String? email,
    String? phone_number,
    required String purpose,
  }) {
    return _authService.resendOTP(
      email: email,
      phone_number: phone_number,
      purpose: purpose,
    );
  }

  @override
  Future<bool> requestPasswordReset(String identifier) {
    return _authService.requestPasswordReset(identifier);
  }

  @override
  Future<bool> resetPassword({
    String? email,
    String? phone_number,
    required String otp,
    required String newPassword,
  }) {
    return _authService.resetPassword(
      email: email,
      phone_number: phone_number,
      otp: otp,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> logout() {
    return _authService.logout();
  }
}
