// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'platform_api_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlatformColorScheme _$PlatformColorSchemeFromJson(Map<String, dynamic> json) {
  return _PlatformColorScheme.fromJson(json);
}

/// @nodoc
mixin _$PlatformColorScheme {
  String get primary => throw _privateConstructorUsedError;
  String get secondary => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String primary, String secondary) $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String primary, String secondary)? $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String primary, String secondary)? $default, {
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PlatformColorScheme value) $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PlatformColorScheme value)? $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PlatformColorScheme value)? $default, {
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this PlatformColorScheme to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlatformColorScheme
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlatformColorSchemeCopyWith<PlatformColorScheme> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlatformColorSchemeCopyWith<$Res> {
  factory $PlatformColorSchemeCopyWith(
    PlatformColorScheme value,
    $Res Function(PlatformColorScheme) then,
  ) = _$PlatformColorSchemeCopyWithImpl<$Res, PlatformColorScheme>;
  @useResult
  $Res call({String primary, String secondary});
}

/// @nodoc
class _$PlatformColorSchemeCopyWithImpl<$Res, $Val extends PlatformColorScheme>
    implements $PlatformColorSchemeCopyWith<$Res> {
  _$PlatformColorSchemeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlatformColorScheme
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? primary = null, Object? secondary = null}) {
    return _then(
      _value.copyWith(
            primary: null == primary
                ? _value.primary
                : primary // ignore: cast_nullable_to_non_nullable
                      as String,
            secondary: null == secondary
                ? _value.secondary
                : secondary // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlatformColorSchemeImplCopyWith<$Res>
    implements $PlatformColorSchemeCopyWith<$Res> {
  factory _$$PlatformColorSchemeImplCopyWith(
    _$PlatformColorSchemeImpl value,
    $Res Function(_$PlatformColorSchemeImpl) then,
  ) = __$$PlatformColorSchemeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String primary, String secondary});
}

/// @nodoc
class __$$PlatformColorSchemeImplCopyWithImpl<$Res>
    extends _$PlatformColorSchemeCopyWithImpl<$Res, _$PlatformColorSchemeImpl>
    implements _$$PlatformColorSchemeImplCopyWith<$Res> {
  __$$PlatformColorSchemeImplCopyWithImpl(
    _$PlatformColorSchemeImpl _value,
    $Res Function(_$PlatformColorSchemeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlatformColorScheme
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? primary = null, Object? secondary = null}) {
    return _then(
      _$PlatformColorSchemeImpl(
        primary: null == primary
            ? _value.primary
            : primary // ignore: cast_nullable_to_non_nullable
                  as String,
        secondary: null == secondary
            ? _value.secondary
            : secondary // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlatformColorSchemeImpl implements _PlatformColorScheme {
  const _$PlatformColorSchemeImpl({
    required this.primary,
    required this.secondary,
  });

  factory _$PlatformColorSchemeImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlatformColorSchemeImplFromJson(json);

  @override
  final String primary;
  @override
  final String secondary;

  @override
  String toString() {
    return 'PlatformColorScheme(primary: $primary, secondary: $secondary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlatformColorSchemeImpl &&
            (identical(other.primary, primary) || other.primary == primary) &&
            (identical(other.secondary, secondary) ||
                other.secondary == secondary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, primary, secondary);

  /// Create a copy of PlatformColorScheme
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlatformColorSchemeImplCopyWith<_$PlatformColorSchemeImpl> get copyWith =>
      __$$PlatformColorSchemeImplCopyWithImpl<_$PlatformColorSchemeImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String primary, String secondary) $default,
  ) {
    return $default(primary, secondary);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String primary, String secondary)? $default,
  ) {
    return $default?.call(primary, secondary);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String primary, String secondary)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(primary, secondary);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PlatformColorScheme value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PlatformColorScheme value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PlatformColorScheme value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PlatformColorSchemeImplToJson(this);
  }
}

abstract class _PlatformColorScheme implements PlatformColorScheme {
  const factory _PlatformColorScheme({
    required final String primary,
    required final String secondary,
  }) = _$PlatformColorSchemeImpl;

  factory _PlatformColorScheme.fromJson(Map<String, dynamic> json) =
      _$PlatformColorSchemeImpl.fromJson;

  @override
  String get primary;
  @override
  String get secondary;

  /// Create a copy of PlatformColorScheme
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlatformColorSchemeImplCopyWith<_$PlatformColorSchemeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlatformEndpoints _$PlatformEndpointsFromJson(Map<String, dynamic> json) {
  return _PlatformEndpoints.fromJson(json);
}

/// @nodoc
mixin _$PlatformEndpoints {
  String get baseUrl => throw _privateConstructorUsedError;
  String get auth => throw _privateConstructorUsedError;
  String get userProfile => throw _privateConstructorUsedError;
  String get gameLibrary => throw _privateConstructorUsedError;
  String get achievements => throw _privateConstructorUsedError;
  String? get friendsList => throw _privateConstructorUsedError;
  String? get gameStats => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      String baseUrl,
      String auth,
      String userProfile,
      String gameLibrary,
      String achievements,
      String? friendsList,
      String? gameStats,
    )
    $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      String baseUrl,
      String auth,
      String userProfile,
      String gameLibrary,
      String achievements,
      String? friendsList,
      String? gameStats,
    )?
    $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      String baseUrl,
      String auth,
      String userProfile,
      String gameLibrary,
      String achievements,
      String? friendsList,
      String? gameStats,
    )?
    $default, {
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PlatformEndpoints value) $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PlatformEndpoints value)? $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PlatformEndpoints value)? $default, {
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this PlatformEndpoints to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlatformEndpoints
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlatformEndpointsCopyWith<PlatformEndpoints> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlatformEndpointsCopyWith<$Res> {
  factory $PlatformEndpointsCopyWith(
    PlatformEndpoints value,
    $Res Function(PlatformEndpoints) then,
  ) = _$PlatformEndpointsCopyWithImpl<$Res, PlatformEndpoints>;
  @useResult
  $Res call({
    String baseUrl,
    String auth,
    String userProfile,
    String gameLibrary,
    String achievements,
    String? friendsList,
    String? gameStats,
  });
}

/// @nodoc
class _$PlatformEndpointsCopyWithImpl<$Res, $Val extends PlatformEndpoints>
    implements $PlatformEndpointsCopyWith<$Res> {
  _$PlatformEndpointsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlatformEndpoints
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseUrl = null,
    Object? auth = null,
    Object? userProfile = null,
    Object? gameLibrary = null,
    Object? achievements = null,
    Object? friendsList = freezed,
    Object? gameStats = freezed,
  }) {
    return _then(
      _value.copyWith(
            baseUrl: null == baseUrl
                ? _value.baseUrl
                : baseUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            auth: null == auth
                ? _value.auth
                : auth // ignore: cast_nullable_to_non_nullable
                      as String,
            userProfile: null == userProfile
                ? _value.userProfile
                : userProfile // ignore: cast_nullable_to_non_nullable
                      as String,
            gameLibrary: null == gameLibrary
                ? _value.gameLibrary
                : gameLibrary // ignore: cast_nullable_to_non_nullable
                      as String,
            achievements: null == achievements
                ? _value.achievements
                : achievements // ignore: cast_nullable_to_non_nullable
                      as String,
            friendsList: freezed == friendsList
                ? _value.friendsList
                : friendsList // ignore: cast_nullable_to_non_nullable
                      as String?,
            gameStats: freezed == gameStats
                ? _value.gameStats
                : gameStats // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlatformEndpointsImplCopyWith<$Res>
    implements $PlatformEndpointsCopyWith<$Res> {
  factory _$$PlatformEndpointsImplCopyWith(
    _$PlatformEndpointsImpl value,
    $Res Function(_$PlatformEndpointsImpl) then,
  ) = __$$PlatformEndpointsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String baseUrl,
    String auth,
    String userProfile,
    String gameLibrary,
    String achievements,
    String? friendsList,
    String? gameStats,
  });
}

/// @nodoc
class __$$PlatformEndpointsImplCopyWithImpl<$Res>
    extends _$PlatformEndpointsCopyWithImpl<$Res, _$PlatformEndpointsImpl>
    implements _$$PlatformEndpointsImplCopyWith<$Res> {
  __$$PlatformEndpointsImplCopyWithImpl(
    _$PlatformEndpointsImpl _value,
    $Res Function(_$PlatformEndpointsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlatformEndpoints
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseUrl = null,
    Object? auth = null,
    Object? userProfile = null,
    Object? gameLibrary = null,
    Object? achievements = null,
    Object? friendsList = freezed,
    Object? gameStats = freezed,
  }) {
    return _then(
      _$PlatformEndpointsImpl(
        baseUrl: null == baseUrl
            ? _value.baseUrl
            : baseUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        auth: null == auth
            ? _value.auth
            : auth // ignore: cast_nullable_to_non_nullable
                  as String,
        userProfile: null == userProfile
            ? _value.userProfile
            : userProfile // ignore: cast_nullable_to_non_nullable
                  as String,
        gameLibrary: null == gameLibrary
            ? _value.gameLibrary
            : gameLibrary // ignore: cast_nullable_to_non_nullable
                  as String,
        achievements: null == achievements
            ? _value.achievements
            : achievements // ignore: cast_nullable_to_non_nullable
                  as String,
        friendsList: freezed == friendsList
            ? _value.friendsList
            : friendsList // ignore: cast_nullable_to_non_nullable
                  as String?,
        gameStats: freezed == gameStats
            ? _value.gameStats
            : gameStats // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlatformEndpointsImpl implements _PlatformEndpoints {
  const _$PlatformEndpointsImpl({
    required this.baseUrl,
    required this.auth,
    required this.userProfile,
    required this.gameLibrary,
    required this.achievements,
    this.friendsList,
    this.gameStats,
  });

  factory _$PlatformEndpointsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlatformEndpointsImplFromJson(json);

  @override
  final String baseUrl;
  @override
  final String auth;
  @override
  final String userProfile;
  @override
  final String gameLibrary;
  @override
  final String achievements;
  @override
  final String? friendsList;
  @override
  final String? gameStats;

  @override
  String toString() {
    return 'PlatformEndpoints(baseUrl: $baseUrl, auth: $auth, userProfile: $userProfile, gameLibrary: $gameLibrary, achievements: $achievements, friendsList: $friendsList, gameStats: $gameStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlatformEndpointsImpl &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.auth, auth) || other.auth == auth) &&
            (identical(other.userProfile, userProfile) ||
                other.userProfile == userProfile) &&
            (identical(other.gameLibrary, gameLibrary) ||
                other.gameLibrary == gameLibrary) &&
            (identical(other.achievements, achievements) ||
                other.achievements == achievements) &&
            (identical(other.friendsList, friendsList) ||
                other.friendsList == friendsList) &&
            (identical(other.gameStats, gameStats) ||
                other.gameStats == gameStats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    baseUrl,
    auth,
    userProfile,
    gameLibrary,
    achievements,
    friendsList,
    gameStats,
  );

  /// Create a copy of PlatformEndpoints
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlatformEndpointsImplCopyWith<_$PlatformEndpointsImpl> get copyWith =>
      __$$PlatformEndpointsImplCopyWithImpl<_$PlatformEndpointsImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      String baseUrl,
      String auth,
      String userProfile,
      String gameLibrary,
      String achievements,
      String? friendsList,
      String? gameStats,
    )
    $default,
  ) {
    return $default(
      baseUrl,
      auth,
      userProfile,
      gameLibrary,
      achievements,
      friendsList,
      gameStats,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      String baseUrl,
      String auth,
      String userProfile,
      String gameLibrary,
      String achievements,
      String? friendsList,
      String? gameStats,
    )?
    $default,
  ) {
    return $default?.call(
      baseUrl,
      auth,
      userProfile,
      gameLibrary,
      achievements,
      friendsList,
      gameStats,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      String baseUrl,
      String auth,
      String userProfile,
      String gameLibrary,
      String achievements,
      String? friendsList,
      String? gameStats,
    )?
    $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
        baseUrl,
        auth,
        userProfile,
        gameLibrary,
        achievements,
        friendsList,
        gameStats,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PlatformEndpoints value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PlatformEndpoints value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PlatformEndpoints value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PlatformEndpointsImplToJson(this);
  }
}

abstract class _PlatformEndpoints implements PlatformEndpoints {
  const factory _PlatformEndpoints({
    required final String baseUrl,
    required final String auth,
    required final String userProfile,
    required final String gameLibrary,
    required final String achievements,
    final String? friendsList,
    final String? gameStats,
  }) = _$PlatformEndpointsImpl;

  factory _PlatformEndpoints.fromJson(Map<String, dynamic> json) =
      _$PlatformEndpointsImpl.fromJson;

  @override
  String get baseUrl;
  @override
  String get auth;
  @override
  String get userProfile;
  @override
  String get gameLibrary;
  @override
  String get achievements;
  @override
  String? get friendsList;
  @override
  String? get gameStats;

  /// Create a copy of PlatformEndpoints
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlatformEndpointsImplCopyWith<_$PlatformEndpointsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlatformAuthConfig _$PlatformAuthConfigFromJson(Map<String, dynamic> json) {
  return _PlatformAuthConfig.fromJson(json);
}

/// @nodoc
mixin _$PlatformAuthConfig {
  String get type => throw _privateConstructorUsedError;
  bool get clientIdRequired => throw _privateConstructorUsedError;
  bool get secretRequired => throw _privateConstructorUsedError;
  String get redirectUri => throw _privateConstructorUsedError;
  List<String> get scopes => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      String type,
      bool clientIdRequired,
      bool secretRequired,
      String redirectUri,
      List<String> scopes,
    )
    $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      String type,
      bool clientIdRequired,
      bool secretRequired,
      String redirectUri,
      List<String> scopes,
    )?
    $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      String type,
      bool clientIdRequired,
      bool secretRequired,
      String redirectUri,
      List<String> scopes,
    )?
    $default, {
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PlatformAuthConfig value) $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PlatformAuthConfig value)? $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PlatformAuthConfig value)? $default, {
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this PlatformAuthConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlatformAuthConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlatformAuthConfigCopyWith<PlatformAuthConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlatformAuthConfigCopyWith<$Res> {
  factory $PlatformAuthConfigCopyWith(
    PlatformAuthConfig value,
    $Res Function(PlatformAuthConfig) then,
  ) = _$PlatformAuthConfigCopyWithImpl<$Res, PlatformAuthConfig>;
  @useResult
  $Res call({
    String type,
    bool clientIdRequired,
    bool secretRequired,
    String redirectUri,
    List<String> scopes,
  });
}

/// @nodoc
class _$PlatformAuthConfigCopyWithImpl<$Res, $Val extends PlatformAuthConfig>
    implements $PlatformAuthConfigCopyWith<$Res> {
  _$PlatformAuthConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlatformAuthConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? clientIdRequired = null,
    Object? secretRequired = null,
    Object? redirectUri = null,
    Object? scopes = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            clientIdRequired: null == clientIdRequired
                ? _value.clientIdRequired
                : clientIdRequired // ignore: cast_nullable_to_non_nullable
                      as bool,
            secretRequired: null == secretRequired
                ? _value.secretRequired
                : secretRequired // ignore: cast_nullable_to_non_nullable
                      as bool,
            redirectUri: null == redirectUri
                ? _value.redirectUri
                : redirectUri // ignore: cast_nullable_to_non_nullable
                      as String,
            scopes: null == scopes
                ? _value.scopes
                : scopes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlatformAuthConfigImplCopyWith<$Res>
    implements $PlatformAuthConfigCopyWith<$Res> {
  factory _$$PlatformAuthConfigImplCopyWith(
    _$PlatformAuthConfigImpl value,
    $Res Function(_$PlatformAuthConfigImpl) then,
  ) = __$$PlatformAuthConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String type,
    bool clientIdRequired,
    bool secretRequired,
    String redirectUri,
    List<String> scopes,
  });
}

