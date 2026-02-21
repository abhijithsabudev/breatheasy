import 'package:breatheasy/config/theme_config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:breatheasy/core/utils/context_extension.dart';

enum OptionType { breath, rounds }

class OptionSelector extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<int> options;
  final int selectedValue;
  final Function(int) onSelect;
  final OptionType type;

  const OptionSelector({
    super.key,
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selectedValue,
    required this.onSelect,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = context.isWeb;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.headlineSmall?.copyWith(
            fontSize: isWeb ? 18 : 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: isWeb ? 15 : 13,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              final isSelected = option == selectedValue;
              return Padding(
                padding: EdgeInsets.only(right: isWeb ? 12 : 8),
                child: GestureDetector(
                  onTap: () => onSelect(option),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 24 : 20,
                      vertical: isWeb ? 14 : 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.colors.orange2
                          : context.colors.bgPage,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        width: 1,
                        color: isSelected
                            ? context.colors.orange1
                            : context.colors.borderSubtle,
                      ),
                    ),
                    child: Text(
                      _getOptionLabel(option),
                      style: TextStyle(
                        fontSize: isWeb ? 15 : 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? context.colors.orange1
                            : context.colors.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _getOptionLabel(int option) {
    if (type == OptionType.rounds) {
      switch (option) {
        case 2:
          return '2 quick';
        case 4:
          return '4 calm';
        case 6:
          return '6 deep';
        case 8:
          return '8 zen';
        default:
          return '${option}s';
      }
    }
    return '${option}s';
  }
}
