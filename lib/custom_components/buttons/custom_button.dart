import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
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
  final Color? borderColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
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
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
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
            child: Padding(
              padding: padding,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style:
                    textStyle ??
                    TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: foregroundColor ?? Colors.white,
                    ),
              ),
            ),
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
