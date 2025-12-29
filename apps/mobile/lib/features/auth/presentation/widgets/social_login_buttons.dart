import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../providers/auth_notifier.dart';

class SocialLoginButtons extends ConsumerWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google Login Button
        _SocialButton(
          icon: Icons.email_outlined,
          label: 'Google',
          onTap: isLoading
              ? null
              : () => ref.read(authNotifierProvider.notifier).loginWithGoogle(),
        ),

        const SizedBox(width: 24),

        // Apple Login Button (placeholder)
        _SocialButton(
          icon: Icons.apple_outlined,
          label: 'Apple',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login com Apple em breve!')),
            );
          },
        ),

        const SizedBox(width: 24),

        // Steam Login Button
        _SocialButton(
          icon: Icons.sports_esports_outlined,
          label: 'Steam',
          onTap: isLoading
              ? null
              : () => ref.read(authNotifierProvider.notifier).loginWithSteam(),
        ),
      ],
    );
  }
}

class _SocialButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _SocialButton({required this.icon, required this.label, this.onTap});

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null
          ? (_) => _animationController.forward()
          : null,
      onTapUp: widget.onTap != null
          ? (_) => _animationController.reverse()
          : null,
      onTapCancel: widget.onTap != null
          ? () => _animationController.reverse()
          : null,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.surfaceDark
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.transparent
                      : Colors.grey.shade200,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: 24,
                    color: widget.onTap != null
                        ? (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.grey.shade700)
                        : Colors.grey.shade400,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: widget.onTap != null
                          ? (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withOpacity(0.7)
                                : Colors.grey.shade600)
                          : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
