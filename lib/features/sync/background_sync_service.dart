import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:ocevara/core/services/api_service.dart';
import 'package:ocevara/core/services/auth_service.dart';
import 'package:ocevara/core/services/catch_log_repository.dart';
import 'package:ocevara/core/services/sync_service.dart';

const String _backgroundSyncTask = 'ocevara_background_sync_task';

@pragma('vm:entry-point')
void _callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Background isolate doesn't have access to the main Riverpod container
      // So we manually initialize the required services
      final apiService = ApiService();
      final authService = AuthService(apiService);
      final user = await authService.getCurrentUser();
      
      if (user != null) {
        final repository = CatchLogRepository(apiService);
        final syncService = SyncService(repository);
        await syncService.performSync(user.id);
      }
      return Future.value(true);
    } catch (e) {
      debugPrint('Background sync error: $e');
      return Future.value(false);
    }
  });
}

class BackgroundSyncService {
  /// Initialize background sync. Safe to call on all platforms.
  static Future<void> initialize() async {
    if (kIsWeb) return; // no background workers on web
    if (!(Platform.isAndroid || Platform.isIOS)) return;

    // initialize Workmanager and register a periodic task
    Workmanager().initialize(_callbackDispatcher, isInDebugMode: false);

    Workmanager().registerPeriodicTask(
      'ocevara_periodic_sync',
      _backgroundSyncTask,
      frequency: const Duration(hours: 1),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  }
}
