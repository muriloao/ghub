import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/services/steam_auth_service.dart';
import '../../data/services/epic_auth_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_with_credentials.dart';
import '../../domain/usecases/login_with_google.dart';
import '../../domain/usecases/login_with_steam.dart';
import '../../domain/usecases/login_with_epic.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_up.dart';

// External dependencies
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(scopes: ['email', 'profile']);
});

// Steam Auth Service
final steamAuthServiceProvider = Provider<SteamAuthService>((ref) {
  return SteamAuthService(ref.watch(dioProvider));
});

// Epic Games Auth Service
final epicAuthServiceProvider = Provider<EpicAuthService>((ref) {
  return EpicAuthService(ref.watch(dioProvider));
});

// Data sources
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(
    dio: ref.watch(dioProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  );
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

// Use cases
final loginWithCredentialsProvider = Provider<LoginWithCredentials>((ref) {
  return LoginWithCredentials(ref.watch(authRepositoryProvider));
});

final loginWithGoogleProvider = Provider<LoginWithGoogle>((ref) {
  return LoginWithGoogle(ref.watch(authRepositoryProvider));
});

final loginWithSteamProvider = Provider<LoginWithSteam>((ref) {
  return LoginWithSteam(ref.watch(authRepositoryProvider));
});

final loginWithEpicProvider = Provider<LoginWithEpic>((ref) {
  return LoginWithEpic(ref.watch(authRepositoryProvider));
});

final logoutProvider = Provider<Logout>((ref) {
  return Logout(ref.watch(authRepositoryProvider));
});

final getCurrentUserProvider = Provider<GetCurrentUser>((ref) {
  return GetCurrentUser(ref.watch(authRepositoryProvider));
});

final signUpProvider = Provider<SignUp>((ref) {
  return SignUp(ref.watch(authRepositoryProvider));
});
