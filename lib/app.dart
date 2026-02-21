import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:breatheasy/config/route_config/route_config.dart';
import 'package:breatheasy/config/theme_config/theme_config.dart';
import 'package:breatheasy/config/theme_config/viewmodel/theme_view_model.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeViewModelProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(themeViewModelProvider.notifier).initTheme();
    });

    return MaterialApp.router(
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      title: 'BreatheEasy',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: goRouter,
    );
  }
}
