import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/game.dart';
import '../../domain/repositories/games_repository.dart';
import '../datasources/games_remote_data_source.dart';
import '../services/steam_games_service.dart';

class GamesRepositoryImpl implements GamesRepository {
  final GamesRemoteDataSource remoteDataSource;
  final SteamGamesService steamGamesService;

  GamesRepositoryImpl({
    required this.remoteDataSource,
    required this.steamGamesService,
  });

  @override
  Future<Either<Failure, List<Game>>> getUserGames(String steamId) async {
    try {
      final steamGames = await steamGamesService.getUserGames(steamId);

      // Converte SteamGameModel para Game entity
      final games = steamGames.map((steamGame) {
        return steamGame.toDomainEntity();
      }).toList();

      // Ordena por tempo de jogo (mais jogados primeiro)
      games.sort((a, b) {
        final aPlaytime = a.playtimeForever ?? 0;
        final bPlaytime = b.playtimeForever ?? 0;
        return bPlaytime.compareTo(aPlaytime);
      });

      return Right(games);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Game>>> getAllUserGames({
    String? steamId,
    String? epicAccessToken,
  }) async {
    try {
      final List<Game> allGames = [];

      // Buscar jogos Steam se steamId fornecido
      if (steamId != null && steamId.isNotEmpty) {
        final steamResult = await getUserGames(steamId);
        steamResult.fold((failure) {
          // Log do erro mas não falha a operação
          print('Erro ao buscar jogos Steam: ${failure.message}');
        }, (games) => allGames.addAll(games));
      }

      // Ordena todos os jogos por nome
      allGames.sort((a, b) => a.name.compareTo(b.name));

      return Right(allGames);
    } catch (e) {
      return Left(
        ServerFailure('Erro ao buscar jogos de todas as plataformas: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Game>>> searchGames(
    String steamId,
    String query,
  ) async {
    try {
      final allGames = await getUserGames(steamId);

      return allGames.fold((failure) => Left(failure), (games) {
        final filteredGames = games.where((game) {
          return game.name.toLowerCase().contains(query.toLowerCase()) ||
              (game.developer?.toLowerCase().contains(query.toLowerCase()) ??
                  false) ||
              (game.publisher?.toLowerCase().contains(query.toLowerCase()) ??
                  false) ||
              (game.genres?.any(
                    (genre) =>
                        genre.toLowerCase().contains(query.toLowerCase()),
                  ) ??
                  false);
        }).toList();

        return Right(filteredGames);
      });
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro inesperado na pesquisa: $e'));
    }
  }

  @override
  Future<Either<Failure, Game>> getGameDetails(String gameId) async {
    try {
      final gameDetails = await steamGamesService.getGameDetails(gameId);

      if (gameDetails == null) {
        return const Left(ServerFailure('Jogo não encontrado'));
      }

      // Converte detalhes para Game entity
      final game = Game(
        id: gameDetails.steamAppId.toString(),
        name: gameDetails.name,
        imageUrl: gameDetails.headerImage,
        headerImageUrl: gameDetails.headerImage,
        status: GameStatus.owned,
        platforms: _determinePlatforms(gameDetails.platforms),
        description: gameDetails.shortDescription ?? gameDetails.aboutTheGame,
        developer: gameDetails.developers?.first,
        publisher: gameDetails.publishers?.first,
        genres: gameDetails.genres?.map((g) => g.description).toList(),
        releaseDate: gameDetails.releaseDate?.date,
      );

      return Right(game);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro inesperado ao buscar detalhes: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Game>>> getGamesByStatus(
    String steamId,
    GameStatus status,
  ) async {
    try {
      final allGames = await getUserGames(steamId);

      return allGames.fold((failure) => Left(failure), (games) {
        final filteredGames = games
            .where((game) => game.status == status)
            .toList();
        return Right(filteredGames);
      });
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erro inesperado ao filtrar por status: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Game>>> getGamesByPlatform(
    String steamId,
    GamePlatform platform,
  ) async {
    try {
      final allGames = await getUserGames(steamId);

      return allGames.fold((failure) => Left(failure), (games) {
        final filteredGames = games.where((game) {
          return game.platforms.contains(platform);
        }).toList();
        return Right(filteredGames);
      });
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Erro inesperado ao filtrar por plataforma: $e'),
      );
    }
  }

  List<GamePlatform> _determinePlatforms(dynamic platformsData) {
    final platforms = <GamePlatform>[];

    if (platformsData != null) {
      if (platformsData['windows'] == true) platforms.add(GamePlatform.pc);
      if (platformsData['mac'] == true) platforms.add(GamePlatform.pc);
      if (platformsData['linux'] == true) platforms.add(GamePlatform.pc);
    } else {
      // Por padrão, jogos Steam são PC
      platforms.add(GamePlatform.pc);
    }

    return platforms.isNotEmpty ? platforms : [GamePlatform.pc];
  }
}
