class BreathingState {
  final bool isBreathing;
  final bool isPaused;
  final int breathCount;
  final int totalRounds;
  final String status;
  final String? error;
  final bool isCompleted;
  final int currentPhaseTime;
  final String currentPhase;
  final double progress;

  const BreathingState({
    this.isBreathing = false,
    this.isPaused = false,
    this.breathCount = 0,
    this.totalRounds = 4,
    this.status = 'Ready to breathe',
    this.error,
    this.isCompleted = false,
    this.currentPhaseTime = 0,
    this.currentPhase = 'Get ready',
    this.progress = 0.0,
  });

  BreathingState copyWith({
    bool? isBreathing,
    bool? isPaused,
    int? breathCount,
    int? totalRounds,
    String? status,
    String? error,
    bool? isCompleted,
    int? currentPhaseTime,
    String? currentPhase,
    double? progress,
  }) {
    return BreathingState(
      isBreathing: isBreathing ?? this.isBreathing,
      isPaused: isPaused ?? this.isPaused,
      breathCount: breathCount ?? this.breathCount,
      totalRounds: totalRounds ?? this.totalRounds,
      status: status ?? this.status,
      error: error ?? this.error,
      isCompleted: isCompleted ?? this.isCompleted,
      currentPhaseTime: currentPhaseTime ?? this.currentPhaseTime,
      currentPhase: currentPhase ?? this.currentPhase,
      progress: progress ?? this.progress,
    );
  }
}
