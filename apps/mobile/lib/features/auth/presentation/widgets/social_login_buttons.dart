import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import '../providers/auth_notifier.dart';

class SocialLoginButtons extends ConsumerWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    // Determina qual botão mostrar baseado na plataforma
    final isAndroid = Platform.isAndroid;
    final isIOS = Platform.isIOS;

    Widget loginButton;

    if (isAndroid) {
      // Google Login para Android
      loginButton = _PlatformButton(
        icon: Icons.g_mobiledata,
        label: 'Continuar com Google',
        backgroundColor: Colors.white,
        textColor: Colors.black87,
        iconColor: Colors.red,
        onTap: isLoading
            ? null
            : () => ref.read(authNotifierProvider.notifier).loginWithGoogle(),
      );
    } else if (isIOS) {
      // Apple Login para iOS
      loginButton = _PlatformButton(
        icon: Icons.apple,
        label: 'Continuar com Apple',
        backgroundColor: Colors.black,
        textColor: Colors.white,
        iconColor: Colors.white,
        onTap: isLoading
            ? null
            : () {
                // TODO: Implementar login Apple
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Login com Apple será implementado em breve!',
                    ),
                  ),
                );
              },
      );
    } else {
      // Fallback para outras plataformas (web, desktop)
      loginButton = _PlatformButton(
        icon: Icons.g_mobiledata,
        label: 'Continuar com Google',
        backgroundColor: Colors.white,
        textColor: Colors.black87,
        iconColor: Colors.red,
        onTap: isLoading
            ? null
            : () => ref.read(authNotifierProvider.notifier).loginWithGoogle(),
      );
    }

    return Center(
      child: SizedBox(width: double.infinity, child: loginButton),
    );
  }
}

class _PlatformButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final VoidCallback? onTap;

  const _PlatformButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    this.onTap,
  });

  @override
  State<_PlatformButton> createState() => _PlatformButtonState();
}

class _PlatformButtonState extends State<_PlatformButton>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
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
              height: 56,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: widget.backgroundColor == Colors.white
                    ? Border.all(color: Colors.grey.shade300, width: 1)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, color: widget.iconColor, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
