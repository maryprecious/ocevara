import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/models/user.dart';
import 'package:ocevara/core/repositories/i_user_repository.dart';
import 'package:ocevara/core/services/api_service.dart';

/// Provides the concrete [UserRepository] to the Riverpod tree.
final userRepositoryProvider = Provider<IUserRepository>((ref) {
  return UserRepository(ref.read(apiServiceProvider));
});

/// Concrete implementation of [IUserRepository].
/// Responsible for all user profile data operations via the API.
class UserRepository implements IUserRepository {
  final ApiService _apiService;

  UserRepository(this._apiService);

  @override
  Future<User?> getUserProfile() async {
    try {
      final response = await _apiService.get('/fish/users/profile');
      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return User.fromJson(data);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  @override
  Future<bool> updateProfile(User user) async {
    try {
      final response = await _apiService.put(
        '/fish/users/profile',
        data: user.toJson(),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
