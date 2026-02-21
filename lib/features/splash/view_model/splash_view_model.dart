import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:breatheasy/features/splash/model/splash_state.dart';

class SplashViewModel extends StateNotifier<SplashState> {
  SplashViewModel() : super(const SplashState());

  void initSplash() {
    state = state.copyWith(isLoading: true);
  }

  void completeSplash() {
    state = state.copyWith(isLoading: false);
  }
}

final splashViewModelProvider =
    StateNotifierProvider<SplashViewModel, SplashState>((ref) {
      return SplashViewModel();
    });
