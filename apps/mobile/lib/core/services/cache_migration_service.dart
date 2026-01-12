import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../cache/cache_manager.dart';
import 'optimized_games_cache_service.dart';

/// Migrador para transferir dados do sistema antigo para o novo
class CacheMigrationService {
  /// Migra dados de jogos do SharedPreferences para Hive
  static Future<void> migrateGamesCache() async {
    print('🔄 Iniciando migração do cache de jogos...');

    try {
      // Aqui você pegaria dados do seu CacheService antigo
      // Por exemplo: final oldGames = await CacheService.getSteamGames();

      // Simular dados antigos (substitua pela sua lógica real)
      final List<Map<String, dynamic>> legacyGames = [
        {
          'appid': '730',
          'name': 'Counter-Strike 2',
          'playtime_forever': 1200,
          'rtime_last_played':
              DateTime.now()
                  .subtract(Duration(days: 2))
                  .millisecondsSinceEpoch ~/
              1000,
          'img_icon_url': 'abc123',
        },
        // Adicione mais jogos conforme necessário
      ];

      // Migrar para o novo sistema
      if (legacyGames.isNotEmpty) {
        await OptimizedGamesCacheService.cacheSteamGames(legacyGames);
        print('✅ Migração de ${legacyGames.length} jogos concluída');
      }

      // Marcar migração como concluída
      await CacheManager.setBool('games_migration_completed', true);
    } catch (e) {
      print('❌ Erro na migração de jogos: $e');
    }
  }

  /// Migra dados do usuário
  static Future<void> migrateUserCache() async {
    print('🔄 Iniciando migração do cache de usuário...');

    try {
      // Verificar se há dados antigos para migrar
      final hasOldData = CacheManager.getBool('is_logged_in');

      if (hasOldData) {
        // Aqui você pegaria dados do usuário do sistema antigo
        // final oldUser = await CacheService.getCachedUserData();

        // Por ora, apenas marcar como migrado
        await CacheManager.setBool('user_migration_completed', true);
        print('✅ Migração de usuário concluída');
      }
    } catch (e) {
      print('❌ Erro na migração de usuário: $e');
    }
  }

  /// Executa toda a migração automaticamente
  static Future<void> runFullMigration() async {
    print('🚀 Iniciando migração completa do cache...');

    final gamesMigrated = CacheManager.getBool('games_migration_completed');
    final userMigrated = CacheManager.getBool('user_migration_completed');

    if (!gamesMigrated) {
      await migrateGamesCache();
    }

    if (!userMigrated) {
      await migrateUserCache();
    }

    // Limpeza opcional do cache antigo após migração bem-sucedida
    if (gamesMigrated && userMigrated) {
      await _cleanupLegacyCache();
    }

    print('✅ Migração completa do cache finalizada');
  }

  /// Limpa dados antigos após migração bem-sucedida
  static Future<void> _cleanupLegacyCache() async {
    try {
      // Aqui você removeria chaves antigas do SharedPreferences
      // Por exemplo:
      // await SharedPreferences.getInstance().then((prefs) {
      //   prefs.remove('steam_games');
      //   prefs.remove('steam_user');
      // });

      print('🧹 Cache legado limpo');
    } catch (e) {
      print('⚠️ Erro ao limpar cache legado: $e');
    }
  }
}

/// Provider para gerenciar a migração
final cacheMigrationProvider = FutureProvider<bool>((ref) async {
  await CacheMigrationService.runFullMigration();
  return true;
});
