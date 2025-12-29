import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_loading_page.dart';
import '../constants/app_constants.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppConstants.loginRoute,
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
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Home Page - Under Development')),
        ),
      ),
    ],
  );
});
