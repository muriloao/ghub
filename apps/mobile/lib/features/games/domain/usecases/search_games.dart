import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/game.dart';
import '../repositories/games_repository.dart';

class SearchGames implements UseCase<List<Game>, SearchGamesParams> {
  final GamesRepository repository;

  SearchGames(this.repository);

  @override
  Future<Either<Failure, List<Game>>> call(SearchGamesParams params) async {
    return await repository.searchGames(params.steamId, params.query);
  }
}

class SearchGamesParams {
  final String steamId;
  final String query;

  SearchGamesParams({required this.steamId, required this.query});
}
