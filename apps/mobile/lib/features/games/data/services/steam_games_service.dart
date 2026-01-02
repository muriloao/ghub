import 'package:dio/dio.dart';
import '../../../../core/config/steam_config.dart';
import '../../../../core/error/exceptions.dart';
import '../models/steam_game_model.dart';
import '../models/steam_game_details_model.dart';

class SteamGamesService {
  final Dio _dio;

  SteamGamesService(this._dio);

  /// Busca todos os jogos do usuário Steam
  Future<List<SteamGameModel>> getUserGames(String steamId) async {
    try {
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
        return steamResponse.games;
      } else {
        throw ServerException(
          message: 'Erro ao buscar jogos: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
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
        queryParameters: {'appids': appId, 'format': 'json', 'l': 'en'},
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
    } on DioException catch (e) {
      // Muitos jogos não têm achievements públicos, então não é um erro crítico
      return null;
    } catch (e) {
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
}
