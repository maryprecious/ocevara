import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/models/catch_log.dart';
import 'package:ocevara/core/services/api_service.dart';

final catchLogRepositoryProvider = Provider((ref) => CatchLogRepository(ref.read(apiServiceProvider)));

class CatchLogRepository {
  final ApiService _apiService;

  CatchLogRepository(this._apiService);

  Future<List<CatchLog>> getCatches(String userId) async {
    try {
      final response = await _apiService.get('/fish/users/$userId/catch-logs');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data.map((item) => CatchLog.fromJson(item)).toList();
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  Future<bool> uploadCatch(String userId, CatchLog catchLog) async {
    try {
      final response = await _apiService.post('/fish/users/$userId/catch-logs', data: catchLog.toJson());
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
