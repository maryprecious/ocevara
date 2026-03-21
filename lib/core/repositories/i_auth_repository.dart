import 'package:ocevara/core/models/user.dart';

/// Abstract contract for the Authentication data source.
/// The AuthViewModel depends on this interface, not on AuthService directly.
/// This satisfies the Dependency Inversion Principle (SOLID).
abstract class IAuthRepository {
  /// Logs in a user with [identifier] (email or phone) and [password].
  /// Returns the authenticated [User] on success, or throws a [String] error message.
  Future<User?> login(String identifier, String password);

  /// Registers a new user. Returns true on success.
  Future<bool> register({
    required String fullName,
    required String phoneNumber,
    required String password,
  });

  /// Verifies OTP for the given [email] or [phone_number].
  /// Returns the authenticated [User] on success.
  Future<User?> verifyOTP({
    String? email,
    String? phone_number,
    required String otp,
  });

  /// Resends the OTP to the given [email] or [phone_number] for a given [purpose].
  Future<bool> resendOTP({
    String? email,
    String? phone_number,
    required String purpose,
  });

  /// Requests a password reset for the given [identifier] (email or phone).
  Future<bool> requestPasswordReset(String identifier);

  /// Confirms password reset with an [otp] and [newPassword].
  Future<bool> resetPassword({
    String? email,
    String? phone_number,
    required String otp,
    required String newPassword,
  });

  /// Logs the current user out by clearing local tokens.
  Future<void> logout();
}
