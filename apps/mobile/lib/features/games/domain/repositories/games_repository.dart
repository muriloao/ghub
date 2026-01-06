import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/game.dart';

abstract class GamesRepository {
  /// Busca todos os jogos do usuário logado (Steam)
  Future<Either<Failure, List<Game>>> getUserGames(String steamId);

  /// Busca jogos Epic Games do usuário
  Future<Either<Failure, List<Game>>> getEpicGames(String accessToken);

  /// Busca todos os jogos de todas as plataformas conectadas
  Future<Either<Failure, List<Game>>> getAllUserGames({
    String? steamId,
    String? epicAccessToken,
  });

  /// Busca jogos com filtro de pesquisa
  Future<Either<Failure, List<Game>>> searchGames(String steamId, String query);

  /// Busca detalhes específicos de um jogo
  Future<Either<Failure, Game>> getGameDetails(String gameId);

  /// Busca jogos por status (owned, wishlist, etc.)
  Future<Either<Failure, List<Game>>> getGamesByStatus(
    String steamId,
    GameStatus status,
  );

  /// Busca jogos por plataforma
  Future<Either<Failure, List<Game>>> getGamesByPlatform(
    String steamId,
    GamePlatform platform,
  );
}
