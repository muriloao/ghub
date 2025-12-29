import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class LoadingSpinner extends StatelessWidget {
  final Animation<double> pulseAnimation;
  final Animation<double> rotationAnimation;

  const LoadingSpinner({
    super.key,
    required this.pulseAnimation,
    required this.rotationAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      height: 128,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer pulsing ring
          AnimatedBuilder(
            animation: pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: pulseAnimation.value,
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primary.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),

          // Rotating ring
          AnimatedBuilder(
            animation: rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: rotationAnimation.value * 2 * 3.14159,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border(
                      top: BorderSide(color: AppTheme.primary, width: 2),
                      right: BorderSide(color: AppTheme.primary, width: 2),
                      bottom: BorderSide.none,
                      left: BorderSide.none,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Center hexagon icon
          AnimatedBuilder(
            animation: pulseAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: pulseAnimation.value,
                child: Icon(Icons.hexagon, size: 36, color: AppTheme.primary),
              );
            },
          ),
        ],
      ),
    );
  }
}
