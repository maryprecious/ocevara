import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/models/catch_log.dart';
import 'package:ocevara/core/services/catch_log_repository.dart';
import 'package:ocevara/core/services/database_service.dart';

final syncServiceProvider = Provider((ref) => SyncService(ref.read(catchLogRepositoryProvider)));

class SyncService {
  final CatchLogRepository _repository;

  SyncService(this._repository);

  Future<void> performSync(String userId) async {
    final unsyncedLogs = await _getUnsyncedLogs(userId);
    
    for (final log in unsyncedLogs) {
      try {
        final success = await _repository.uploadCatch(log.userId, log);
        if (success) {
          await _markLogAsSynced(log);
        }
      } catch (e) {
        
        continue;
      }
    }
  }

  Future<List<CatchLog>> _getUnsyncedLogs(String userId) async {
    final allLogs = await DatabaseService.instance.getAllCatches(userId);
    return allLogs.where((log) => !log.synced).toList();
  }

  Future<void> _markLogAsSynced(CatchLog log) async {
    final updatedLog = log.copyWith(synced: true);
    await DatabaseService.instance.insertCatch(updatedLog);
  }
}
