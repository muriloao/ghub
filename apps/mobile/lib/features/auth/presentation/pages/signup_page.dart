import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/auth_notifier.dart';
import '../widgets/signup_form.dart';
import '../widgets/social_login_buttons.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        context.go(AppConstants.onboardingRoute);
      } else if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.backgroundDark
                  : AppTheme.backgroundLight,
              Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.backgroundDark
                  : AppTheme.backgroundLight,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              top: -MediaQuery.of(context).size.height * 0.2,
              right: -MediaQuery.of(context).size.width * 0.1,
              child: Container(
                width: 256,
                height: 256,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -MediaQuery.of(context).size.height * 0.1,
              left: -MediaQuery.of(context).size.width * 0.2,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.blue.shade600.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Top App Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.pop(),
                        ),
                        const Expanded(
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          width: 48,
                        ), // Para balancear o botão de voltar
                      ],
                    ),
                  ),

                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),

                          // Headline
                          _buildHeadlineSection(context),

                          const SizedBox(height: 32),

                          // Sign Up Form
                          SignUpForm(isLoading: authState is AuthLoading),

                          const SizedBox(height: 32),

                          // Divider
                          _buildDivider(context),

                          const SizedBox(height: 32),

                          // Social Login Buttons
                          const SocialLoginButtons(),

                          const SizedBox(height: 32),

                          // Login link
                          _buildLoginLink(context),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadlineSection(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text(
            'JOIN THE NEXUS',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              shadows: [
                Shadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Centralize your stats. Dominate the game.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade300
                : Colors.grey.shade600,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF523b54)
                : Colors.grey.shade300,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'OR REGISTER WITH',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade400
                  : Colors.grey.shade500,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF523b54)
                : Colors.grey.shade300,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          const TextSpan(text: 'Already a player? '),
          WidgetSpan(
            child: GestureDetector(
              onTap: () => context.go(AppConstants.loginRoute),
              child: Text(
                'Log In',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
