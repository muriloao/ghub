import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/game.dart';
import '../repositories/games_repository.dart';

class FilterGames implements UseCase<List<Game>, FilterGamesParams> {
  final GamesRepository repository;

  FilterGames(this.repository);

  @override
  Future<Either<Failure, List<Game>>> call(FilterGamesParams params) async {
    if (params.status != null) {
      return await repository.getGamesByStatus(params.steamId, params.status!);
    }

    if (params.platform != null) {
      return await repository.getGamesByPlatform(
        params.steamId,
        params.platform!,
      );
    }

    return await repository.getUserGames(params.steamId);
  }
}

class FilterGamesParams {
  final String steamId;
  final GameStatus? status;
  final GamePlatform? platform;

  FilterGamesParams({required this.steamId, this.status, this.platform});
}
