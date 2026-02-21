import 'package:flutter/material.dart';

class ResponsiveContainer extends StatelessWidget {
  final double maxWidth;
  final double horizontalPadding;
  final double verticalPadding;
  final Widget child;

  const ResponsiveContainer({
    super.key,
    this.maxWidth = 800,
    this.horizontalPadding = 27.0,
    this.verticalPadding = 27.0,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: child,
      ),
    );
  }
}
