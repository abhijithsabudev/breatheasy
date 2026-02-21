import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:breatheasy/core/view_models/theme_view_model.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeViewModelProvider);

    return AppBar(
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(
            themeState.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: () {
            ref.read(themeViewModelProvider.notifier).toggleTheme();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
