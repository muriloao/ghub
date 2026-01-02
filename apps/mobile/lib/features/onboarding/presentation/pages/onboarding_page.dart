import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/onboarding_notifier.dart';
import '../widgets/onboarding_app_bar.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/progress_section.dart';
import '../widgets/platform_cards_list.dart';
import '../widgets/onboarding_footer.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingNotifierProvider);

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
          child: Column(
            children: [
              // Top App Bar
              OnboardingAppBar(
                onBack: () => context.go(AppConstants.loginRoute),
                onSkip: () => _handleSkip(ref, context),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      const OnboardingHeader(),

                      // Progress Section
                      onboardingState.when(
                        loading: () => const ProgressSection(
                          connectedCount: 0,
                          totalCount: 5,
                          percentage: 0.0,
                        ),
                        loaded: (progress) => ProgressSection(
                          connectedCount: progress.connectedPlatformsCount,
                          totalCount: progress.platforms.length,
                          percentage: progress.completionPercentage,
                        ),
                        error: (message) => ProgressSection(
                          connectedCount: 0,
                          totalCount: 5,
                          percentage: 0.0,
                        ),
                      ),

                      // Platform Cards
                      onboardingState.when(
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        loaded: (progress) => PlatformCardsList(
                          platforms: progress.platforms,
                          onConnect: (platformId) =>
                              _handleConnect(ref, platformId),
                          onManage: (platformId) =>
                              _handleManage(ref, platformId),
                        ),
                        error: (message) => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red.withOpacity(0.7),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Erro ao carregar plataformas',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  message,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () =>
                                      ref.refresh(onboardingNotifierProvider),
                                  child: const Text('Tentar Novamente'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Add bottom padding for footer
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating Footer
      bottomSheet: onboardingState.maybeWhen(
        loaded: (progress) => OnboardingFooter(
          canContinue: progress.connectedPlatformsCount > 0,
          onContinue: () => _handleContinue(ref, context),
        ),
        orElse: () => OnboardingFooter(
          canContinue: false,
          onContinue: () => _handleContinue(ref, context),
        ),
      ),
    );
  }

  void _handleConnect(WidgetRef ref, String platformId) {
    // TODO: Implement platform connection logic
    ref
        .read(onboardingNotifierProvider.notifier)
        .connectPlatform(platformId, {});
  }

  void _handleManage(WidgetRef ref, String platformId) {
    // TODO: Implement platform management logic
    ScaffoldMessenger.of(ref.context).showSnackBar(
      SnackBar(content: Text('Gerenciar $platformId - Em desenvolvimento')),
    );
  }

  void _handleSkip(WidgetRef ref, BuildContext context) {
    ref.read(onboardingNotifierProvider.notifier).skipOnboarding();
    context.go(AppConstants.homeRoute);
  }

  void _handleContinue(WidgetRef ref, BuildContext context) {
    ref.read(onboardingNotifierProvider.notifier).completeOnboarding();
    context.go(AppConstants.homeRoute);
  }
}
