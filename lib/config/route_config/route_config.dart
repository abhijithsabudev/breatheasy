import 'package:breatheasy/config/route_config/route_names.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

// Import screens from features
import 'package:breatheasy/features/splash/view/splash_screen.dart';
import 'package:breatheasy/features/home/view/home_screen.dart';
import 'package:breatheasy/features/breathing/view/breathing_screen.dart';

/// Global navigator key for programmatic navigation
final navigatorKey = GlobalKey<NavigatorState>();

/// GoRouter configuration for the app
/// Supports Android, iOS, and Web platforms with Cupertino styling
final GoRouter goRouter = GoRouter(
  // Initial route
  initialLocation: RouteNames.splash,

  // Navigator key for programmatic navigation
  navigatorKey: navigatorKey,

  // Platform-specific transitions
  routerNeglect: true,

  routes: [
    // Splash Screen Route
    GoRoute(
      path: RouteNames.splash,
      name: 'splash',
      pageBuilder: (context, state) {
        return CupertinoPage(child: const SplashScreen(), key: state.pageKey);
      },
    ),

    // Home Route with nested Breathing route
    GoRoute(
      path: RouteNames.home,
      name: 'home',
      pageBuilder: (context, state) {
        return CupertinoPage(child: const HomeScreen(), key: state.pageKey);
      },
      routes: [
        // Breathing Screen Route (nested under Home)
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
      ],
    ),
  ],

  // Error handling
  errorPageBuilder: (context, state) {
    return CupertinoPage(
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(middle: Text('Error')),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Page not found', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              CupertinoButton(
                child: const Text('Go Back'),
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  },

  // Refresh listenable (optional - for handling deep links, etc.)
  refreshListenable: _GoRouterRefreshStream(),
);

/// Stream notifier for handling route refresh
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream();
}
