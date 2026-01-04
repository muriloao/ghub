import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/integrations_providers.dart';
import '../../../../core/theme/app_theme.dart';

class IntegrationsProgressBar extends ConsumerWidget {
  const IntegrationsProgressBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectedCount = ref.watch(connectedCountProvider);
    final totalPlatforms = ref.watch(integrationsListProvider).length;
    final progress = ref.watch(connectionProgressProvider);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (totalPlatforms == 0) {
      return const SizedBox.shrink();
    }

    final percentage = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$connectedCount of $totalPlatforms connected'.toUpperCase(),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.8)
                      : Colors.grey.shade600,
                ),
              ),
              Text(
                '$percentage%',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppTheme.primary.withOpacity(0.1)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                width: MediaQuery.of(context).size.width * progress,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primary,
                      AppTheme.primary.withOpacity(0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
