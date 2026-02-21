import 'package:breatheasy/config/route_config/route_names.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:breatheasy/features/splash/view/splash_screen.dart';
import 'package:breatheasy/features/home/view/home_screen.dart';
import 'package:breatheasy/features/breathing/view/breathing_screen.dart';
import 'package:breatheasy/features/breathing/view/success_screen.dart';
import 'package:breatheasy/features/error/view/error_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final GoRouter goRouter = GoRouter(
  initialLocation: RouteNames.splash,
  navigatorKey: navigatorKey,
  routerNeglect: true,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      name: 'splash',
      pageBuilder: (context, state) {
        return CupertinoPage(child: const SplashScreen(), key: state.pageKey);
      },
    ),
    GoRoute(
      path: RouteNames.home,
      name: 'home',
      pageBuilder: (context, state) {
        return CupertinoPage(child: const HomeScreen(), key: state.pageKey);
      },
      routes: [
        GoRoute(
          path: 'breathing',
          name: 'breathing',
          pageBuilder: (context, state) {
            return CupertinoPage(
              child: const BreathingScreen(),
              key: state.pageKey,
            );
          },
        ),
        GoRoute(
          path: 'success',
          name: 'success',
          pageBuilder: (context, state) {
            return CupertinoPage(
              child: const SuccessScreen(),
              key: state.pageKey,
            );
          },
        ),
      ],
    ),
  ],

  errorPageBuilder: (context, state) {
    return CupertinoPage(
      child: ErrorScreen(state: state),
      key: state.pageKey,
    );
  },

  refreshListenable: _GoRouterRefreshStream(),
);

class _GoRouterRefreshStream extends ChangeNotifier {}
