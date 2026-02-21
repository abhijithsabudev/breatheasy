import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:breatheasy/features/home/view_model/home_view_model.dart';
import 'package:breatheasy/core/view_models/theme_view_model.dart';
import 'package:breatheasy/features/home/view/components/home_app_bar.dart';
import 'package:breatheasy/features/home/view/components/home_page_header.dart';
import 'package:breatheasy/features/home/view/components/option_selector.dart';
import 'package:breatheasy/features/home/view/components/advanced_timing_section.dart';
import 'package:breatheasy/features/home/view/components/sound_settings_section.dart';
import 'package:breatheasy/features/home/view/components/start_breathing_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(homeViewModelProvider);
    ref.watch(themeViewModelProvider);
    final preferences = ref.watch(homePreferencesProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeViewModelProvider.notifier).initHome();
      ref.read(themeViewModelProvider.notifier).initTheme();
    });

    return Scaffold(
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomePageHeader(),
              const SizedBox(height: 24),
              OptionSelector(
                title: 'Breath duration',
                subtitle: 'Seconds per phase',
                options: const [3, 4, 5, 10],
                selectedValue: preferences.breathDuration,
                onSelect: (value) {
                  ref
                      .read(homePreferencesProvider.notifier)
                      .updateBreathDuration(value);
                },
              ),
              const SizedBox(height: 24),
              OptionSelector(
                title: 'Rounds',
                subtitle: 'Full box breathing cycles',
                options: const [2, 4, 6, 8],
                selectedValue: preferences.rounds,
                onSelect: (value) {
                  ref
                      .read(homePreferencesProvider.notifier)
                      .updateRounds(value);
                },
              ),
              const SizedBox(height: 24),
              AdvancedTimingSection(
                breatheIn: preferences.breatheIn,
                holdIn: preferences.holdIn,
                breatheOut: preferences.breatheOut,
                holdOut: preferences.holdOut,
                onBreatheInChanged: (value) {
                  ref
                      .read(homePreferencesProvider.notifier)
                      .updateBreatheIn(value);
                },
                onHoldInChanged: (value) {
                  ref
                      .read(homePreferencesProvider.notifier)
                      .updateHoldIn(value);
                },
                onBreatheOutChanged: (value) {
                  ref
                      .read(homePreferencesProvider.notifier)
                      .updateBreatheOut(value);
                },
                onHoldOutChanged: (value) {
                  ref
                      .read(homePreferencesProvider.notifier)
                      .updateHoldOut(value);
                },
              ),
              const SizedBox(height: 24),
              SoundSettingsSection(
                soundEnabled: preferences.soundEnabled,
                onChanged: (value) {
                  ref.read(homePreferencesProvider.notifier).toggleSound();
                },
              ),
              const SizedBox(height: 32),
              StartBreathingButton(preferences: preferences),
            ],
          ),
        ),
      ),
    );
  }
}
