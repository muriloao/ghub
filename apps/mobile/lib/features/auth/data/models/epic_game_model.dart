import 'package:ghub_mobile/features/games/domain/entities/game.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../onboarding/domain/entities/gaming_platform.dart';

part 'epic_game_model.g.dart';

@JsonSerializable()
class EpicGameModel {
  final String id;
  final String title;
  final String? description;
  final String? keyImages;
  final List<String>? categories;
  final String? developer;
  final String? publisher;
  final String? releaseDate;
  final double? price;
  final String? status; // ACTIVE, INACTIVE
  final bool? owned;

  const EpicGameModel({
    required this.id,
    required this.title,
    this.description,
    this.keyImages,
    this.categories,
    this.developer,
    this.publisher,
    this.releaseDate,
    this.price,
    this.status,
    this.owned,
  });

  factory EpicGameModel.fromJson(Map<String, dynamic> json) =>
      _$EpicGameModelFromJson(json);

  /// Cria modelo a partir de um entitlement Epic Games
  factory EpicGameModel.fromEntitlement(Map<String, dynamic> entitlement) {
    return EpicGameModel(
      id: entitlement['catalogItemId'] ?? entitlement['id'] ?? '',
      title:
          entitlement['entitlementName'] ??
          entitlement['displayName'] ??
          'Jogo Epic Games',
      description: null, // Entitlements não têm descrição
      keyImages: null,
      categories: null,
      developer: null,
      publisher: null,
      releaseDate: entitlement['grantDate']?.toString(),
      price: null,
      status: entitlement['status'] ?? 'ACTIVE',
      owned: true, // Se está nos entitlements, é owned
    );
  }

  /// Cria modelo a partir de um item do catálogo Epic Games
  factory EpicGameModel.fromCatalogItem(Map<String, dynamic> catalogItem) {
    final keyImages = catalogItem['keyImages'] as List<dynamic>?;
    String? imageUrl;

    if (keyImages != null && keyImages.isNotEmpty) {
      // Procura por uma imagem principal (DieselStoreFront ou featuredMedia)
      final mainImage = keyImages.firstWhere(
        (img) =>
            img['type'] == 'DieselStoreFront' || img['type'] == 'featuredMedia',
        orElse: () => keyImages.first,
      );
      imageUrl = mainImage['url'];
    }

    return EpicGameModel(
      id: catalogItem['id'] ?? '',
      title:
          catalogItem['title'] ??
          catalogItem['displayName'] ??
          'Jogo Epic Games',
      description: catalogItem['description'],
      keyImages: imageUrl,
      categories: (catalogItem['categories'] as List<dynamic>?)
          ?.map((cat) => cat['path']?.toString() ?? cat.toString())
          .toList(),
      developer: catalogItem['developer'],
      publisher: catalogItem['publisher'],
      releaseDate: catalogItem['releaseDate'],
      price: catalogItem['price']?['totalPrice']?.toDouble(),
      status: catalogItem['status'] ?? 'ACTIVE',
      owned: true, // Se está sendo buscado, assumimos que é owned
    );
  }

  Map<String, dynamic> toJson() => _$EpicGameModelToJson(this);

  Game toDomainEntity() {
    return Game(
      id: id,
      name: title,
      imageUrl: _extractImageUrl(keyImages),
      headerImageUrl: _extractImageUrl(keyImages),
      status: owned == true ? GameStatus.owned : GameStatus.wishlist,
      platforms: [GamePlatform.pc], // Epic Games é principalmente PC
      playtimeForever: null, // Epic não fornece tempo de jogo por padrão
      playtime2Weeks: null,
      lastPlayed: null,
      hasDLC: false,
      isCompleted: false,
      completionPercentage: null,
      subscriptionService: null,
      isPhysicalCopy: false,
      releaseDate: releaseDate,
      genres: categories,
      developer: developer,
      publisher: publisher,
      rating: null, // Epic não fornece rating diretamente
      description: description,
      sourcePlatform: PlatformType.epicGames,
    );
  }

  String? _extractImageUrl(String? keyImages) {
    if (keyImages == null) return null;
    // Epic Games usa um formato específico para imagens
    // Por simplicidade, retornamos a string diretamente
    // Em implementação real, seria necessário parsear o JSON das imagens
    return keyImages;
  }
}

@JsonSerializable()
class EpicUserModel {
  final String id;
  final String displayName;
  final String? email;
  final String? preferredLanguage;
  final String? country;
  final DateTime? lastLogin;
  final bool? emailVerified;
  final String? avatar;

  const EpicUserModel({
    required this.id,
    required this.displayName,
    this.email,
    this.preferredLanguage,
    this.country,
    this.lastLogin,
    this.emailVerified,
    this.avatar,
  });

  factory EpicUserModel.fromJson(Map<String, dynamic> json) =>
      _$EpicUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$EpicUserModelToJson(this);
}

@JsonSerializable()
class EpicTokenResponse {
  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  @JsonKey(name: 'expires_in')
  final int expiresIn;

  @JsonKey(name: 'token_type')
  final String tokenType;

  final String scope;

  const EpicTokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
    required this.scope,
  });

  factory EpicTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$EpicTokenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EpicTokenResponseToJson(this);
}

@JsonSerializable()
class EpicEntitlementModel {
  final String id;
  final String entitlementName;
  final String namespace;
  final String catalogItemId;
  final String accountId;
  final String identityId;
  final String entitlementType;
  final bool grantDate;
  final bool consumable;
  final String status;

  const EpicEntitlementModel({
    required this.id,
    required this.entitlementName,
    required this.namespace,
    required this.catalogItemId,
    required this.accountId,
    required this.identityId,
    required this.entitlementType,
    required this.grantDate,
    required this.consumable,
    required this.status,
  });

  factory EpicEntitlementModel.fromJson(Map<String, dynamic> json) =>
      _$EpicEntitlementModelFromJson(json);

  Map<String, dynamic> toJson() => _$EpicEntitlementModelToJson(this);
}
