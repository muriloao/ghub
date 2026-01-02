import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/game.dart';
import '../repositories/games_repository.dart';

class GetUserGames implements UseCase<List<Game>, GetUserGamesParams> {
  final GamesRepository repository;

  GetUserGames(this.repository);

  @override
  Future<Either<Failure, List<Game>>> call(GetUserGamesParams params) async {
    return await repository.getUserGames(params.steamId);
  }
}

class GetUserGamesParams {
  final String steamId;

  GetUserGamesParams({required this.steamId});
}