/// @nodoc
class __$$PlatformAuthConfigImplCopyWithImpl<$Res>
    extends _$PlatformAuthConfigCopyWithImpl<$Res, _$PlatformAuthConfigImpl>
    implements _$$PlatformAuthConfigImplCopyWith<$Res> {
  __$$PlatformAuthConfigImplCopyWithImpl(
    _$PlatformAuthConfigImpl _value,
    $Res Function(_$PlatformAuthConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlatformAuthConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? clientIdRequired = null,
    Object? secretRequired = null,
    Object? redirectUri = null,
    Object? scopes = null,
  }) {
    return _then(
      _$PlatformAuthConfigImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        clientIdRequired: null == clientIdRequired
            ? _value.clientIdRequired
            : clientIdRequired // ignore: cast_nullable_to_non_nullable
                  as bool,
        secretRequired: null == secretRequired
            ? _value.secretRequired
            : secretRequired // ignore: cast_nullable_to_non_nullable
                  as bool,
        redirectUri: null == redirectUri
            ? _value.redirectUri
            : redirectUri // ignore: cast_nullable_to_non_nullable
                  as String,
        scopes: null == scopes
            ? _value._scopes
            : scopes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlatformAuthConfigImpl implements _PlatformAuthConfig {
  const _$PlatformAuthConfigImpl({
    required this.type,
    required this.clientIdRequired,
    required this.secretRequired,
    required this.redirectUri,
    required final List<String> scopes,
  }) : _scopes = scopes;

  factory _$PlatformAuthConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlatformAuthConfigImplFromJson(json);

  @override
  final String type;
  @override
  final bool clientIdRequired;
  @override
  final bool secretRequired;
  @override
  final String redirectUri;
  final List<String> _scopes;
  @override
  List<String> get scopes {
    if (_scopes is EqualUnmodifiableListView) return _scopes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scopes);
  }

  @override
  String toString() {
    return 'PlatformAuthConfig(type: $type, clientIdRequired: $clientIdRequired, secretRequired: $secretRequired, redirectUri: $redirectUri, scopes: $scopes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlatformAuthConfigImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.clientIdRequired, clientIdRequired) ||
                other.clientIdRequired == clientIdRequired) &&
            (identical(other.secretRequired, secretRequired) ||
                other.secretRequired == secretRequired) &&
            (identical(other.redirectUri, redirectUri) ||
                other.redirectUri == redirectUri) &&
            const DeepCollectionEquality().equals(other._scopes, _scopes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    clientIdRequired,
    secretRequired,
    redirectUri,
    const DeepCollectionEquality().hash(_scopes),
  );

  /// Create a copy of PlatformAuthConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlatformAuthConfigImplCopyWith<_$PlatformAuthConfigImpl> get copyWith =>
      __$$PlatformAuthConfigImplCopyWithImpl<_$PlatformAuthConfigImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      String type,
      bool clientIdRequired,
      bool secretRequired,
      String redirectUri,
      List<String> scopes,
    )
    $default,
  ) {
    return $default(
      type,
      clientIdRequired,
      secretRequired,
      redirectUri,
      scopes,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      String type,
      bool clientIdRequired,
      bool secretRequired,
      String redirectUri,
      List<String> scopes,
    )?
    $default,
  ) {
    return $default?.call(
      type,
      clientIdRequired,
      secretRequired,
      redirectUri,
      scopes,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      String type,
      bool clientIdRequired,
      bool secretRequired,
      String redirectUri,
      List<String> scopes,
    )?
    $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
        type,
        clientIdRequired,
        secretRequired,
        redirectUri,
        scopes,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PlatformAuthConfig value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PlatformAuthConfig value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PlatformAuthConfig value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PlatformAuthConfigImplToJson(this);
  }
}

