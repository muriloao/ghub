import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';

/// Splash Screen baseada no design fornecido
///
/// Design features:
/// - Background escuro com grid sutil
/// - Logo central com glow animado
/// - Barra de loading com cor primária
/// - Versão no rodapé
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _progressController;
  late Animation<double> _glowAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSplashSequence();
  }

  void _setupAnimations() {
    // Animação de glow do logo (3 segundos, infinita)
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _glowController.repeat(reverse: true);

    // Animação de progresso (2 segundos)
    _progressController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _progressAnimation =
        Tween<double>(
          begin: 0.0,
          end: 0.67, // 2/3 como no design
        ).animate(
          CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
        );
    _progressController.forward();
  }

  Future<void> _startSplashSequence() async {
    // Aguardar 2.5 segundos para a animação
    await Future.delayed(const Duration(milliseconds: 2500));

    if (mounted) {
      // Verificar estado de autenticação
      final authState = ref.read(authNotifierProvider);

      if (authState is AuthAuthenticated) {
        context.pushReplacement(AppConstants.homeRoute);
      } else {
        context.pushReplacement(AppConstants.loginRoute);
      }
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF211022), // background-dark
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Grid background pattern
          // image: DecorationImage(
          //   image: NetworkImage(
          //     'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 40 40"><defs><pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse"><path d="M 40 0 L 0 0 0 40" fill="none" stroke="%23ffffff" stroke-width="0.5" opacity="0.03"/></pattern></defs><rect width="100%" height="100%" fill="url(%23grid)"/></svg>',
          //   ),
          //   repeat: ImageRepeat.repeat,
          // ),
          // Gradient overlay
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Color(0x80211022), Color(0xFF211022)],
          ),
        ),
        child: Stack(
          alignment: AlignmentGeometry.center,
          children: [
            // Background glow blob
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: 384,
                  height: 384,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFe225f4).withValues(alpha: 0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Main content
            Column(
              children: [
                const Spacer(),

                // Central content with logo
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _glowAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFe225f4).withOpacity(0.3),
                              blurRadius:
                                  15 + (15 * (_glowAnimation.value - 1) * 50),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Logo container
                            Container(
                              width: 128,
                              height: 128,
                              margin: const EdgeInsets.only(bottom: 24),
                              child: Stack(
                                children: [
                                  // Outer hexagon-ish shape
                                  Positioned.fill(
                                    child: Transform.rotate(
                                      angle: 0.785398, // 45 degrees
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFFe225f4),
                                              Color(0xFF9333ea),
                                            ],
                                          ),
                                        ),
                                        child: Opacity(
                                          opacity: 0.2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              gradient: const LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Color(0xFFe225f4),
                                                  Color(0xFF9333ea),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Inner shape
                                  Positioned(
                                    left: 8,
                                    top: 8,
                                    right: 8,
                                    bottom: 8,
                                    child: Transform.rotate(
                                      angle: 0.785398, // 45 degrees
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF211022),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: const Color(
                                              0xFFe225f4,
                                            ).withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Controller icon
                                  const Positioned.fill(
                                    child: Icon(
                                      Icons.sports_esports_outlined,
                                      size: 84,
                                      color: Color(0xFFe225f4),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Brand name
                            const Text(
                              'GHub',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -1,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Tagline
                            const Text(
                              'CENTRALIZE YOUR GAME',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 4,
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Loading indicator
                            SizedBox(
                              width: 200,
                              child: Column(
                                children: [
                                  Container(
                                    height: 4,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: AnimatedBuilder(
                                      animation: _progressAnimation,
                                      builder: (context, child) {
                                        return FractionallySizedBox(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: _progressAnimation.value,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFe225f4),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(
                                                    0xFFe225f4,
                                                  ).withOpacity(0.8),
                                                  blurRadius: 10,
                                                  spreadRadius: 0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const Spacer(),

                // Footer with version
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    children: [
                      Text(
                        'v1.0.0',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
