import 'package:dio/dio.dart';
import '../../../../core/config/epic_games_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/cache_service.dart';
import '../../../auth/data/models/epic_game_model.dart';

class EpicGamesService {
  final Dio _dio;

  EpicGamesService(this._dio);

  /// Busca todos os jogos do usuário Epic Games
  /// Usa cache se disponível e não expirado
  Future<List<EpicGameModel>> getUserGames(
    String accessToken, {
    bool forceRefresh = false,
  }) async {
    try {
      // Verificar cache se não for refresh forçado
      if (!forceRefresh) {
        final cache = await PlatformCacheExtension.getEpicCache();
        if (cache != null && !cache.isExpired() && cache.gamesData != null) {
          // Converter dados do cache para modelos
          return cache.gamesData!
              .map((json) => EpicGameModel.fromJson(json))
              .toList();
        }
      }

      // Primeiro, obter o account ID do usuário
      final accountId = await _getUserAccountId(accessToken);

      // Buscar entitlements (jogos próprios) da API Epic Games
      final response = await _dio.get(
        '${EpicGamesConfig.entitlementsUrl}/$accountId/entitlements',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
        queryParameters: {
          'includeSandboxedEntitlements': 'false',
          'includeRedeemed': 'true',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> entitlements = response.data['data'] ?? [];

        // Converter entitlements para modelos de jogos
        final games = <EpicGameModel>[];

        for (final entitlement in entitlements) {
          // Filtrar apenas entitlements que são jogos
          if (entitlement['entitlementType'] == 'EXECUTABLE' ||
              entitlement['entitlementType'] == 'AUDIENCE') {
            // Buscar detalhes do catálogo se possível
            EpicGameModel? gameDetails;
            try {
              gameDetails = await _getCatalogItem(
                entitlement['catalogItemId'],
                accessToken,
              );
            } catch (e) {
              // Se não conseguir buscar detalhes, criar modelo básico
              gameDetails = EpicGameModel.fromEntitlement(entitlement);
            }

            if (gameDetails != null) {
              games.add(gameDetails);
            }
          }
        }

        // Salvar no cache
        await PlatformCacheExtension.cacheEpicData(
          games: games.map((game) => game.toJson()).toList(),
        );

        return games;
      } else {
        throw ServerException(
          message: 'Falha ao buscar jogos Epic Games: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthenticationException(
          message: 'Token Epic Games expirado. Faça login novamente.',
        );
      }
      throw NetworkException(
        message:
            e.response?.data?['message'] ??
            'Erro de rede ao buscar jogos Epic Games',
      );
    } catch (e) {
      if (e is AuthenticationException || e is NetworkException) rethrow;
      throw ServerException(
        message: 'Erro inesperado ao buscar jogos Epic Games: $e',
      );
    }
  }

  /// Busca detalhes de um item específico do catálogo Epic Games
  Future<EpicGameModel?> _getCatalogItem(
    String catalogItemId,
    String accessToken,
  ) async {
    try {
      final response = await _dio.get(
        '${EpicGamesConfig.catalogUrl}/$catalogItemId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final catalogData = response.data;
        return EpicGameModel.fromCatalogItem(catalogData);
      }
      return null;
    } catch (e) {
      // Se não conseguir buscar detalhes, retorna null
      // O chamador criará um modelo básico
      return null;
    }
  }

  /// Obtém o account ID do usuário autenticado
  Future<String> _getUserAccountId(String accessToken) async {
    try {
      final response = await _dio.get(
        EpicGamesConfig.userInfoUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return response.data[0]['accountId'];
      } else {
        throw ServerException(
          message: 'Não foi possível obter informações do usuário Epic Games',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthenticationException(
          message: 'Token Epic Games inválido ou expirado',
        );
      }
      throw NetworkException(
        message:
            e.response?.data?['message'] ??
            'Erro ao buscar informações do usuário Epic Games',
      );
    }
  }

  /// Busca conquistas de um jogo específico (se disponível)
  /// Epic Games tem suporte limitado para conquistas públicas
  Future<List<Map<String, dynamic>>> getGameAchievements(
    String gameId,
    String accessToken,
  ) async {
    try {
      // Epic Games não tem uma API pública robusta para conquistas
      // Esta é uma implementação placeholder para futura expansão
      return [];
    } catch (e) {
      // Por enquanto, retorna lista vazia se houver erro
      return [];
    }
  }

  /// Obtém estatísticas de jogo (tempo jogado, etc.)
  /// Epic Games tem dados limitados disponíveis publicamente
  Future<Map<String, dynamic>?> getGameStats(
    String gameId,
    String accessToken,
  ) async {
    try {
      // Epic Games não fornece estatísticas detalhadas via API pública
      // Esta é uma implementação placeholder
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Limpa o cache dos jogos Epic Games
  Future<void> clearCache() async {
    try {
      await PlatformCacheExtension.clearPlatformCache(Platform.epic);
    } catch (e) {
      // Log do erro, mas não falha a operação
      print('Erro ao limpar cache Epic Games: $e');
    }
  }

  /// Força atualização dos dados Epic Games
  Future<List<EpicGameModel>> forceRefresh(String accessToken) async {
    await clearCache();
    return getUserGames(accessToken, forceRefresh: true);
  }
}

/// Classe para resposta da API de entitlements Epic Games
class EpicEntitlementsResponse {
  final List<EpicGameModel> games;
  final int total;
  final String? nextCursor;

  const EpicEntitlementsResponse({
    required this.games,
    required this.total,
    this.nextCursor,
  });

  factory EpicEntitlementsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];

    return EpicEntitlementsResponse(
      games: data
          .where(
            (item) =>
                item['entitlementType'] == 'EXECUTABLE' ||
                item['entitlementType'] == 'AUDIENCE',
          )
          .map((item) => EpicGameModel.fromEntitlement(item))
          .toList(),
      total: json['total'] ?? data.length,
      nextCursor: json['nextCursor'],
    );
  }
}
