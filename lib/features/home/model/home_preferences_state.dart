class HomePreferencesState {
  final int breathDuration;
  final int rounds;
  final bool soundEnabled;
  final int breatheIn;
  final int holdIn;
  final int breatheOut;
  final int holdOut;

  const HomePreferencesState({
    this.breathDuration = 4,
    this.rounds = 4,
    this.soundEnabled = true,
    this.breatheIn = 4,
    this.holdIn = 4,
    this.breatheOut = 4,
    this.holdOut = 4,
  });

  HomePreferencesState copyWith({
    int? breathDuration,
    int? rounds,
    bool? soundEnabled,
    int? breatheIn,
    int? holdIn,
    int? breatheOut,
    int? holdOut,
  }) {
    return HomePreferencesState(
      breathDuration: breathDuration ?? this.breathDuration,
      rounds: rounds ?? this.rounds,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      breatheIn: breatheIn ?? this.breatheIn,
      holdIn: holdIn ?? this.holdIn,
      breatheOut: breatheOut ?? this.breatheOut,
      holdOut: holdOut ?? this.holdOut,
    );
  }
}
