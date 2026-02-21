import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:breatheasy/config/theme_config/app_colors.dart';
import 'package:breatheasy/features/home/model/home_preferences_state.dart';
import 'package:breatheasy/features/breathing/view_model/breathing_view_model.dart';
import 'package:breatheasy/custom_components/buttons/custom_button.dart';

class StartBreathingButton extends ConsumerWidget {
  final HomePreferencesState preferences;

  const StartBreathingButton({super.key, required this.preferences});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: 'Start breathing',
        onPressed: () {
          ref
              .read(breathingViewModelProvider.notifier)
              .initBreathing(
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
    );
  }
}
