import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_loading_page.dart';
import '../../features/games/presentation/pages/games_page.dart';
import '../constants/app_constants.dart';
import '../../features/auth/presentation/pages/steam_callback_page.dart';

class GoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('MyTest didPush: $route');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('MyTest didPop: $route');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('MyTest didRemove: $route');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print('MyTest didReplace: $newRoute');
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppConstants.loginRoute,
    routerNeglect: false,
    observers: [GoRouterObserver()],
    routes: [
      GoRoute(
        path: AppConstants.loginRoute,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppConstants.signUpRoute,
        name: 'signup',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: AppConstants.onboardingRoute,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppConstants.onboardingLoadingRoute,
        name: 'onboarding-loading',
        builder: (context, state) {
          final title = state.uri.queryParameters['title'] ?? 'Syncing Data...';
          final status =
              state.uri.queryParameters['status'] ??
              'Connecting to Secure Server';
          final progress =
              double.tryParse(
                state.uri.queryParameters['progress'] ?? '0.45',
              ) ??
              0.45;

          return OnboardingLoadingPage(
            title: title,
            status: status,
            progress: progress,
          );
        },
      ),
      GoRoute(
        path: AppConstants.homeRoute,
        name: 'home',
        builder: (context, state) => const GamesPage(),
      ),
      GoRoute(
        path: AppConstants.steamCallbackRoute,
        name: 'onboarding-callback',
        builder: (context, state) {
          final queryParams = state.uri.queryParameters;
          return SteamCallbackPage(queryParams: queryParams);
        },
      ),
    ],
  );
});
