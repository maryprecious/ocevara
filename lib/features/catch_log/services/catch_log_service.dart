import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/models/catch_log.dart';
import 'package:ocevara/core/services/database_service.dart';
import 'package:ocevara/core/services/sync_service.dart';

final catchLogServiceProvider = StateNotifierProvider<CatchLogService, List<CatchLog>>((ref) {
  return CatchLogService.instance..setRef(ref);
});

class CatchLogService extends StateNotifier<List<CatchLog>> {
  static final CatchLogService instance = CatchLogService();

  CatchLogService() : super([]) {
    _loadLogs();
  }

  // Temporary species list, should ideally come from a SpeciesRepository
  final List<String> _speciesList = [
    'Red Snapper',
    'Grouper',
    'Tuna',
    'Tilapia',
    'Catfish',
    'Mackerel',
    'Salmon',
  ];

  Ref? _ref;

  void setRef(Ref ref) {
    _ref = ref;
  }

  List<String> get speciesList => _speciesList;

  Future<void> loadUserLogs(String userId) async {
    final logs = await DatabaseService.instance.getAllCatches(userId);
    state = logs;
  }

  Future<void> _loadLogs() async {
    // Legacy method, should ideally be replaced by loadUserLogs
  }

  int get totalLogs => state.length;
  int get totalFish => state.fold(0, (p, e) => p + e.quantity.toInt());
  double get totalWeightKg => state.fold(0.0, (p, e) => p + (e.avgWeight ?? 0.0) * e.quantity);
  int get speciesCount => state.map((e) => e.speciesName ?? e.speciesId).toSet().length;

  Future<void> addLog(CatchLog log) async {
    await DatabaseService.instance.insertCatch(log);
    state = [log, ...state];
    
    // Trigger sync fire-and-forget
    _ref?.read(syncServiceProvider).performSync(log.userId);
  }

  Future<void> deleteLog(String id) async {
    await DatabaseService.instance.deleteCatch(id);
    state = state.where((l) => l.id != id).toList();
  }

  void clearLogs() {
    state = [];
  }

  Future<void> markSynced(String id) async {
    final index = state.indexWhere((l) => l.id == id);
    if (index != -1) {
      final updated = state[index].copyWith(synced: true);
      await DatabaseService.instance.insertCatch(updated);
      state = [
        for (final log in state)
          if (log.id == id) updated else log
      ];
    }
  }

  void clear() {
    state = [];
  }
}
