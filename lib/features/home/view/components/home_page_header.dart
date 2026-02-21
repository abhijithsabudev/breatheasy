import 'package:breatheasy/config/theme_config/app_colors.dart';
import 'package:flutter/material.dart';

class HomePageHeader extends StatelessWidget {
  final bool isWeb;

  const HomePageHeader({super.key, required this.isWeb});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Set your breathing pace',
          style: context.textTheme.displayLarge?.copyWith(
            fontSize: isWeb ? 48 : 32,
            fontWeight: FontWeight.bold,
            color: context.colors.brandPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Customise your breathing session. You can always change this later.',
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: isWeb ? 16 : 14,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

extension ContextTheme on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ThemeData get theme => Theme.of(this);
}
