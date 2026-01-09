import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ghub_mobile/features/achievements/presentation/pages/game_achievements_section.dart';

/// Página de demonstração dos achievements
/// Para testar: navegue para /achievements-demo no app
class AchievementsDemoPage extends ConsumerWidget {
  const AchievementsDemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF211022),
      appBar: AppBar(
        backgroundColor: const Color(0xFF211022),
        elevation: 0,
        title: const Text(
          'Steam Achievements Demo',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Demonstração de Achievements',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Esta seção mostra como os achievements da Steam são exibidos para um jogo específico. Use um appId de um jogo real da Steam para testar.',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white12),

            // Demo Games List
            ...demoGames.map((game) => _buildGameDemo(context, game)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildGameDemo(BuildContext context, DemoGame game) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2d1b2e),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          // Game Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Game Image
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(game.imageUrl),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {},
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Game Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'App ID: ${game.appId}',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        game.description,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Achievements Section
          GameAchievementsSection(appId: game.appId, gameName: game.name),
        ],
      ),
    );
  }
}

/// Dados de demonstração de jogos
class DemoGame {
  final String appId;
  final String name;
  final String description;
  final String imageUrl;

  const DemoGame({
    required this.appId,
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}

/// Lista de jogos para demonstração (com achievements conhecidos)
final List<DemoGame> demoGames = [
  DemoGame(
    appId: '1091500', // Cyberpunk 2077
    name: 'Cyberpunk 2077',
    description: 'RPG de ação em mundo aberto',
    imageUrl:
        'https://cdn.akamai.steamstatic.com/steam/apps/1091500/header.jpg',
  ),
  DemoGame(
    appId: '1174180', // Red Dead Redemption 2
    name: 'Red Dead Redemption 2',
    description: 'Aventura western em mundo aberto',
    imageUrl:
        'https://cdn.akamai.steamstatic.com/steam/apps/1174180/header.jpg',
  ),
  DemoGame(
    appId: '489830', // The Elder Scrolls V: Skyrim Special Edition
    name: 'The Elder Scrolls V: Skyrim Special Edition',
    description: 'RPG de fantasia épico',
    imageUrl: 'https://cdn.akamai.steamstatic.com/steam/apps/489830/header.jpg',
  ),
  DemoGame(
    appId: '292030', // The Witcher 3: Wild Hunt
    name: 'The Witcher 3: Wild Hunt',
    description: 'RPG de mundo aberto',
    imageUrl: 'https://cdn.akamai.steamstatic.com/steam/apps/292030/header.jpg',
  ),
];

/// Provider da demonstração (pode ser removido em produção)
final achievementsDemoProvider = Provider((ref) => demoGames);
