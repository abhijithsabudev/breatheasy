import 'package:flutter/material.dart';

class AdvancedCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Gradient? gradient;
  final double? width;
  final double? height;
  final double borderRadius;
  final TextStyle? textStyle;
  final EdgeInsets padding;
  final Border? border;
  final BoxShadow? shadow;
  final double iconSize;
  final double iconSpacing;
  final Color? iconColor;
  final Color? borderColor;

  const AdvancedCustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.gradient,
    this.width,
    this.height = 56,
    this.borderRadius = 12,
    this.textStyle,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    this.border,
    this.shadow,
    this.iconSize = 20,
    this.iconSpacing = 8,
    this.iconColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = foregroundColor ?? Colors.white;
    final finalIconColor = iconColor ?? buttonColor;

    final buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: iconSize, color: finalIconColor),
          SizedBox(width: iconSpacing),
        ],
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style:
                textStyle ??
                TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: buttonColor,
                ),
          ),
        ),
      ],
    );

    final decoratedButton = Container(
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null
            ? (backgroundColor ?? const Color(0xFF9C77D9))
            : null,
        borderRadius: BorderRadius.circular(borderRadius),
        border:
            border ??
            Border.all(color: borderColor ?? Colors.transparent, width: 1),
        boxShadow: shadow != null ? [shadow!] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: Padding(padding: padding, child: buttonContent),
          ),
        ),
      ),
    );

    // If width or height are specified, wrap in SizedBox; otherwise wrap content
    if (width != null || height != null) {
      return SizedBox(width: width, height: height, child: decoratedButton);
    }

    return decoratedButton;
  }
}
