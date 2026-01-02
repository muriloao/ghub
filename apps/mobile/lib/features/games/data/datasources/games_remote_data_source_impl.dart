import 'package:dio/dio.dart';
import '../../../../core/config/steam_config.dart';
import '../../../../core/error/exceptions.dart';
import '../models/steam_game_model.dart';
import '../models/steam_game_details_model.dart';
import 'games_remote_data_source.dart';

class GamesRemoteDataSourceImpl implements GamesRemoteDataSource {
  final Dio _dio;

  GamesRemoteDataSourceImpl(this._dio);

  @override
  Future<SteamOwnedGamesResponse> getSteamOwnedGames(String steamId) async {
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
        return SteamOwnedGamesResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Erro ao buscar jogos: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const ServerException(
          message: 'Timeout na conexão com Steam API',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw const ServerException(message: 'Erro de conexão com Steam API');
      } else {
        throw ServerException(message: 'Erro ao buscar jogos: ${e.message}');
      }
    } catch (e) {
      throw ServerException(message: 'Erro inesperado ao buscar jogos: $e');
    }
  }

  @override
  Future<SteamGameDetailsResponse> getSteamGameDetails(String appId) async {
    return getSteamGamesDetails([appId]);
  }

  @override
  Future<SteamGameDetailsResponse> getSteamGamesDetails(
    List<String> appIds,
  ) async {
    try {
      // Steam Store API permite até 100 jogos por vez
      final batchSize = 100;
      final allData = <String, SteamGameDetailsModel?>{};

      for (int i = 0; i < appIds.length; i += batchSize) {
        final batch = appIds.skip(i).take(batchSize).toList();
        final appidsParam = batch.join(',');

        final response = await _dio.get(
          'https://store.steampowered.com/api/appdetails',
          queryParameters: {
            'appids': appidsParam,
            'format': 'json',
            'l': 'en', // língua inglesa por padrão
          },
        );

        if (response.statusCode == 200) {
          final batchResponse = SteamGameDetailsResponse.fromJson(
            response.data,
          );
          allData.addAll(batchResponse.data);
        } else {
          // Se falhar, adiciona null para todos os IDs do batch
          for (final appId in batch) {
            allData[appId] = null;
          }
        }

        // Pequeno delay para evitar rate limiting
        if (i + batchSize < appIds.length) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }

      return SteamGameDetailsResponse(data: allData);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const ServerException(
          message: 'Timeout na conexão com Steam Store API',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw const ServerException(
          message: 'Erro de conexão com Steam Store API',
        );
      } else {
        throw ServerException(
          message: 'Erro ao buscar detalhes dos jogos: ${e.message}',
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Erro inesperado ao buscar detalhes dos jogos: $e',
      );
    }
  }
}
