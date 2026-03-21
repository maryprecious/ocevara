import 'package:ocevara/core/models/catch_log.dart';

/// Abstract contract for the Catch Log data source.
/// ViewModels depend on this interface, not on the concrete implementation.
/// This satisfies the Dependency Inversion Principle (SOLID).
abstract class ICatchLogRepository {
  /// Fetches all catch logs for a given [userId].
  Future<List<CatchLog>> getCatches(String userId);

  /// Uploads a new [catchLog] entry for the given [userId].
  /// Returns true on success.
  Future<bool> uploadCatch(String userId, CatchLog catchLog);
}
