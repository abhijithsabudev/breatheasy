import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:breatheasy/features/home/view_model/home_view_model.dart';
import 'package:breatheasy/features/breathing/view_model/breathing_view_model.dart';

class SuccessScreen extends ConsumerWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 60),
              ),
              const SizedBox(height: 32),
              Text(
                'You did it!',
                style: context.displayLarge.copyWith(fontSize: 40),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Great rounds of calm, just like that. Your mind thanks you.',
                  textAlign: TextAlign.center,
                  style: context.bodyMedium,
                ),
              ),
              const SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      // Reinitialize breathing with current preferences
                      final preferences = ref.read(homePreferencesProvider);
                      ref
                          .read(breathingViewModelProvider.notifier)
                          .reinitFromParams(
                            breatheIn: preferences.breatheIn,
                            holdIn: preferences.holdIn,
                            breatheOut: preferences.breatheOut,
                            holdOut: preferences.holdOut,
                            totalRounds: preferences.rounds,
                          );
                      context.goNamed('breathing');
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Start again',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ref
                          .read(homePreferencesProvider.notifier)
                          .resetToDefaults();
                      context.goNamed('home');
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Back to set up',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension ContextTheme on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  TextStyle get displayLarge => textTheme.displayLarge ?? const TextStyle();
  TextStyle get bodyMedium => textTheme.bodyMedium ?? const TextStyle();
}
