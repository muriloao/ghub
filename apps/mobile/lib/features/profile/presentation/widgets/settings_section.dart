import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/profile_providers.dart';
import '../../domain/entities/profile_entities.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsSection extends ConsumerWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'App Preferences',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? AppTheme.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey.withOpacity(0.1),
              ),
            ),
            child: Column(
              children: [
                for (int i = 0; i < settings.length; i++)
                  _buildSettingItem(
                    settings[i],
                    isDarkMode,
                    isLast: i == settings.length - 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    SettingItem setting,
    bool isDarkMode, {
    bool isLast = false,
  }) {
    return InkWell(
      onTap: setting.onTap,
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(12),
        topRight: const Radius.circular(12),
        bottomLeft: Radius.circular(isLast ? 12 : 0),
        bottomRight: Radius.circular(isLast ? 12 : 0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: !isLast
              ? Border(
                  bottom: BorderSide(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey.withOpacity(0.1),
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: setting.iconBackgroundColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(setting.icon, color: setting.iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                setting.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            if (setting.type == SettingItemType.selection &&
                setting.value != null) ...[
              Text(
                setting.value!,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode
                      ? Colors.grey.shade400
                      : Colors.grey.shade500,
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (setting.type == SettingItemType.toggle) ...[
              Switch.adaptive(
                value: setting.isToggled ?? false,
                onChanged: (value) {
                  // Handle toggle
                  setting.onTap?.call();
                },
                activeColor: AppTheme.primary,
              ),
            ] else ...[
              Icon(
                Icons.chevron_right,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500,
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
