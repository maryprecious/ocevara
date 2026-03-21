import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/models/catch_log.dart';
import 'package:ocevara/core/repositories/i_catch_log_repository.dart';
import 'package:ocevara/core/services/api_service.dart';

/// Provides the concrete [CatchLogRepository] to the Riverpod tree.
final catchLogRepositoryProvider = Provider<ICatchLogRepository>((ref) {
  return CatchLogRepository(ref.read(apiServiceProvider));
});

/// Concrete implementation of [ICatchLogRepository].
/// Responsible for all catch log data operations via the API.
class CatchLogRepository implements ICatchLogRepository {
  final ApiService _apiService;

  CatchLogRepository(this._apiService);

  @override
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

  @override
  Future<bool> uploadCatch(String userId, CatchLog catchLog) async {
    try {
      final response = await _apiService.post(
        '/fish/users/$userId/catch-logs',
        data: catchLog.toJson(),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
