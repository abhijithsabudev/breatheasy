import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:breatheasy/features/breathing/model/breathing_state.dart';

class BreathingViewModel extends StateNotifier<BreathingState> {
  BreathingViewModel() : super(const BreathingState());

  late int _breatheInDuration;
  late int _holdInDuration;
  late int _breatheOutDuration;
  late int _holdOutDuration;

  Timer? _updateTimer;
  bool _isActive = true;
  int _elapsedMilliseconds = 0;
  int _phaseDurationSeconds = 0;
  bool _isFirstStart = true;
  int _lastDisplayedTime = -1;

  // For overall progress tracking
  int _totalExerciseDurationMilliseconds = 0;
  int _overallElapsedMilliseconds = 0;

  void initBreathing({
    required int breatheIn,
    required int holdIn,
    required int breatheOut,
    required int holdOut,
    required int totalRounds,
  }) {
    _breatheInDuration = breatheIn;
    _holdInDuration = holdIn;
    _breatheOutDuration = breatheOut;
    _holdOutDuration = holdOut;
    _elapsedMilliseconds = 0;
    _phaseDurationSeconds = 0;
    _overallElapsedMilliseconds = 0;

    // Calculate total duration: sum of all phases × total rounds
    final phaseSum = breatheIn + holdIn + breatheOut + holdOut;
    _totalExerciseDurationMilliseconds = phaseSum * totalRounds * 1000;

    state = state.copyWith(
      isBreathing: false,
      isPaused: false,
      breathCount: 0,
      totalRounds: totalRounds,
      status: "You're natural!",
      isCompleted: false,
      currentPhase: 'Get ready',
      currentPhaseTime: 0,
      progress: 0.0,
    );
  }

  void reinitFromParams({
    required int breatheIn,
    required int holdIn,
    required int breatheOut,
    required int holdOut,
    required int totalRounds,
  }) {
    // Restore active state for restart scenario
    _isActive = true;
    _isFirstStart = true;

    // Cancel any existing timers
    _updateTimer?.cancel();
    _updateTimer = null;

    // Reset tracking
    _elapsedMilliseconds = 0;
    _phaseDurationSeconds = 0;
    _lastDisplayedTime = -1;
    _overallElapsedMilliseconds = 0;

    // Set parameters
    _breatheInDuration = breatheIn;
    _holdInDuration = holdIn;
    _breatheOutDuration = breatheOut;
    _holdOutDuration = holdOut;

    // Calculate total duration
    final phaseSum = breatheIn + holdIn + breatheOut + holdOut;
    _totalExerciseDurationMilliseconds = phaseSum * totalRounds * 1000;

    // Reset state
    state = state.copyWith(
      isBreathing: false,
      isPaused: false,
      breathCount: 0,
      totalRounds: totalRounds,
      status: "You're natural!",
      isCompleted: false,
      currentPhase: 'Get ready',
      currentPhaseTime: 0,
      progress: 0.0,
    );
  }

  void startBreathing() {
    if (!_isActive || (state.isBreathing && !state.isPaused)) return;

    state = state.copyWith(isBreathing: true, isPaused: false);
    if (!state.isPaused) {
      _elapsedMilliseconds = 0;
    }

    // Show 5-second prep timer only on first start
    if (_isFirstStart) {
      _isFirstStart = false;
      _showPrepTimer();
    } else {
      _performBreathingCycle();
    }
  }

  void pauseBreathing() {
    if (!_isActive || !state.isBreathing || state.isPaused) return;
    state = state.copyWith(isPaused: true);
  }

  void resumeBreathing() {
    if (!_isActive || !state.isBreathing || !state.isPaused) return;
    state = state.copyWith(isPaused: false);
  }

  void stopBreathing() {
    if (!_isActive) return;
    _isActive = false;
    _updateTimer?.cancel();
    _updateTimer = null;
    _elapsedMilliseconds = 0;
    _lastDisplayedTime = -1;
    _isFirstStart = true;
    _overallElapsedMilliseconds = 0;
    state = state.copyWith(
      isBreathing: false,
      isPaused: false,
      status: 'Exercise stopped',
      progress: 0.0,
    );
  }

  void completeExercise() {
    if (!_isActive) return;
    _updateTimer?.cancel();
    _updateTimer = null;
    _elapsedMilliseconds = 0;
    _lastDisplayedTime = -1;
    _isFirstStart = true;
    _overallElapsedMilliseconds = 0;
    state = state.copyWith(
      isBreathing: false,
      isPaused: false,
      isCompleted: true,
      status: "You did it! Great work!",
      progress: 1.0,
    );
  }

  Future<void> _performBreathingCycle() async {
    while (_isActive &&
        state.isBreathing &&
        state.breathCount < state.totalRounds) {
      // Breathe in
      if (!await _animatePhase(
        'Breathe in',
        _breatheInDuration,
        'nice and slow',
      )) {
        break;
      }

      // Hold in
      if (!await _animatePhase(
        'Hold softly',
        _holdInDuration,
        'just be there',
      )) {
        break;
      }

      // Breathe out
      if (!await _animatePhase(
        'Breathe out',
        _breatheOutDuration,
        'nice and slow',
      )) {
        break;
      }

      // Hold out
      if (!await _animatePhase(
        'Hold gently',
        _holdOutDuration,
        'you are doing great',
      )) {
        break;
      }

      // Increment round
      if (!_isActive) {
        break;
      }
      final newCount = state.breathCount + 1;
      final isLast = newCount >= state.totalRounds;

      state = state.copyWith(breathCount: newCount, status: "You're natural!");

      if (isLast) {
        completeExercise();
        break;
      }

      // No delay - transitions should be instant
    }
  }

