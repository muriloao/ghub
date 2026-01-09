import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_loading_page.dart';
import '../../features/games/presentation/pages/games_page.dart';
import '../../features/games/presentation/pages/game_detail_page.dart';
import '../../features/integrations/presentation/pages/integrations_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../constants/app_constants.dart';

import '../../features/integrations/presentation/pages/xbox_callback_page.dart';
import '../../features/integrations/presentation/pages/steam_callback_page.dart';

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
    initialLocation: AppConstants.splashRoute,
    routerNeglect: true,
    observers: [GoRouterObserver()],
    routes: [
      GoRoute(
        path: AppConstants.splashRoute,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
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
        path: '${AppConstants.gameDetailRoute}/:gameId',
        name: 'game-detail',
        builder: (context, state) {
          final gameId = state.pathParameters['gameId']!;
          return GameDetailPage(gameId: gameId);
        },
      ),

      GoRoute(
        path: AppConstants.xboxCallbackRoute,
        name: 'xbox-callback',
        builder: (context, state) {
          final queryParams = state.uri.queryParameters;
          return XboxCallbackPage(
            code: queryParams['code'],
            state: queryParams['state'],
            error: queryParams['error'],
          );
        },
      ),
      GoRoute(
        path: AppConstants.steamCallbackRoute,
        name: 'steam-callback',
        builder: (context, state) {
          // Tentar obter query params da URI ou do extra
          Map<String, String> queryParams = state.uri.queryParameters;

          // Se veio via extra (navegação alternativa), usar esses parâmetros
          if (state.extra != null && state.extra is Map<String, String>) {
            queryParams = state.extra as Map<String, String>;
          }

          return SteamCallbackPage(queryParameters: queryParams);
        },
      ),
      GoRoute(
        path: AppConstants.integrationsRoute,
        name: 'integrations',
        builder: (context, state) => const IntegrationsPage(),
      ),
      GoRoute(
        path: AppConstants.profileRoute,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
});