abstract class _PlatformAuthConfig implements PlatformAuthConfig {
  const factory _PlatformAuthConfig({
    required final String type,
    required final bool clientIdRequired,
    required final bool secretRequired,
    required final String redirectUri,
    required final List<String> scopes,
  }) = _$PlatformAuthConfigImpl;

  factory _PlatformAuthConfig.fromJson(Map<String, dynamic> json) =
      _$PlatformAuthConfigImpl.fromJson;

  @override
  String get type;
  @override
  bool get clientIdRequired;
  @override
  bool get secretRequired;
  @override
  String get redirectUri;
  @override
  List<String> get scopes;

  /// Create a copy of PlatformAuthConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlatformAuthConfigImplCopyWith<_$PlatformAuthConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlatformFeatures _$PlatformFeaturesFromJson(Map<String, dynamic> json) {
  return _PlatformFeatures.fromJson(json);
}

/// @nodoc
mixin _$PlatformFeatures {
  bool get gameLibrary => throw _privateConstructorUsedError;
  bool get achievements => throw _privateConstructorUsedError;
  bool get friendsList => throw _privateConstructorUsedError;
  bool get gameStats => throw _privateConstructorUsedError;
  bool get screenshots => throw _privateConstructorUsedError;
  bool get gameTime => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      bool gameLibrary,
      bool achievements,
      bool friendsList,
      bool gameStats,
      bool screenshots,
      bool gameTime,
    )
    $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      bool gameLibrary,
      bool achievements,
      bool friendsList,
      bool gameStats,
      bool screenshots,
      bool gameTime,
    )?
    $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      bool gameLibrary,
      bool achievements,
      bool friendsList,
      bool gameStats,
      bool screenshots,
      bool gameTime,
    )?
    $default, {
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PlatformFeatures value) $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PlatformFeatures value)? $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PlatformFeatures value)? $default, {
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this PlatformFeatures to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlatformFeatures
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlatformFeaturesCopyWith<PlatformFeatures> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlatformFeaturesCopyWith<$Res> {
  factory $PlatformFeaturesCopyWith(
    PlatformFeatures value,
    $Res Function(PlatformFeatures) then,
  ) = _$PlatformFeaturesCopyWithImpl<$Res, PlatformFeatures>;
  @useResult
  $Res call({
    bool gameLibrary,
    bool achievements,
    bool friendsList,
    bool gameStats,
    bool screenshots,
    bool gameTime,
  });
}

/// @nodoc
class _$PlatformFeaturesCopyWithImpl<$Res, $Val extends PlatformFeatures>
    implements $PlatformFeaturesCopyWith<$Res> {
  _$PlatformFeaturesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlatformFeatures
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameLibrary = null,
    Object? achievements = null,
    Object? friendsList = null,
    Object? gameStats = null,
    Object? screenshots = null,
    Object? gameTime = null,
  }) {
    return _then(
      _value.copyWith(
            gameLibrary: null == gameLibrary
                ? _value.gameLibrary
                : gameLibrary // ignore: cast_nullable_to_non_nullable
                      as bool,
            achievements: null == achievements
                ? _value.achievements
                : achievements // ignore: cast_nullable_to_non_nullable
                      as bool,
            friendsList: null == friendsList
                ? _value.friendsList
                : friendsList // ignore: cast_nullable_to_non_nullable
                      as bool,
            gameStats: null == gameStats
                ? _value.gameStats
                : gameStats // ignore: cast_nullable_to_non_nullable
                      as bool,
            screenshots: null == screenshots
                ? _value.screenshots
                : screenshots // ignore: cast_nullable_to_non_nullable
                      as bool,
            gameTime: null == gameTime
                ? _value.gameTime
                : gameTime // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlatformFeaturesImplCopyWith<$Res>
    implements $PlatformFeaturesCopyWith<$Res> {
  factory _$$PlatformFeaturesImplCopyWith(
    _$PlatformFeaturesImpl value,
    $Res Function(_$PlatformFeaturesImpl) then,
  ) = __$$PlatformFeaturesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool gameLibrary,
    bool achievements,
    bool friendsList,
    bool gameStats,
    bool screenshots,
    bool gameTime,
  });
}

/// @nodoc
class __$$PlatformFeaturesImplCopyWithImpl<$Res>
    extends _$PlatformFeaturesCopyWithImpl<$Res, _$PlatformFeaturesImpl>
    implements _$$PlatformFeaturesImplCopyWith<$Res> {
  __$$PlatformFeaturesImplCopyWithImpl(
    _$PlatformFeaturesImpl _value,
    $Res Function(_$PlatformFeaturesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlatformFeatures
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameLibrary = null,
    Object? achievements = null,
    Object? friendsList = null,
    Object? gameStats = null,
    Object? screenshots = null,
    Object? gameTime = null,
  }) {
    return _then(
      _$PlatformFeaturesImpl(
        gameLibrary: null == gameLibrary
            ? _value.gameLibrary
            : gameLibrary // ignore: cast_nullable_to_non_nullable
                  as bool,
        achievements: null == achievements
            ? _value.achievements
            : achievements // ignore: cast_nullable_to_non_nullable
                  as bool,
        friendsList: null == friendsList
            ? _value.friendsList
            : friendsList // ignore: cast_nullable_to_non_nullable
                  as bool,
        gameStats: null == gameStats
            ? _value.gameStats
            : gameStats // ignore: cast_nullable_to_non_nullable
                  as bool,
        screenshots: null == screenshots
            ? _value.screenshots
            : screenshots // ignore: cast_nullable_to_non_nullable
                  as bool,
        gameTime: null == gameTime
            ? _value.gameTime
            : gameTime // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlatformFeaturesImpl implements _PlatformFeatures {
  const _$PlatformFeaturesImpl({
    required this.gameLibrary,
    required this.achievements,
    required this.friendsList,
    required this.gameStats,
    required this.screenshots,
    required this.gameTime,
  });

  factory _$PlatformFeaturesImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlatformFeaturesImplFromJson(json);

  @override
  final bool gameLibrary;
  @override
  final bool achievements;
  @override
  final bool friendsList;
  @override
  final bool gameStats;
  @override
  final bool screenshots;
  @override
  final bool gameTime;

  @override
  String toString() {
    return 'PlatformFeatures(gameLibrary: $gameLibrary, achievements: $achievements, friendsList: $friendsList, gameStats: $gameStats, screenshots: $screenshots, gameTime: $gameTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlatformFeaturesImpl &&
            (identical(other.gameLibrary, gameLibrary) ||
                other.gameLibrary == gameLibrary) &&
            (identical(other.achievements, achievements) ||
                other.achievements == achievements) &&
            (identical(other.friendsList, friendsList) ||
                other.friendsList == friendsList) &&
            (identical(other.gameStats, gameStats) ||
                other.gameStats == gameStats) &&
            (identical(other.screenshots, screenshots) ||
                other.screenshots == screenshots) &&
            (identical(other.gameTime, gameTime) ||
                other.gameTime == gameTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    gameLibrary,
    achievements,
    friendsList,
    gameStats,
    screenshots,
    gameTime,
  );

  /// Create a copy of PlatformFeatures
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlatformFeaturesImplCopyWith<_$PlatformFeaturesImpl> get copyWith =>
      __$$PlatformFeaturesImplCopyWithImpl<_$PlatformFeaturesImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      bool gameLibrary,
      bool achievements,
      bool friendsList,
      bool gameStats,
      bool screenshots,
      bool gameTime,
    )
    $default,
  ) {
    return $default(
      gameLibrary,
      achievements,
      friendsList,
      gameStats,
      screenshots,
      gameTime,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      bool gameLibrary,
      bool achievements,
      bool friendsList,
      bool gameStats,
      bool screenshots,
      bool gameTime,
    )?
    $default,
  ) {
    return $default?.call(
      gameLibrary,
      achievements,
      friendsList,
      gameStats,
      screenshots,
      gameTime,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      bool gameLibrary,
      bool achievements,
      bool friendsList,
      bool gameStats,
      bool screenshots,
      bool gameTime,
    )?
    $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
        gameLibrary,
        achievements,
        friendsList,
        gameStats,
        screenshots,
        gameTime,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PlatformFeatures value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PlatformFeatures value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PlatformFeatures value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PlatformFeaturesImplToJson(this);
  }
}

abstract class _PlatformFeatures implements PlatformFeatures {
  const factory _PlatformFeatures({
    required final bool gameLibrary,
    required final bool achievements,
    required final bool friendsList,
    required final bool gameStats,
    required final bool screenshots,
    required final bool gameTime,
  }) = _$PlatformFeaturesImpl;

  factory _PlatformFeatures.fromJson(Map<String, dynamic> json) =
      _$PlatformFeaturesImpl.fromJson;

  @override
  bool get gameLibrary;
  @override
  bool get achievements;
  @override
  bool get friendsList;
  @override
  bool get gameStats;
  @override
  bool get screenshots;
  @override
  bool get gameTime;

  /// Create a copy of PlatformFeatures
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlatformFeaturesImplCopyWith<_$PlatformFeaturesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlatformApiModel _$PlatformApiModelFromJson(Map<String, dynamic> json) {
  return _PlatformApiModel.fromJson(json);
}

/// @nodoc
mixin _$PlatformApiModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get logoUrl => throw _privateConstructorUsedError;
  PlatformColorScheme get colorScheme => throw _privateConstructorUsedError;
  PlatformEndpoints get endpoints => throw _privateConstructorUsedError;
  PlatformAuthConfig get authConfig => throw _privateConstructorUsedError;
  PlatformFeatures get features => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  bool get comingSoon => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      String id,
      String name,
      String displayName,
      String description,
      String logoUrl,
      PlatformColorScheme colorScheme,
      PlatformEndpoints endpoints,
      PlatformAuthConfig authConfig,
      PlatformFeatures features,
      bool isEnabled,
      bool comingSoon,
      int priority,
    )
    $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      String id,
      String name,
      String displayName,
      String description,
      String logoUrl,
      PlatformColorScheme colorScheme,
      PlatformEndpoints endpoints,
      PlatformAuthConfig authConfig,
      PlatformFeatures features,
      bool isEnabled,
      bool comingSoon,
      int priority,
    )?
    $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      String id,
      String name,
      String displayName,
      String description,
      String logoUrl,
      PlatformColorScheme colorScheme,
      PlatformEndpoints endpoints,
      PlatformAuthConfig authConfig,
      PlatformFeatures features,
      bool isEnabled,
      bool comingSoon,
      int priority,
    )?
    $default, {
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PlatformApiModel value) $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PlatformApiModel value)? $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PlatformApiModel value)? $default, {
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this PlatformApiModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlatformApiModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlatformApiModelCopyWith<PlatformApiModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlatformApiModelCopyWith<$Res> {
  factory $PlatformApiModelCopyWith(
    PlatformApiModel value,
    $Res Function(PlatformApiModel) then,
  ) = _$PlatformApiModelCopyWithImpl<$Res, PlatformApiModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String displayName,
    String description,
    String logoUrl,
    PlatformColorScheme colorScheme,
    PlatformEndpoints endpoints,
    PlatformAuthConfig authConfig,
    PlatformFeatures features,
    bool isEnabled,
    bool comingSoon,
    int priority,
  });

  $PlatformColorSchemeCopyWith<$Res> get colorScheme;
  $PlatformEndpointsCopyWith<$Res> get endpoints;
  $PlatformAuthConfigCopyWith<$Res> get authConfig;
  $PlatformFeaturesCopyWith<$Res> get features;
}

