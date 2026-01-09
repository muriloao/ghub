import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_with_credentials.dart';
import '../../domain/usecases/login_with_google.dart';
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

final logoutProvider = Provider<Logout>((ref) {
  return Logout(ref.watch(authRepositoryProvider));
});

final getCurrentUserProvider = Provider<GetCurrentUser>((ref) {
  return GetCurrentUser(ref.watch(authRepositoryProvider));
});

final signUpProvider = Provider<SignUp>((ref) {
  return SignUp(ref.watch(authRepositoryProvider));
});

// Provider para controle de navegação baseado em primeiro login
final navigationControllerProvider =
    StateNotifierProvider<NavigationController, NavigationState>((ref) {
      return NavigationController();
    });

class NavigationState {
  final bool shouldRedirectToIntegrations;
  final String? userEmail;

  const NavigationState({
    this.shouldRedirectToIntegrations = false,
    this.userEmail,
  });

  NavigationState copyWith({
    bool? shouldRedirectToIntegrations,
    String? userEmail,
  }) {
    return NavigationState(
      shouldRedirectToIntegrations:
          shouldRedirectToIntegrations ?? this.shouldRedirectToIntegrations,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}

class NavigationController extends StateNotifier<NavigationState> {
  NavigationController() : super(const NavigationState());

  Future<void> checkFirstTimeLogin(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    final existingEmails =
        prefs.getStringList(AppConstants.firstTimeUserKey) ?? [];
    final isFirstTime = !existingEmails.contains(userEmail);

    state = state.copyWith(
      shouldRedirectToIntegrations: isFirstTime,
      userEmail: userEmail,
    );
  }

  Future<void> markUserAsReturning(String userEmail) async {
    final prefs = await SharedPreferences.getInstance();
    final existingEmails =
        prefs.getStringList(AppConstants.firstTimeUserKey) ?? [];
    if (!existingEmails.contains(userEmail)) {
      existingEmails.add(userEmail);
      await prefs.setStringList(AppConstants.firstTimeUserKey, existingEmails);
    }

    state = state.copyWith(shouldRedirectToIntegrations: false);
  }

  void reset() {
    state = const NavigationState();
  }
}
