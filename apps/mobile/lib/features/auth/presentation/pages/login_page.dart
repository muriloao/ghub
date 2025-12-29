import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/auth_notifier.dart';
import '../widgets/login_form.dart';
import '../widgets/social_login_buttons.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      switch (next) {
        case AuthAuthenticated():
          context.go(AppConstants.homeRoute);
          break;
        case AuthError(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red),
          );
          break;
        case AuthInitial():
        case AuthLoading():
        case AuthUnauthenticated():
          break;
      }
    });

    return Scaffold(
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header with animated background
                const _HeaderSection(),

                // Main Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),

                      // Title and subtitle
                      _buildTitleSection(context),

                      const SizedBox(height: 40),

                      // Login Form
                      LoginForm(isLoading: authState is AuthLoading),

                      const SizedBox(height: 32),

                      // Divider
                      _buildDivider(context),

                      const SizedBox(height: 32),

                      // Social Login Buttons
                      const SocialLoginButtons(),

                      const SizedBox(height: 40),

                      // Sign up link
                      _buildSignUpLink(context),

                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    return Column(
      children: [
        Text(
          AppConstants.appName,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          AppConstants.appSlogan,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppTheme.textSecondaryDark
                : AppTheme.textSecondaryLight,
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
            color: Theme.of(context).dividerColor.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Ou continue com',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.4)
                  : Colors.grey.shade500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Theme.of(context).dividerColor.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          const TextSpan(text: 'Não tem uma conta? '),
          WidgetSpan(
            child: GestureDetector(
              onTap: () => context.go(AppConstants.signUpRoute),
              child: Text(
                'Cadastre-se',
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

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.8),
            AppTheme.primaryColor.withOpacity(0.6),
            AppTheme.primaryColor.withOpacity(0.4),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _GridPainter(color: Colors.white.withOpacity(0.1)),
            ),
          ),

          // Logo
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.sports_esports,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;

  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const gridSize = 30.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
