import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/integrations_providers.dart';
import '../widgets/platform_card.dart';
import '../widgets/integrations_progress_bar.dart';
import '../widgets/platform_sync_section.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';

class IntegrationsPage extends ConsumerWidget {
  const IntegrationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platforms = ref.watch(integrationsListProvider);
    final isLoading = ref.watch(isLoadingIntegrationsProvider);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Listen to errors and show snackbar
    ref.listen(integrationsErrorProvider, (previous, next) {
      if (next != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {
                ref.read(integrationsNotifierProvider.notifier).clearError();
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
                _buildHeader(context, isDarkMode),
                _buildProgressSection(),
                _buildSyncSection(),
                _buildPlatformsList(platforms),
              ],
            ],
          ),
          _buildFooter(context, isDarkMode, ref),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDarkMode) {
    return SliverAppBar(
      backgroundColor: isDarkMode
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      floating: true,
      pinned: false,
      leading: context.canPop()
          ? IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Icons.arrow_back,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            )
          : null,
      title: Text(
        'Connect Accounts',
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            'Skip',
            style: TextStyle(
              color: AppTheme.textSecondaryDark,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Centralize Your Library',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Connect your accounts to sync games, achievements, and friends across all your platforms.',
              style: TextStyle(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.7)
                    : Colors.grey.shade600,
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return const SliverToBoxAdapter(child: IntegrationsProgressBar());
  }

  Widget _buildSyncSection() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: PlatformSyncSection(),
      ),
    );
  }

  Widget _buildPlatformsList(List platforms) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final platform = platforms[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == platforms.length - 1 ? 120 : 16,
            ),
            child: PlatformCard(
              platform: platform,
              onTap: () {
                // TODO: Handle platform tap (show details, manage, etc.)
              },
            ),
          );
        }, childCount: platforms.length),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDarkMode, WidgetRef ref) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              (isDarkMode ? AppTheme.backgroundDark : AppTheme.backgroundLight)
                  .withOpacity(0.0),
              (isDarkMode ? AppTheme.backgroundDark : AppTheme.backgroundLight)
                  .withOpacity(0.8),
              isDarkMode ? AppTheme.backgroundDark : AppTheme.backgroundLight,
            ],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  // Marcar usuário como retornante e navegar para home
                  final authState = ref.read(authNotifierProvider);
                  if (authState is AuthAuthenticated) {
                    await ref
                        .read(navigationControllerProvider.notifier)
                        .markUserAsReturning(authState.user.email);
                    if (context.mounted) {
                      context.go(AppConstants.homeRoute);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: AppTheme.primary.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 14,
                  color: AppTheme.textSecondaryDark,
                ),
                const SizedBox(width: 6),
                Text(
                  'Data is read-only and secure',
                  style: TextStyle(
                    color: AppTheme.textSecondaryDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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
