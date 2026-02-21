import 'package:flutter/material.dart';

class OptionSelector extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<int> options;
  final int selectedValue;
  final Function(int) onSelect;

  const OptionSelector({
    super.key,
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selectedValue,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(subtitle, style: context.textTheme.bodyMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = option == selectedValue;
            return GestureDetector(
              onTap: () => onSelect(option),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF9C77D9)
                      : context.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF9C77D9)
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  '${option}s',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : context.textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

extension ContextTheme on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  Color get cardColor => Theme.of(this).cardColor;
}
