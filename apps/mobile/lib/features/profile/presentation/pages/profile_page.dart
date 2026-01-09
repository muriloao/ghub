import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';

import '../providers/profile_providers.dart';
import '../widgets/profile_header.dart';
import '../widgets/stats_section.dart';
import '../widgets/connected_platforms_section.dart';
import '../widgets/integrations_section.dart';
import '../widgets/settings_section.dart';
import '../../../../core/theme/app_theme.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProfileProvider);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Listen to errors and show snackbar
    ref.listen(profileErrorProvider, (previous, next) {
      if (next != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {
                ref.read(profileNotifierProvider.notifier).clearError();
              },
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context, isDarkMode),
              if (isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppTheme.primary),
                  ),
                )
              else ...[
                // Profile Header
                const SliverToBoxAdapter(child: ProfileHeader()),

                // Stats Section
                const SliverToBoxAdapter(child: StatsSection()),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // Connected Platforms
                const SliverToBoxAdapter(child: ConnectedPlatformsSection()),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // Integrations
                const SliverToBoxAdapter(child: IntegrationsSection()),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // Settings
                const SliverToBoxAdapter(child: SettingsSection()),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                // Logout Section
                SliverToBoxAdapter(child: _buildLogoutSection(isDarkMode)),

                // App Version
                SliverToBoxAdapter(child: _buildVersionInfo(isDarkMode)),

                // Bottom padding for navigation
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ],
          ),

          // Bottom Navigation (same as GamesPage)
          _buildBottomNavigation(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDarkMode) {
    return SliverAppBar(
      backgroundColor: isDarkMode
          ? AppTheme.backgroundDark.withValues(alpha: 0.95)
          : AppTheme.backgroundLight.withValues(alpha: 0.95),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      floating: true,
      pinned: false,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(
          Icons.arrow_back,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      title: Text(
        'Profile & Settings',
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        // Invisible placeholder for symmetry
        Container(width: 48),
      ],
    );
  }

  Widget _buildLogoutSection(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                // Implementar funcionalidade de logout
                _showLogoutDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withValues(alpha: 0.1),
                foregroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.red.withValues(alpha: 0.2)),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Log Out',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVersionInfo(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          'GHub v1.0.4 build 209',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'monospace',
            color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context, bool isDarkMode) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppTheme.backgroundDark.withValues(alpha: 0.95)
              : AppTheme.backgroundLight.withValues(alpha: 0.95),
          border: Border(
            top: BorderSide(
              color: isDarkMode
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.grey.withValues(alpha: 0.1),
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, 'Home', false, () => context.pop()),
                _buildNavItem(Icons.grid_view, 'Library', false, () {}),
                _buildNavItem(Icons.person, 'Profile', true, () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isActive ? AppTheme.primary : Colors.grey.shade400,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? AppTheme.primary : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A1A2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF6B46C1), width: 1),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.red[400], size: 24),
              const SizedBox(width: 8),
              const Text(
                'Confirmar Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: const Text(
            'Você tem certeza que deseja sair da sua conta? '
            'Será necessário fazer login novamente na próxima vez.',
            style: TextStyle(color: Color(0xFFE5E7EB), fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF9CA3AF),
              ),
              child: const Text('Cancelar'),
            ),
            Consumer(
              builder: (context, ref, child) {
                return ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();

                    // Executar logout
                    final authNotifier = ref.read(
                      authNotifierProvider.notifier,
                    );
                    await authNotifier.logout();

                    // Navegar para tela de login
                    if (context.mounted) {
                      context.pushReplacement(AppConstants.loginRoute);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Sair',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
