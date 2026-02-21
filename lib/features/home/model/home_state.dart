class HomeState {
  final bool isLoading;
  final String? error;
  final String message;

  const HomeState({
    this.isLoading = false,
    this.error,
    this.message = 'Welcome to Home',
  });

  HomeState copyWith({bool? isLoading, String? error, String? message}) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }
}
