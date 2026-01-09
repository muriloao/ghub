import 'package:dio/dio.dart';
import '../../../../core/config/steam_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache_service.dart';
import '../models/steam_game_model.dart';
import '../models/steam_game_details_model.dart';
import '../models/steam_achievement_model.dart';

class SteamGamesService {
  final Dio _dio;

  SteamGamesService(this._dio);

  /// Busca todos os jogos do usuário Steam
  /// Usa cache se disponível e não expirado
  Future<List<SteamGameModel>> getUserGames(
    String steamId, {
    bool forceRefresh = false,
  }) async {
    try {
      // Verificar cache se não for refresh forçado
      if (!forceRefresh) {
        final cache = await PlatformCacheExtension.getSteamCache();
        if (cache != null && !cache.isExpired() && cache.gamesData != null) {
          // Converter dados do cache para modelos
          return cache.gamesData!
              .map((json) => SteamGameModel.fromJson(json))
              .toList();
        }
      }

      // Buscar dados da API
      final response = await _dio.get(
        '${SteamConfig.steamApiUrl}/IPlayerService/GetOwnedGames/v0001/',
        queryParameters: {
          'key': SteamConfig.apiKey,
          'steamid': steamId,
          'format': 'json',
          'include_appinfo': 'true',
          'include_played_free_games': 'true',
        },
      );

      if (response.statusCode == 200) {
        final steamResponse = SteamOwnedGamesResponse.fromJson(
          response.data['response'],
        );

        // Salvar no cache
        await PlatformCacheExtension.cacheSteamData(games: steamResponse.games);

        return steamResponse.games;
      } else {
        throw ServerException(
          message: 'Erro ao buscar jogos: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      // Em caso de erro de rede, tentar usar cache mesmo se expirado
      final cache = await PlatformCacheExtension.getSteamCache();
      if (cache != null && cache.gamesData != null) {
        return cache.gamesData!
            .map((json) => SteamGameModel.fromJson(json))
            .toList();
      }

      throw ServerException(
        message: 'Erro de conexão com Steam API: ${e.message}',
      );
    } catch (e) {
      throw ServerException(message: 'Erro inesperado ao buscar jogos: $e');
    }
  }

  /// Busca detalhes de um jogo específico
  Future<SteamGameDetailsModel?> getGameDetails(String appId) async {
    try {
      final response = await _dio.get(
        'https://store.steampowered.com/api/appdetails',
        queryParameters: {
          'appids': appId,
          'format': 'json',
          'l': 'pt',
        }, // TODO linguagem do usuário
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final gameData = data[appId];

        if (gameData != null &&
            gameData['success'] == true &&
            gameData['data'] != null) {
          return SteamGameDetailsModel.fromJson(gameData['data']);
        }
      }

      return null;
    } on DioException catch (e) {
      throw ServerException(
        message: 'Erro ao buscar detalhes do jogo: ${e.message}',
      );
    } catch (e) {
      throw ServerException(
        message: 'Erro inesperado ao buscar detalhes do jogo: $e',
      );
    }
  }

  /// Busca estatísticas de um jogador
  Future<Map<String, dynamic>?> getPlayerStats(
    String steamId,
    String appId,
  ) async {
    try {
      final response = await _dio.get(
        '${SteamConfig.steamApiUrl}/ISteamUserStats/GetPlayerAchievements/v0001/',
        queryParameters: {
          'key': SteamConfig.apiKey,
          'steamid': steamId,
          'appid': appId,
          'format': 'json',
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      }

      return null;
    } on DioException {
      // Muitos jogos não têm achievements públicos, então não é um erro crítico
      return null;
    }
  }

  /// Busca jogos recentemente jogados
  Future<List<SteamGameModel>> getRecentlyPlayedGames(String steamId) async {
    try {
      final response = await _dio.get(
        '${SteamConfig.steamApiUrl}/IPlayerService/GetRecentlyPlayedGames/v0001/',
        queryParameters: {
          'key': SteamConfig.apiKey,
          'steamid': steamId,
          'format': 'json',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['response'];
        if (data != null && data['games'] != null) {
          final games = (data['games'] as List)
              .map((game) => SteamGameModel.fromJson(game))
              .toList();
          return games;
        }
      }

      return [];
    } on DioException catch (e) {
      throw ServerException(
        message: 'Erro ao buscar jogos recentes: ${e.message}',
      );
    } catch (e) {
      throw ServerException(
        message: 'Erro inesperado ao buscar jogos recentes: $e',
      );
    }
  }

  /// Busca achievements do usuário para um jogo específico
  Future<List<SteamAchievementModel>> getPlayerAchievements(
    String steamId,
    String appId,
  ) async {
    try {
      final response = await _dio.get(
        SteamConfig.getPlayerAchievementsUrl,
        queryParameters: {
          'key': SteamConfig.apiKey,
          'steamid': steamId,
          'appid': appId,
          'format': 'json',
          'l':
              'pt', // Idioma inglês para consistência TODO: linguagem do usuário
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['playerstats'];
        if (data != null &&
            data['success'] == true &&
            data['achievements'] != null) {
          final achievementsResponse = SteamPlayerAchievementsResponse.fromJson(
            data,
          );
          return achievementsResponse.achievements;
        }
      }

      return [];
    } on DioException {
      // Nem todos os jogos têm achievements ou estão públicos
      return [];
    }
  }

  /// Busca schema de achievements de um jogo (informações globais)
  Future<List<SteamAchievementSchemaModel>> getGameAchievementSchema(
    String appId,
  ) async {
    try {
      final response = await _dio.get(
        SteamConfig.getSchemaForGameUrl,
        queryParameters: {
          'key': SteamConfig.apiKey,
          'appid': appId,
          'format': 'json',
          'l': 'en',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['game'];
        if (data != null) {
          final schemaResponse = SteamAchievementSchemaResponse.fromJson(data);
          return schemaResponse.achievements;
        }
      }

      return [];
    } on DioException {
      return [];
    }
  }

  /// Busca percentuais globais de achievements de um jogo
  Future<Map<String, double>> getGlobalAchievementPercentages(
    String appId,
  ) async {
    try {
      final response = await _dio.get(
        '${SteamConfig.steamApiUrl}/ISteamUserStats/GetGlobalAchievementPercentagesForApp/v0002/',
        queryParameters: {'gameid': appId, 'format': 'json'},
      );

      if (response.statusCode == 200) {
        final data = response.data['achievementpercentages'];
        if (data != null) {
          final percentagesResponse =
              SteamGlobalAchievementPercentagesResponse.fromJson(data);
          return percentagesResponse.percentageMap;
        }
      }

      return {};
    } on DioException {
      return {};
    }
  }

  /// Busca achievements completos de um jogo (combinando dados do usuário, schema e percentuais)
  Future<List<CompleteSteamAchievementModel>> getCompleteGameAchievements(
    String steamId,
    String appId,
  ) async {
    try {
      // Buscar em paralelo: achievements do usuário, schema e percentuais globais
      final results = await Future.wait([
        getPlayerAchievements(steamId, appId),
        getGameAchievementSchema(appId),
        getGlobalAchievementPercentages(appId),
      ]);

      final userAchievements = results[0] as List<SteamAchievementModel>;
      final schemaAchievements =
          results[1] as List<SteamAchievementSchemaModel>;
      final globalPercentages = results[2] as Map<String, double>;

      // Criar mapa de achievements do usuário por apiname
      final userAchievementMap = <String, SteamAchievementModel>{};
      for (final achievement in userAchievements) {
        userAchievementMap[achievement.apiName] = achievement;
      }

      // Combinar dados
      final List<CompleteSteamAchievementModel> completeAchievements = [];

      for (final schemaAchievement in schemaAchievements) {
        final userAchievement = userAchievementMap[schemaAchievement.name];

        // Se não há dados do usuário, criar um achievement não desbloqueado
        final finalUserAchievement =
            userAchievement ??
            SteamAchievementModel(
              apiName: schemaAchievement.name,
              achieved: 0,
              unlockTime: 0,
            );

        final globalPercentage = globalPercentages[schemaAchievement.name];

        completeAchievements.add(
          CompleteSteamAchievementModel(
            userAchievement: finalUserAchievement,
            schema: schemaAchievement,
            globalPercentage: globalPercentage,
          ),
        );
      }

      // Ordenar: desbloqueados primeiro, depois por raridade, depois alfabético
      completeAchievements.sort((a, b) {
        // Primeiro, achievements desbloqueados
        if (a.isUnlocked && !b.isUnlocked) return -1;
        if (!a.isUnlocked && b.isUnlocked) return 1;

        // Depois por raridade (raros primeiro)
        final rarityComparison = b.rarity.index.compareTo(a.rarity.index);
        if (rarityComparison != 0) return rarityComparison;

        // Por último, alfabético
        return a.name.compareTo(b.name);
      });

      return completeAchievements;
    } catch (e) {
      throw ServerException(
        message: 'Erro ao buscar achievements completos: $e',
      );
    }
  }
}
