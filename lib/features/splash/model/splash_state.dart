class SplashState {
  final bool isLoading;
  final String? error;

  const SplashState({this.isLoading = true, this.error});

  SplashState copyWith({bool? isLoading, String? error}) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
