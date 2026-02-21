import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:breatheasy/features/home/model/home_preferences_state.dart';
import 'package:breatheasy/features/breathing/view_model/breathing_view_model.dart';

class StartBreathingButton extends ConsumerWidget {
  final HomePreferencesState preferences;

  const StartBreathingButton({super.key, required this.preferences});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
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
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text('Start breathing', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