/// @nodoc
class _$PlatformApiModelCopyWithImpl<$Res, $Val extends PlatformApiModel>
    implements $PlatformApiModelCopyWith<$Res> {
  _$PlatformApiModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlatformApiModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? displayName = null,
    Object? description = null,
    Object? logoUrl = null,
    Object? colorScheme = null,
    Object? endpoints = null,
    Object? authConfig = null,
    Object? features = null,
    Object? isEnabled = null,
    Object? comingSoon = null,
    Object? priority = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            logoUrl: null == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            colorScheme: null == colorScheme
                ? _value.colorScheme
                : colorScheme // ignore: cast_nullable_to_non_nullable
                      as PlatformColorScheme,
            endpoints: null == endpoints
                ? _value.endpoints
                : endpoints // ignore: cast_nullable_to_non_nullable
                      as PlatformEndpoints,
            authConfig: null == authConfig
                ? _value.authConfig
                : authConfig // ignore: cast_nullable_to_non_nullable
                      as PlatformAuthConfig,
            features: null == features
                ? _value.features
                : features // ignore: cast_nullable_to_non_nullable
                      as PlatformFeatures,
            isEnabled: null == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            comingSoon: null == comingSoon
                ? _value.comingSoon
                : comingSoon // ignore: cast_nullable_to_non_nullable
                      as bool,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of PlatformApiModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlatformColorSchemeCopyWith<$Res> get colorScheme {
    return $PlatformColorSchemeCopyWith<$Res>(_value.colorScheme, (value) {
      return _then(_value.copyWith(colorScheme: value) as $Val);
    });
  }

  /// Create a copy of PlatformApiModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlatformEndpointsCopyWith<$Res> get endpoints {
    return $PlatformEndpointsCopyWith<$Res>(_value.endpoints, (value) {
      return _then(_value.copyWith(endpoints: value) as $Val);
    });
  }

  /// Create a copy of PlatformApiModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlatformAuthConfigCopyWith<$Res> get authConfig {
    return $PlatformAuthConfigCopyWith<$Res>(_value.authConfig, (value) {
      return _then(_value.copyWith(authConfig: value) as $Val);
    });
  }

  /// Create a copy of PlatformApiModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlatformFeaturesCopyWith<$Res> get features {
    return $PlatformFeaturesCopyWith<$Res>(_value.features, (value) {
      return _then(_value.copyWith(features: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlatformApiModelImplCopyWith<$Res>
    implements $PlatformApiModelCopyWith<$Res> {
  factory _$$PlatformApiModelImplCopyWith(
    _$PlatformApiModelImpl value,
    $Res Function(_$PlatformApiModelImpl) then,
  ) = __$$PlatformApiModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String displayName,
    String description,
    String logoUrl,
    PlatformColorScheme colorScheme,
    PlatformEndpoints endpoints,
    PlatformAuthConfig authConfig,
    PlatformFeatures features,
    bool isEnabled,
    bool comingSoon,
    int priority,
  });

  @override
  $PlatformColorSchemeCopyWith<$Res> get colorScheme;
  @override
  $PlatformEndpointsCopyWith<$Res> get endpoints;
  @override
  $PlatformAuthConfigCopyWith<$Res> get authConfig;
  @override
  $PlatformFeaturesCopyWith<$Res> get features;
}

/// @nodoc
class __$$PlatformApiModelImplCopyWithImpl<$Res>
    extends _$PlatformApiModelCopyWithImpl<$Res, _$PlatformApiModelImpl>
    implements _$$PlatformApiModelImplCopyWith<$Res> {
  __$$PlatformApiModelImplCopyWithImpl(
    _$PlatformApiModelImpl _value,
    $Res Function(_$PlatformApiModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlatformApiModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? displayName = null,
    Object? description = null,
    Object? logoUrl = null,
    Object? colorScheme = null,
    Object? endpoints = null,
    Object? authConfig = null,
    Object? features = null,
    Object? isEnabled = null,
    Object? comingSoon = null,
    Object? priority = null,
  }) {
    return _then(
      _$PlatformApiModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        logoUrl: null == logoUrl
            ? _value.logoUrl
            : logoUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        colorScheme: null == colorScheme
            ? _value.colorScheme
            : colorScheme // ignore: cast_nullable_to_non_nullable
                  as PlatformColorScheme,
        endpoints: null == endpoints
            ? _value.endpoints
            : endpoints // ignore: cast_nullable_to_non_nullable
                  as PlatformEndpoints,
        authConfig: null == authConfig
            ? _value.authConfig
            : authConfig // ignore: cast_nullable_to_non_nullable
                  as PlatformAuthConfig,
        features: null == features
            ? _value.features
            : features // ignore: cast_nullable_to_non_nullable
                  as PlatformFeatures,
        isEnabled: null == isEnabled
            ? _value.isEnabled
            : isEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        comingSoon: null == comingSoon
            ? _value.comingSoon
            : comingSoon // ignore: cast_nullable_to_non_nullable
                  as bool,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlatformApiModelImpl implements _PlatformApiModel {
  const _$PlatformApiModelImpl({
    required this.id,
    required this.name,
    required this.displayName,
    required this.description,
    required this.logoUrl,
    required this.colorScheme,
    required this.endpoints,
    required this.authConfig,
    required this.features,
    required this.isEnabled,
    required this.comingSoon,
    required this.priority,
  });

  factory _$PlatformApiModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlatformApiModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String displayName;
  @override
  final String description;
  @override
  final String logoUrl;
  @override
  final PlatformColorScheme colorScheme;
  @override
  final PlatformEndpoints endpoints;
  @override
  final PlatformAuthConfig authConfig;
  @override
  final PlatformFeatures features;
  @override
  final bool isEnabled;
  @override
  final bool comingSoon;
  @override
  final int priority;

  @override
  String toString() {
    return 'PlatformApiModel(id: $id, name: $name, displayName: $displayName, description: $description, logoUrl: $logoUrl, colorScheme: $colorScheme, endpoints: $endpoints, authConfig: $authConfig, features: $features, isEnabled: $isEnabled, comingSoon: $comingSoon, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlatformApiModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.colorScheme, colorScheme) ||
                other.colorScheme == colorScheme) &&
            (identical(other.endpoints, endpoints) ||
                other.endpoints == endpoints) &&
            (identical(other.authConfig, authConfig) ||
                other.authConfig == authConfig) &&
            (identical(other.features, features) ||
                other.features == features) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.comingSoon, comingSoon) ||
                other.comingSoon == comingSoon) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    displayName,
    description,
    logoUrl,
    colorScheme,
    endpoints,
    authConfig,
    features,
    isEnabled,
    comingSoon,
    priority,
  );

  /// Create a copy of PlatformApiModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlatformApiModelImplCopyWith<_$PlatformApiModelImpl> get copyWith =>
      __$$PlatformApiModelImplCopyWithImpl<_$PlatformApiModelImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      String id,
      String name,
      String displayName,
      String description,
      String logoUrl,
      PlatformColorScheme colorScheme,
      PlatformEndpoints endpoints,
      PlatformAuthConfig authConfig,
      PlatformFeatures features,
      bool isEnabled,
      bool comingSoon,
      int priority,
    )
    $default,
  ) {
    return $default(
      id,
      name,
      displayName,
      description,
      logoUrl,
      colorScheme,
      endpoints,
      authConfig,
      features,
      isEnabled,
      comingSoon,
      priority,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      String id,
      String name,
      String displayName,
      String description,
      String logoUrl,
      PlatformColorScheme colorScheme,
      PlatformEndpoints endpoints,
      PlatformAuthConfig authConfig,
      PlatformFeatures features,
      bool isEnabled,
      bool comingSoon,
      int priority,
    )?
    $default,
  ) {
    return $default?.call(
      id,
      name,
      displayName,
      description,
      logoUrl,
      colorScheme,
      endpoints,
      authConfig,
      features,
      isEnabled,
      comingSoon,
      priority,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      String id,
      String name,
      String displayName,
      String description,
      String logoUrl,
      PlatformColorScheme colorScheme,
      PlatformEndpoints endpoints,
      PlatformAuthConfig authConfig,
      PlatformFeatures features,
      bool isEnabled,
      bool comingSoon,
      int priority,
    )?
    $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
        id,
        name,
        displayName,
        description,
        logoUrl,
        colorScheme,
        endpoints,
        authConfig,
        features,
        isEnabled,
        comingSoon,
        priority,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PlatformApiModel value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PlatformApiModel value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PlatformApiModel value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PlatformApiModelImplToJson(this);
  }
}

