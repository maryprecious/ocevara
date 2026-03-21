import 'package:ocevara/core/models/user.dart';

/// Abstract contract for the User/Profile data source.
/// ViewModels depend on this interface, not on the concrete implementation.
/// This satisfies the Dependency Inversion Principle (SOLID).
abstract class IUserRepository {
  /// Fetches the currently authenticated user's profile.
  Future<User?> getUserProfile();

  /// Updates the currently authenticated user's profile.
  /// Returns true on success.
  Future<bool> updateProfile(User user);
}
