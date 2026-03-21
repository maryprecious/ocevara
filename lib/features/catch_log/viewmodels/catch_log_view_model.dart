import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/models/catch_log.dart';
import 'package:ocevara/core/repositories/i_catch_log_repository.dart';
import 'package:ocevara/features/catch_log/repositories/catch_log_repository.dart';


class CatchLogState {
  final List<CatchLog> catches;
  final bool isLoading;
  final String? errorMessage;

  const CatchLogState({
    this.catches = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  const CatchLogState.initial()
      : catches = const [],
        isLoading = false,
        errorMessage = null;

  CatchLogState copyWith({
    List<CatchLog>? catches,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CatchLogState(
      catches: catches ?? this.catches,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}


/// Provides the [CatchLogViewModel] to the widget tree.
final catchLogViewModelProvider =
    StateNotifierProvider<CatchLogViewModel, CatchLogState>((ref) {
  return CatchLogViewModel(ref.read(catchLogRepositoryProvider));
});


/// Manages all state related to catch logs.
class CatchLogViewModel extends StateNotifier<CatchLogState> {
  final ICatchLogRepository _repository;

  CatchLogViewModel(this._repository) : super(const CatchLogState.initial());

  /// Loads all catch logs for the given [userId].
  Future<void> loadCatches(String userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final catches = await _repository.getCatches(userId);
      state = state.copyWith(catches: catches, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load catch logs: ${e.toString()}',
      );
    }
  }

  /// Uploads a new [catchLog] for the given [userId].
  /// On success, refreshes the local list.
  Future<bool> uploadCatch(String userId, CatchLog catchLog) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final success = await _repository.uploadCatch(userId, catchLog);
      if (success) {
        // Optimistically add to local list
        state = state.copyWith(
          catches: [...state.catches, catchLog],
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to upload catch log',
        );
      }
      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}
