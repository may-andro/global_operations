import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/authentication/presentation/auth_notifier.dart';
import 'package:global_ops/src/feature/authentication/presentation/route/authentication_module_route.dart';
import 'package:global_ops/src/feature/home/presentation/route/home_module_route.dart';
import 'package:global_ops/src/route/module_route_configurator.dart';
import 'package:global_ops/src/route/route_not_found_screen.dart';
import 'package:go_router/go_router.dart';

/// Configures the application's routing system with authentication-based redirects.
class RouteConfigurator {
  const RouteConfigurator(
    this.moduleRouteConfigurator,
    this.navigationObservers,
    this.authNotifier,
  );

  final List<ModuleRouteConfigurator> moduleRouteConfigurator;
  final List<NavigatorObserver> navigationObservers;
  final AuthNotifier authNotifier;

  /// Creates the GoRouter instance with authentication-based redirect logic.
  GoRouter get router {
    if (kIsWeb) {
      GoRouter.optionURLReflectsImperativeAPIs = true;
    }
    final publicRoutes = moduleRouteConfigurator
        .expand((route) => route.publicRoutes)
        .map((route) => route.path)
        .toList();
    return GoRouter(
      initialLocation: '/',
      routes: moduleRouteConfigurator.expand((route) => route.routes).toList(),
      observers: navigationObservers,
      errorBuilder: (_, _) => const RouteNotFoundScreen(),
      refreshListenable: authNotifier,
      redirect: (context, state) =>
          _handleRedirect(context, state, publicRoutes),
    );
  }

  /// Handles authentication-based redirects.
  String? _handleRedirect(
    BuildContext context,
    GoRouterState state,
    List<String> publicRoutes,
  ) {
    final isLoggedIn = authNotifier.isLoggedIn;
    final isInitialized = authNotifier.isInitialized;
    final currentLocation = state.matchedLocation;

    // Wait for auth initialization before making any redirect decisions
    if (!isInitialized) {
      // Don't redirect until we know the auth state
      return null;
    }

    // If not logged in and route is public, allow access (e.g., login page)
    if (!isLoggedIn && publicRoutes.contains(currentLocation)) {
      return null;
    }

    // If not logged in and trying to access a protected route (after init), redirect to login
    if (!isLoggedIn && !publicRoutes.contains(currentLocation)) {
      // Only add redirect param if not already on login page
      if (currentLocation != AuthenticationModuleRoute.login.path) {
        return '${AuthenticationModuleRoute.login.path}?redirect=${Uri.encodeComponent(currentLocation)}';
      } else {
        return AuthenticationModuleRoute.login.path;
      }
    }

    // If logged in and on login page, redirect to home or intended page
    if (isLoggedIn && currentLocation == AuthenticationModuleRoute.login.path) {
      final redirectPath = state.uri.queryParameters['redirect'];
      return redirectPath != null && redirectPath.isNotEmpty
          ? Uri.decodeComponent(redirectPath)
          : HomeModuleRoute.home.path;
    }

    // If logged in and on auth root, redirect to home
    if (isLoggedIn && currentLocation == AuthenticationModuleRoute.auth.path) {
      return HomeModuleRoute.home.path;
    }

    // Otherwise, no redirect
    return null;
  }
}