abstract class _PlatformApiModel implements PlatformApiModel {
  const factory _PlatformApiModel({
    required final String id,
    required final String name,
    required final String displayName,
    required final String description,
    required final String logoUrl,
    required final PlatformColorScheme colorScheme,
    required final PlatformEndpoints endpoints,
    required final PlatformAuthConfig authConfig,
    required final PlatformFeatures features,
    required final bool isEnabled,
    required final bool comingSoon,
    required final int priority,
  }) = _$PlatformApiModelImpl;

  factory _PlatformApiModel.fromJson(Map<String, dynamic> json) =
      _$PlatformApiModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get displayName;
  @override
  String get description;
  @override
  String get logoUrl;
  @override
  PlatformColorScheme get colorScheme;
  @override
  PlatformEndpoints get endpoints;
  @override
  PlatformAuthConfig get authConfig;
  @override
  PlatformFeatures get features;
  @override
  bool get isEnabled;
  @override
  bool get comingSoon;
  @override
  int get priority;

  /// Create a copy of PlatformApiModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlatformApiModelImplCopyWith<_$PlatformApiModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlatformsListResponse _$PlatformsListResponseFromJson(
  Map<String, dynamic> json,
) {
  return _PlatformsListResponse.fromJson(json);
}

/// @nodoc
mixin _$PlatformsListResponse {
  List<PlatformApiModel> get platforms => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  String get lastUpdated => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      List<PlatformApiModel> platforms,
      int totalCount,
      String lastUpdated,
    )
    $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      List<PlatformApiModel> platforms,
      int totalCount,
      String lastUpdated,
    )?
    $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      List<PlatformApiModel> platforms,
      int totalCount,
      String lastUpdated,
    )?
    $default, {
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PlatformsListResponse value) $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PlatformsListResponse value)? $default,
  ) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PlatformsListResponse value)? $default, {
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this PlatformsListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlatformsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlatformsListResponseCopyWith<PlatformsListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlatformsListResponseCopyWith<$Res> {
  factory $PlatformsListResponseCopyWith(
    PlatformsListResponse value,
    $Res Function(PlatformsListResponse) then,
  ) = _$PlatformsListResponseCopyWithImpl<$Res, PlatformsListResponse>;
  @useResult
  $Res call({
    List<PlatformApiModel> platforms,
    int totalCount,
    String lastUpdated,
  });
}

/// @nodoc
class _$PlatformsListResponseCopyWithImpl<
  $Res,
  $Val extends PlatformsListResponse
>
    implements $PlatformsListResponseCopyWith<$Res> {
  _$PlatformsListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlatformsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platforms = null,
    Object? totalCount = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _value.copyWith(
            platforms: null == platforms
                ? _value.platforms
                : platforms // ignore: cast_nullable_to_non_nullable
                      as List<PlatformApiModel>,
            totalCount: null == totalCount
                ? _value.totalCount
                : totalCount // ignore: cast_nullable_to_non_nullable
                      as int,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlatformsListResponseImplCopyWith<$Res>
    implements $PlatformsListResponseCopyWith<$Res> {
  factory _$$PlatformsListResponseImplCopyWith(
    _$PlatformsListResponseImpl value,
    $Res Function(_$PlatformsListResponseImpl) then,
  ) = __$$PlatformsListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<PlatformApiModel> platforms,
    int totalCount,
    String lastUpdated,
  });
}

/// @nodoc
class __$$PlatformsListResponseImplCopyWithImpl<$Res>
    extends
        _$PlatformsListResponseCopyWithImpl<$Res, _$PlatformsListResponseImpl>
    implements _$$PlatformsListResponseImplCopyWith<$Res> {
  __$$PlatformsListResponseImplCopyWithImpl(
    _$PlatformsListResponseImpl _value,
    $Res Function(_$PlatformsListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlatformsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platforms = null,
    Object? totalCount = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _$PlatformsListResponseImpl(
        platforms: null == platforms
            ? _value._platforms
            : platforms // ignore: cast_nullable_to_non_nullable
                  as List<PlatformApiModel>,
        totalCount: null == totalCount
            ? _value.totalCount
            : totalCount // ignore: cast_nullable_to_non_nullable
                  as int,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlatformsListResponseImpl implements _PlatformsListResponse {
  const _$PlatformsListResponseImpl({
    required final List<PlatformApiModel> platforms,
    required this.totalCount,
    required this.lastUpdated,
  }) : _platforms = platforms;

  factory _$PlatformsListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlatformsListResponseImplFromJson(json);

  final List<PlatformApiModel> _platforms;
  @override
  List<PlatformApiModel> get platforms {
    if (_platforms is EqualUnmodifiableListView) return _platforms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_platforms);
  }

  @override
  final int totalCount;
  @override
  final String lastUpdated;

  @override
  String toString() {
    return 'PlatformsListResponse(platforms: $platforms, totalCount: $totalCount, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlatformsListResponseImpl &&
            const DeepCollectionEquality().equals(
              other._platforms,
              _platforms,
            ) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_platforms),
    totalCount,
    lastUpdated,
  );

  /// Create a copy of PlatformsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlatformsListResponseImplCopyWith<_$PlatformsListResponseImpl>
  get copyWith =>
      __$$PlatformsListResponseImplCopyWithImpl<_$PlatformsListResponseImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      List<PlatformApiModel> platforms,
      int totalCount,
      String lastUpdated,
    )
    $default,
  ) {
    return $default(platforms, totalCount, lastUpdated);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      List<PlatformApiModel> platforms,
      int totalCount,
      String lastUpdated,
    )?
    $default,
  ) {
    return $default?.call(platforms, totalCount, lastUpdated);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      List<PlatformApiModel> platforms,
      int totalCount,
      String lastUpdated,
    )?
    $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(platforms, totalCount, lastUpdated);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PlatformsListResponse value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PlatformsListResponse value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PlatformsListResponse value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PlatformsListResponseImplToJson(this);
  }
}

abstract class _PlatformsListResponse implements PlatformsListResponse {
  const factory _PlatformsListResponse({
    required final List<PlatformApiModel> platforms,
    required final int totalCount,
    required final String lastUpdated,
  }) = _$PlatformsListResponseImpl;

  factory _PlatformsListResponse.fromJson(Map<String, dynamic> json) =
      _$PlatformsListResponseImpl.fromJson;

  @override
  List<PlatformApiModel> get platforms;
  @override
  int get totalCount;
  @override
  String get lastUpdated;

  /// Create a copy of PlatformsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlatformsListResponseImplCopyWith<_$PlatformsListResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
