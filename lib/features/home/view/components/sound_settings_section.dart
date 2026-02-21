import 'package:breatheasy/config/theme_config/app_colors.dart';
import 'package:flutter/material.dart';

class SoundSettingsSection extends StatelessWidget {
  final bool soundEnabled;
  final Function(bool) onChanged;

  const SoundSettingsSection({
    super.key,
    required this.soundEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sound', style: context.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              'Gentle chime between phases',
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
        Switch(
          value: soundEnabled,
          onChanged: onChanged,
          activeThumbColor: context.colors.white,
          activeTrackColor: const Color(0xFF823386),
          trackOutlineWidth: WidgetStateProperty.all(0.0),
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ],
    );
  }
}

extension ContextTheme on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}
