// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'epic_game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpicGameModel _$EpicGameModelFromJson(Map<String, dynamic> json) =>
    EpicGameModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      keyImages: json['key_images'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      developer: json['developer'] as String?,
      publisher: json['publisher'] as String?,
      releaseDate: json['release_date'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      status: json['status'] as String?,
      owned: json['owned'] as bool?,
    );

Map<String, dynamic> _$EpicGameModelToJson(EpicGameModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'key_images': instance.keyImages,
      'categories': instance.categories,
      'developer': instance.developer,
      'publisher': instance.publisher,
      'release_date': instance.releaseDate,
      'price': instance.price,
      'status': instance.status,
      'owned': instance.owned,
    };

EpicUserModel _$EpicUserModelFromJson(Map<String, dynamic> json) =>
    EpicUserModel(
      id: json['id'] as String,
      displayName: json['display_name'] as String,
      email: json['email'] as String?,
      preferredLanguage: json['preferred_language'] as String?,
      country: json['country'] as String?,
      lastLogin: json['last_login'] == null
          ? null
          : DateTime.parse(json['last_login'] as String),
      emailVerified: json['email_verified'] as bool?,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$EpicUserModelToJson(EpicUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'display_name': instance.displayName,
      'email': instance.email,
      'preferred_language': instance.preferredLanguage,
      'country': instance.country,
      'last_login': instance.lastLogin?.toIso8601String(),
      'email_verified': instance.emailVerified,
      'avatar': instance.avatar,
    };

EpicTokenResponse _$EpicTokenResponseFromJson(Map<String, dynamic> json) =>
    EpicTokenResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
      tokenType: json['token_type'] as String,
      scope: json['scope'] as String,
    );

Map<String, dynamic> _$EpicTokenResponseToJson(EpicTokenResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'expires_in': instance.expiresIn,
      'token_type': instance.tokenType,
      'scope': instance.scope,
    };

EpicEntitlementModel _$EpicEntitlementModelFromJson(
  Map<String, dynamic> json,
) => EpicEntitlementModel(
  id: json['id'] as String,
  entitlementName: json['entitlement_name'] as String,
  namespace: json['namespace'] as String,
  catalogItemId: json['catalog_item_id'] as String,
  accountId: json['account_id'] as String,
  identityId: json['identity_id'] as String,
  entitlementType: json['entitlement_type'] as String,
  grantDate: json['grant_date'] as bool,
  consumable: json['consumable'] as bool,
  status: json['status'] as String,
);

Map<String, dynamic> _$EpicEntitlementModelToJson(
  EpicEntitlementModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'entitlement_name': instance.entitlementName,
  'namespace': instance.namespace,
  'catalog_item_id': instance.catalogItemId,
  'account_id': instance.accountId,
  'identity_id': instance.identityId,
  'entitlement_type': instance.entitlementType,
  'grant_date': instance.grantDate,
  'consumable': instance.consumable,
  'status': instance.status,
};
