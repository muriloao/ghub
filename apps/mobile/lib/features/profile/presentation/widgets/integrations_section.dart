import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/profile_providers.dart';
import '../../domain/entities/profile_entities.dart';
import '../../../../core/theme/app_theme.dart';

class IntegrationsSection extends ConsumerWidget {
  const IntegrationsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final integrations = ref.watch(integrationsProvider);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (integrations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Integrations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          ...integrations.map(
            (integration) =>
                _buildIntegrationCard(integration, isDarkMode, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildIntegrationCard(
    Integration integration,
    bool isDarkMode,
    WidgetRef ref,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppTheme.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: integration.backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(integration.icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  integration.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  integration.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              Text(
                'Active',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: integration.isActive ? AppTheme.primary : Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => ref
                    .read(profileNotifierProvider.notifier)
                    .toggleIntegration(integration.id),
                child: Container(
                  width: 40,
                  height: 24,
                  decoration: BoxDecoration(
                    color: integration.isActive
                        ? AppTheme.primary.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: integration.isActive
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: integration.isActive
                            ? AppTheme.primary
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
