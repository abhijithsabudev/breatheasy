import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension ContextTheme on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  TextStyle get displayLarge => textTheme.displayLarge ?? const TextStyle();
  TextStyle get bodyMedium => textTheme.bodyMedium ?? const TextStyle();
  bool get isWeb => kIsWeb;
}
