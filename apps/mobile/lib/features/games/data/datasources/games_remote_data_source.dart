import '../models/steam_game_model.dart';
import '../models/steam_game_details_model.dart';

abstract class GamesRemoteDataSource {
  /// Busca todos os jogos do usuário do Steam
  Future<SteamOwnedGamesResponse> getSteamOwnedGames(String steamId);

  /// Busca detalhes específicos de um jogo
  Future<SteamGameDetailsResponse> getSteamGameDetails(String appId);

  /// Busca detalhes de múltiplos jogos
  Future<SteamGameDetailsResponse> getSteamGamesDetails(List<String> appIds);
}
