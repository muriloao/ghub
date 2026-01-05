import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/game.dart';
import '../providers/games_providers.dart';
import '../widgets/favorite_button.dart';
import '../../../achievements/presentation/pages/game_achievements_section.dart';

/// Tela de detalhes do jogo baseada no design fornecido
class GameDetailPage extends ConsumerStatefulWidget {
  final String gameId;

  const GameDetailPage({super.key, required this.gameId});

  @override
  ConsumerState<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends ConsumerState<GameDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final games = ref.watch(gamesListProvider);

    if (games.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF211022),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFe225f4)),
          ),
        ),
      );
    }

    // Encontrar o jogo pelo ID
    final game = games.firstWhere(
      (g) => g.id == widget.gameId,
      orElse: () => games.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF211022),
      body: CustomScrollView(
        slivers: [
          // Hero Section
          SliverAppBar(
            expandedHeight: 320,
            pinned: false,
            floating: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroSection(game),
            ),
          ),

          // Sticky Tabs
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              child: Container(
                color: const Color(0xFF211022).withOpacity(0.95),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: const Color(0xFFe225f4),
                  indicatorWeight: 3,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Achievements'),
                    Tab(text: 'Buy Options'),
                  ],
                ),
              ),
            ),
          ),

          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(game),
                _buildAchievementsTab(game),
                _buildBuyOptionsTab(game),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(Game game) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  game.headerImageUrl ??
                      game.imageUrl ??
                      'https://via.placeholder.com/460x215/211022/e225f4?text=${Uri.encodeComponent(game.name)}',
                ),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {},
              ),
            ),
          ),
        ),

        // Gradients
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x99000000),
                  Colors.transparent,
                  Color(0xFF211022),
                ],
              ),
            ),
          ),
        ),

        // Navbar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavButton(
                    Icons.arrow_back_ios_new,
                    onTap: () => context.pop(),
                  ),
                  Row(
                    children: [
                      _buildNavButton(Icons.ios_share),
                      const SizedBox(width: 12),
                      FavoriteButton(
                        game: game,
                        size: 20,
                        // backgroundColor: Colors.black.withOpacity(0.4),
                        // borderColor: Colors.white.withOpacity(0.1),
                        // size: 40,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Hero Content
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Game Title
              Text(
                game.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 4,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Status
              Row(
                children: [
                  Text(
                    'Steam Game',
                    style: TextStyle(color: Colors.grey[300], fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.computer, color: Colors.grey[300], size: 16),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildOverviewTab(Game game) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Status Cards
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.8,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(
                'Status',
                game.status.name.toUpperCase(),
                icon: Icons.play_circle_outlined,
              ),
              _buildStatCard(
                'Completion',
                '${((game.completionPercentage ?? 0) * 100).round()}%',
                progress: game.completionPercentage ?? 0,
                icon: Icons.emoji_events_outlined,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Playtime Card
          _buildPlaytimeCard(game),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value, {
    IconData? icon,
    double? progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2d1b2e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[700],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFe225f4),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlaytimeCard(Game game) {
    final hours = (game.playtimeForever ?? 0) / 60;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2d1b2e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL PLAYTIME',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${hours.round()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' hours',
                  style: TextStyle(color: Colors.grey[500], fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsTab(Game game) {
    return GameAchievementsSection(appId: game.id, gameName: game.name);
  }

  Widget _buildBuyOptionsTab(Game game) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text(
          'Buy options coming soon...',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTabBarDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
