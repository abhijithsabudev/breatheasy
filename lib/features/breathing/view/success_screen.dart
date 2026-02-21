import 'package:breatheasy/custom_components/buttons/advanced_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:breatheasy/config/theme_config/app_colors.dart';
import 'package:breatheasy/features/home/view_model/home_view_model.dart';
import 'package:breatheasy/features/breathing/view_model/breathing_view_model.dart';
import 'package:breatheasy/config/theme_config/viewmodel/theme_view_model.dart';

class SuccessScreen extends ConsumerWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeViewModelProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [context.colors.topgradient, context.colors.bottomgradient],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
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
                const SizedBox(height: 60),
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
                const SizedBox(height: 24),
                AdvancedCustomButton(
                  width: 300,
                  text: 'Start again',
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
                  backgroundColor: context.colors.buttonPrimary,
                  foregroundColor: Colors.white,
                  height: 56,
                  borderRadius: 100,
                ),
                const SizedBox(height: 24),
                AdvancedCustomButton(
                  width: 200,
                  text: 'Back to setup',
                  onPressed: () {
                    ref
                        .read(homePreferencesProvider.notifier)
                        .resetToDefaults();
                    context.goNamed('home');
                  },
                  backgroundColor: context.colors.chipNeutralBg,
                  foregroundColor: context.textTheme.bodyLarge?.color,
                  height: 56,
                  borderRadius: 100,
                ),
              ],
            ),
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
