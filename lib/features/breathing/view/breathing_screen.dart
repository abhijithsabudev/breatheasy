import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:breatheasy/features/breathing/view_model/breathing_view_model.dart';

class BreathingScreen extends ConsumerStatefulWidget {
  const BreathingScreen({super.key});

  @override
  ConsumerState<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends ConsumerState<BreathingScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _hasNavigated = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(breathingViewModelProvider.notifier).startBreathing();
      }
    });
  }

  @override
  void dispose() {
    // Let Riverpod handle the ViewModel disposal automatically
    // Calling ref.read here can cause "Cannot use ref after widget was disposed" errors
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final breathingState = ref.watch(breathingViewModelProvider);

    if (breathingState.isCompleted && !_hasNavigated && mounted) {
      _hasNavigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.goNamed('success');
        }
      });
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && mounted) {
          // Stop breathing before navigating away
          try {
            ref.read(breathingViewModelProvider.notifier).stopBreathing();
          } catch (_) {
            // Widget might be disposed, silently handle
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              // Stop breathing before navigating away
              try {
                ref.read(breathingViewModelProvider.notifier).stopBreathing();
              } catch (_) {
                // Widget might be disposed, silently handle
              }
              context.pop();
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You're natural!",
                      style: context.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 48),
                    _BreathingCircle(
                      currentPhase: breathingState.currentPhase,
                      timeRemaining: breathingState.currentPhaseTime,
                    ),
                    const SizedBox(height: 48),
                    Text(
                      breathingState.currentPhase,
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      breathingState.status,
                      style: context.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _ProgressBar(
                    current: breathingState.breathCount,
                    total: breathingState.totalRounds,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Cycle ${breathingState.breathCount} of ${breathingState.totalRounds}',
                    style: context.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  _ControlButtons(
                    isBreathing: breathingState.isBreathing,
                    isPaused: breathingState.isPaused,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreathingCircle extends ConsumerWidget {
  final String currentPhase;
  final int timeRemaining;

  const _BreathingCircle({
    required this.currentPhase,
    required this.timeRemaining,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double scale = 1.0;
    if (currentPhase.contains('Breathe in')) {
      scale = 1.2;
    } else if (currentPhase.contains('Breathe out')) {
      scale = 0.8;
    }

    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 500),
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF9C77D9).withValues(alpha: 0.3),
          border: Border.all(color: const Color(0xFF9C77D9), width: 2),
        ),
        child: Center(
          child: Text(
            timeRemaining.toString(),
            style: context.textTheme.displayLarge?.copyWith(
              fontSize: 60,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const _ProgressBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: current / total,
        minHeight: 6,
        backgroundColor: context.theme.cardColor,
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF6B6B)),
      ),
    );
  }
}

class _ControlButtons extends ConsumerWidget {
  final bool isBreathing;
  final bool isPaused;

  const _ControlButtons({required this.isBreathing, required this.isPaused});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () {
          if (isPaused) {
            ref.read(breathingViewModelProvider.notifier).resumeBreathing();
          } else {
            ref.read(breathingViewModelProvider.notifier).pauseBreathing();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            isPaused ? 'Resume' : 'Pause',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

extension ContextTheme on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ThemeData get theme => Theme.of(this);
}
