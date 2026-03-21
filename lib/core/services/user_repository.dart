import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/models/user.dart';
import 'package:ocevara/core/services/api_service.dart';

final userRepositoryProvider = Provider((ref) => UserRepository(ref.read(apiServiceProvider)));

class UserRepository {
  final ApiService _apiService;

  UserRepository(this._apiService);

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

  Future<bool> updateProfile(User user) async {
    try {
      final response = await _apiService.put('/fish/users/profile', data: user.toJson());
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
