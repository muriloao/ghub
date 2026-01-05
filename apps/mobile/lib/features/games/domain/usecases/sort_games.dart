import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/game.dart';

enum SortCriteria { name, lastPlayed, releaseDate, rating, playtime }

enum SortOrder { ascending, descending }

class SortGames implements UseCase<List<Game>, SortGamesParams> {
  @override
  Future<Either<Failure, List<Game>>> call(SortGamesParams params) async {
    try {
      final sortedGames = List<Game>.from(params.games);

      sortedGames.sort((a, b) {
        int comparison = 0;

        switch (params.criteria) {
          case SortCriteria.name:
            comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
            break;

          case SortCriteria.lastPlayed:
            final aLastPlayed = a.lastPlayed;
            final bLastPlayed = b.lastPlayed;

            if (aLastPlayed == null && bLastPlayed == null) {
              comparison = 0;
            } else if (aLastPlayed == null) {
              comparison = 1; // Jogos nunca jogados vão para o final
            } else if (bLastPlayed == null) {
              comparison = -1;
            } else {
              comparison = aLastPlayed.compareTo(bLastPlayed);
            }
            break;

          case SortCriteria.releaseDate:
            final aReleaseDate = a.releaseDate;
            final bReleaseDate = b.releaseDate;

            if (aReleaseDate == null && bReleaseDate == null) {
              comparison = 0;
            } else if (aReleaseDate == null) {
              comparison = 1; // Jogos sem data de lançamento vão para o final
            } else if (bReleaseDate == null) {
              comparison = -1;
            } else {
              // Assumindo que releaseDate está no formato "dd/mm/yyyy" ou similar
              // Para comparação adequada, seria ideal ter DateTime ao invés de String
              comparison = aReleaseDate.compareTo(bReleaseDate);
            }
            break;

          case SortCriteria.rating:
            final aRating = a.rating;
            final bRating = b.rating;

            if (aRating == null && bRating == null) {
              comparison = 0;
            } else if (aRating == null) {
              comparison = 1; // Jogos sem rating vão para o final
            } else if (bRating == null) {
              comparison = -1;
            } else {
              comparison = aRating.compareTo(bRating);
            }
            break;

          case SortCriteria.playtime:
            final aPlaytime = a.playtimeForever;
            final bPlaytime = b.playtimeForever;

            if (aPlaytime == null && bPlaytime == null) {
              comparison = 0;
            } else if (aPlaytime == null) {
              comparison = 1; // Jogos sem tempo de jogo vão para o final
            } else if (bPlaytime == null) {
              comparison = -1;
            } else {
              comparison = aPlaytime.compareTo(bPlaytime);
            }
            break;
        }

        // Inverte a comparação se for ordem decrescente
        return params.order == SortOrder.descending ? -comparison : comparison;
      });

      return Right(sortedGames);
    } catch (e) {
      return Left(ServerFailure('Erro ao ordenar jogos: ${e.toString()}'));
    }
  }
}

class SortGamesParams {
  final List<Game> games;
  final SortCriteria criteria;
  final SortOrder order;

  SortGamesParams({
    required this.games,
    required this.criteria,
    this.order = SortOrder.ascending,
  });
}
