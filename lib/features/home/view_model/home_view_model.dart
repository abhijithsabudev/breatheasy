import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:breatheasy/features/home/model/home_state.dart';
import 'package:breatheasy/features/home/model/home_preferences_state.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel() : super(const HomeState());

  void initHome() {
    state = state.copyWith(
      isLoading: false,
      message: 'Welcome to BreatheEasy!',
    );
  }

  void startBreathingExercise() {
    state = state.copyWith(message: 'Starting breathing exercise...');
  }
}

class HomePreferencesViewModel extends StateNotifier<HomePreferencesState> {
  HomePreferencesViewModel() : super(const HomePreferencesState());

  void updateBreathDuration(int duration) {
    state = state.copyWith(
      breathDuration: duration,
      breatheIn: duration,
      holdIn: duration,
      breatheOut: duration,
      holdOut: duration,
    );
  }

  void updateRounds(int rounds) {
    state = state.copyWith(rounds: rounds);
  }

  void toggleSound() {
    state = state.copyWith(soundEnabled: !state.soundEnabled);
  }

  void updateBreatheIn(int seconds) {
    state = state.copyWith(breatheIn: seconds);
  }

  void updateHoldIn(int seconds) {
    state = state.copyWith(holdIn: seconds);
  }

  void updateBreatheOut(int seconds) {
    state = state.copyWith(breatheOut: seconds);
  }

  void updateHoldOut(int seconds) {
    state = state.copyWith(holdOut: seconds);
  }

  void resetToDefaults() {
    state = const HomePreferencesState();
  }
}

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>((
  ref,
) {
  return HomeViewModel();
});

final homePreferencesProvider =
    StateNotifierProvider<HomePreferencesViewModel, HomePreferencesState>((
      ref,
    ) {
      return HomePreferencesViewModel();
    });