  Future<bool> _animatePhase(
    String phase,
    int duration,
    String subtitle,
  ) async {
    if (!_isActive || !state.isBreathing) return false;

    _phaseDurationSeconds = duration;
    _elapsedMilliseconds = 0;
    _lastDisplayedTime = -1; // Reset so next update will definitely trigger

    // Set initial state with phase info
    state = state.copyWith(currentPhase: phase, status: subtitle);
    _updatePhaseDisplay();

    // Create a completer for phase completion
    final Completer<bool> phaseCompleter = Completer<bool>();

    // Cancel any existing timer to avoid race conditions
    _updateTimer?.cancel();
    _updateTimer = null;

    // Use a timer to update smoothly every 100ms
    _updateTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_isActive) {
        timer.cancel();
        if (!phaseCompleter.isCompleted) {
          phaseCompleter.complete(false);
        }
        return;
      }

      if (!state.isBreathing) {
        timer.cancel();
        if (!phaseCompleter.isCompleted) {
          phaseCompleter.complete(false);
        }
        return;
      }

      // Only increment elapsed time if not paused
      if (!state.isPaused) {
        _elapsedMilliseconds += 100;
        _overallElapsedMilliseconds += 100;
      }

      _updatePhaseDisplay();

      // Update progress
      _updateProgress();

      // Check if phase is complete (with small buffer for timing accuracy)
      if (_elapsedMilliseconds >= _phaseDurationSeconds * 1000) {
        timer.cancel();
        _updateTimer = null;
        if (!phaseCompleter.isCompleted) {
          phaseCompleter.complete(true);
        }
      }
    });

    // Simply await the phase completer - no unnecessary timeout
    return phaseCompleter.future;
  }

  Future<void> _showPrepTimer() async {
    if (!_isActive || !state.isBreathing) return;

    state = state.copyWith(
      currentPhase: 'Get ready',
      status: 'Get going on your breathing session',
      currentPhaseTime: 3,
    );

    final Completer<void> prepCompleter = Completer<void>();
    int prepSeconds = 3;
    _lastDisplayedTime = 3; // Track the displayed prep time

    // Cancel any existing timer
    _updateTimer?.cancel();
    _updateTimer = null;

    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isActive || !state.isBreathing) {
        timer.cancel();
        _updateTimer = null;
        if (!prepCompleter.isCompleted) {
          prepCompleter.complete();
        }
        return;
      }

      prepSeconds--;

      // Only update if the value changed
      if (prepSeconds >= 1 && prepSeconds != _lastDisplayedTime) {
        _lastDisplayedTime = prepSeconds;
        if (_isActive && state.isBreathing) {
          state = state.copyWith(currentPhaseTime: prepSeconds);
        }
      }

      if (prepSeconds <= 0) {
        timer.cancel();
        _updateTimer = null;
        if (!prepCompleter.isCompleted) {
          prepCompleter.complete();
        }
      }
    });

    // Simply await the prep completer - no unnecessary timeout
    await prepCompleter.future;

    _updateTimer?.cancel();
    _updateTimer = null;

    if (_isActive && state.isBreathing) {
      _performBreathingCycle();
    }
  }

  void _updatePhaseDisplay() {
    if (!_isActive) return;

    // Calculate remaining time using ceiling to show full seconds
    final remaining =
        ((_phaseDurationSeconds * 1000 - _elapsedMilliseconds + 999) ~/ 1000);
    final displayValue = remaining.clamp(1, _phaseDurationSeconds);

    // Only update state if the displayed value has changed
    if (displayValue != _lastDisplayedTime) {
      _lastDisplayedTime = displayValue;
      if (_isActive && state.isBreathing) {
        state = state.copyWith(currentPhaseTime: displayValue);
      }
    }
  }

  void _updateProgress() {
    if (!_isActive || _totalExerciseDurationMilliseconds <= 0) return;

    // Calculate progress as a percentage (0.0 to 1.0)
    final progress =
        (_overallElapsedMilliseconds / _totalExerciseDurationMilliseconds)
            .clamp(0.0, 1.0);

    if (_isActive && state.isBreathing) {
      state = state.copyWith(progress: progress);
    }
  }

  @override
  void dispose() {
    // Set flag first to prevent any state updates
    _isActive = false;

    // Cancel the timer immediately
    _updateTimer?.cancel();
    _updateTimer = null;

    // Clear tracking variables
    _elapsedMilliseconds = 0;
    _phaseDurationSeconds = 0;
    _lastDisplayedTime = -1;
    _overallElapsedMilliseconds = 0;
    _totalExerciseDurationMilliseconds = 0;

    super.dispose();
  }
}

final breathingViewModelProvider =
    StateNotifierProvider<BreathingViewModel, BreathingState>((ref) {
      return BreathingViewModel();
    });
