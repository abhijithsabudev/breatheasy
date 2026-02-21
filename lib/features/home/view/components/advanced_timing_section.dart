import 'package:flutter/material.dart';

class AdvancedTimingSection extends StatelessWidget {
  final int breatheIn;
  final int holdIn;
  final int breatheOut;
  final int holdOut;
  final Function(int) onBreatheInChanged;
  final Function(int) onHoldInChanged;
  final Function(int) onBreatheOutChanged;
  final Function(int) onHoldOutChanged;

  const AdvancedTimingSection({
    super.key,
    required this.breatheIn,
    required this.holdIn,
    required this.breatheOut,
    required this.holdOut,
    required this.onBreatheInChanged,
    required this.onHoldInChanged,
    required this.onBreatheOutChanged,
    required this.onHoldOutChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Advanced timing', style: context.textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(
          'Set different durations for each phase',
          style: context.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        _TimingControl(
          label: 'Breathe in',
          value: breatheIn,
          onChanged: onBreatheInChanged,
        ),
        const SizedBox(height: 12),
        _TimingControl(
          label: 'Hold in',
          value: holdIn,
          onChanged: onHoldInChanged,
        ),
        const SizedBox(height: 12),
        _TimingControl(
          label: 'Breathe out',
          value: breatheOut,
          onChanged: onBreatheOutChanged,
        ),
        const SizedBox(height: 12),
        _TimingControl(
          label: 'Hold out',
          value: holdOut,
          onChanged: onHoldOutChanged,
        ),
      ],
    );
  }
}

class _TimingControl extends StatelessWidget {
  final String label;
  final int value;
  final Function(int) onChanged;

  const _TimingControl({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.textTheme.bodyMedium),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: value > 1 ? () => onChanged(value - 1) : null,
            ),
            Text('${value}s', style: context.textTheme.headlineSmall),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => onChanged(value + 1),
            ),
          ],
        ),
      ],
    );
  }
}

extension ContextTheme on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}
