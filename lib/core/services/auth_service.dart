import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:ocevara/core/models/user.dart';
import 'package:ocevara/core/services/api_service.dart';
import 'package:ocevara/features/catch_log/services/catch_log_service.dart';

final authServiceProvider = Provider((ref) => AuthService(ref.read(apiServiceProvider)));

final userProvider = StateProvider<User?>((ref) => null);

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  Future<User?> login(String identifier, String password) async {
    try {
      final isEmail = identifier.contains('@');
      final response = await _apiService.post('/fish/auth/login', data: {
        if (isEmail) 'email': identifier else 'phone_number': identifier,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['data']['accessToken'];
        final userData = response.data['data']['user'];
        
        await _apiService.saveToken(token);
        return User.fromJson(userData);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'An unexpected error occurred';
    }
    return null;
  }

  Future<bool> register({
    required String fullName,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await _apiService.post('/fish/auth/register', data: {
        'full_name': fullName,
        'phone_number': phoneNumber,
        'password': password,
        'role': 'fisher',
      });

      return response.statusCode == 201;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Registration failed';
    }
  }

  Future<User?> verifyOTP({
    String? email,
    String? phone_number,
    required String otp,
  }) async {
    try {
      final response = await _apiService.post('/fish/auth/verify', data: {
        if (email != null) 'email': email,
        if (phone_number != null) 'phone_number': phone_number,
        'otp': otp,
      });

      if (response.statusCode == 200) {
        final token = response.data['data']['accessToken'];
        final userData = response.data['data']['user'];
        
        await _apiService.saveToken(token);
        return User.fromJson(userData);
      }
      return null;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Verification failed: ${e.toString()}';
    }
  }

  Future<bool> resendOTP({
    String? email,
    String? phone_number,
    required String purpose,
  }) async {
    try {
      final response = await _apiService.post('/fish/auth/resend-otp', data: {
        if (email != null) 'email': email,
        if (phone_number != null) 'phone_number': phone_number,
        'purpose': purpose,
      });

      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> requestPasswordReset(String identifier) async {
    try {
      final isEmail = identifier.contains('@');
      final response = await _apiService.post('/fish/auth/password-reset/request', data: {
        if (isEmail) 'email': identifier else 'phone_number': identifier,
      });

      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> resetPassword({
    String? email,
    String? phone_number,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.post('/fish/auth/password-reset/confirm', data: {
        if (email != null) 'email': email,
        if (phone_number != null) 'phone_number': phone_number,
        'otp': otp,
        'new_password': newPassword,
      });

      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _apiService.clearToken();
    try {
      // Clear the local state so the next user doesn't see old data
      CatchLogService.instance.clear(); 
    } catch (_) {}
  }

  Future<User?> updateProfile({String? fullName, String? profileImageUrl, required WidgetRef ref}) async {
    try {
      final response = await _apiService.put('/fish/users/profile', data: {
        if (fullName != null) 'full_name': fullName,
        if (profileImageUrl != null) 'profile_image_url': profileImageUrl,
      });

      if (response.statusCode == 200) {
        final userData = response.data['data']['user'];
        final updatedUser = User.fromJson(userData);
        ref.read(userProvider.notifier).state = updatedUser;
        return updatedUser;
      }
      return null;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Update failed';
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return null;

      final response = await _apiService.get('/fish/auth/me'); 
      
      if (response.statusCode == 200) {
        final userData = response.data['data']['user'];
        return User.fromJson(userData);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  String _handleDioError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final data = e.response?.data;
      if (data is Map && data.containsKey('error')) {
        return data['error']['message'] ?? 'An error occurred';
      }
    }
    return e.message ?? 'Connection failed';
  }
}
