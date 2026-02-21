import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:breatheasy/core/models/theme_state.dart';

class ThemeViewModel extends StateNotifier<ThemeState> {
  ThemeViewModel() : super(const ThemeState());

  static const String _themeKey = 'isDarkMode';

  Future<void> initTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDarkMode = prefs.getBool(_themeKey) ?? true;
      state = state.copyWith(isDarkMode: isDarkMode, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> toggleTheme() async {
    try {
      final newValue = !state.isDarkMode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, newValue);
      state = state.copyWith(isDarkMode: newValue);
    } catch (e) {
      StateError('Failed to toggle theme');
    }
  }
}

final themeViewModelProvider =
    StateNotifierProvider<ThemeViewModel, ThemeState>((ref) {
      return ThemeViewModel();
    });
