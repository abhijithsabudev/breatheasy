class ThemeState {
  final bool isDarkMode;
  final bool isLoading;

  const ThemeState({this.isDarkMode = true, this.isLoading = false});

  ThemeState copyWith({bool? isDarkMode, bool? isLoading}) {
    return ThemeState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
