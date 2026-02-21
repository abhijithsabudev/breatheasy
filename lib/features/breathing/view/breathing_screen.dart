import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:breatheasy/config/theme_config/app_colors.dart';
import 'package:breatheasy/custom_components/buttons/advanced_custom_button.dart';
import 'package:breatheasy/features/breathing/view_model/breathing_view_model.dart';
import 'package:breatheasy/config/theme_config/viewmodel/theme_view_model.dart';

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

    final themeState = ref.watch(themeViewModelProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [context.colors.topgradient, context.colors.bottomgradient],
        ),
      ),
      child: PopScope(
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
            backgroundColor: Colors.transparent,
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
            actions: [
              IconButton(
                icon: Icon(
                  themeState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  ref.read(themeViewModelProvider.notifier).toggleTheme();
                },
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
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
                    _ProgressBar(progress: breathingState.progress),
                    const SizedBox(height: 24),
                    Text(
                      'Cycle ${breathingState.breathCount + 1} of ${breathingState.totalRounds}',
                      style: context.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    _ControlButtons(
                      isPaused: breathingState.isPaused,
                      currentPhase: breathingState.currentPhase,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
    return _PulsatingCircle(timeRemaining: timeRemaining);
  }
}

class _PulsatingCircle extends StatefulWidget {
  final int timeRemaining;

  const _PulsatingCircle({required this.timeRemaining});

  @override
  State<_PulsatingCircle> createState() => _PulsatingCircleState();
}

class _PulsatingCircleState extends State<_PulsatingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.colors.purple1,
          border: Border.all(color: context.colors.purple2, width: 1),
        ),
        child: Center(
          child: Text(
            widget.timeRemaining.toString(),
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
  final double progress;

  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          // Background
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: context.theme.cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          // Gradient progress
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: clampedProgress,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFFF8A00), Color(0xFF6C0862)],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButtons extends ConsumerWidget {
  final bool isPaused;
  final String currentPhase;

  const _ControlButtons({required this.isPaused, required this.currentPhase});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Don't show button during prep timer
    if (currentPhase == 'Get ready') {
      return const SizedBox.shrink();
    }

    return AdvancedCustomButton(
      text: isPaused ? 'Resume' : 'Pause',
      icon: isPaused ? Icons.play_arrow : Icons.pause,
      onPressed: () {
        if (isPaused) {
          ref.read(breathingViewModelProvider.notifier).resumeBreathing();
        } else {
          ref.read(breathingViewModelProvider.notifier).pauseBreathing();
        }
      },
      width: 150,
      backgroundColor: context.colors.brandSubtle,
      foregroundColor: Colors.white,
      iconColor: context.theme.textTheme.headlineSmall?.color,
      height: 56,
      borderRadius: 100,
      iconSize: 24,
      iconSpacing: 4,
      textStyle: context.textTheme.headlineSmall,
    );
  }
}

extension ContextTheme on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ThemeData get theme => Theme.of(this);
}
