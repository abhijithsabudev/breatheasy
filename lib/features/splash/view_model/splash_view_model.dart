import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:breatheasy/features/splash/model/splash_state.dart';

class SplashViewModel extends StateNotifier<SplashState> {
  SplashViewModel() : super(const SplashState());
}
