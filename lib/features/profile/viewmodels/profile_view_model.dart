import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ocevara/core/models/user.dart';
import 'package:ocevara/core/repositories/i_user_repository.dart';
import 'package:ocevara/features/profile/repositories/user_repository.dart';


class ProfileState {
  final User? user;
  final bool isLoading;
  final bool isUpdating;
  final String? errorMessage;
  final bool updateSuccess;

  const ProfileState({
    this.user,
    this.isLoading = false,
    this.isUpdating = false,
    this.errorMessage,
    this.updateSuccess = false,
  });

  const ProfileState.initial()
      : user = null,
        isLoading = false,
        isUpdating = false,
        errorMessage = null,
        updateSuccess = false;

  ProfileState copyWith({
    User? user,
    bool? isLoading,
    bool? isUpdating,
    String? errorMessage,
    bool? updateSuccess,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      errorMessage: errorMessage,
      updateSuccess: updateSuccess ?? this.updateSuccess,
    );
  }
}


/// Provides the [ProfileViewModel] to the widget tree.
final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, ProfileState>((ref) {
  return ProfileViewModel(ref.read(userRepositoryProvider));
});


/// Manages user profile state.
class ProfileViewModel extends StateNotifier<ProfileState> {
  final IUserRepository _repository;

  ProfileViewModel(this._repository) : super(const ProfileState.initial()) {
    loadProfile(); // auto-load when ViewModel is created
  }

  /// Fetches the current user's profile from the API.
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _repository.getUserProfile();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load profile: ${e.toString()}',
      );
    }
  }

  /// Updates the current user's profile with new [user] data.
  Future<bool> updateProfile(User user) async {
    state = state.copyWith(
        isUpdating: true, errorMessage: null, updateSuccess: false);
    try {
      final success = await _repository.updateProfile(user);
      if (success) {
        state = state.copyWith(
            user: user, isUpdating: false, updateSuccess: true);
      } else {
        state = state.copyWith(
          isUpdating: false,
          errorMessage: 'Failed to update profile',
        );
      }
      return success;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Clears any displayed error message.
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
