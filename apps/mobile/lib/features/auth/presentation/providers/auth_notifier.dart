import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import 'package:ghub_mobile/features/auth/domain/entities/auth_result.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/login_with_credentials.dart';
import '../../domain/usecases/login_with_google.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/entities/signup_request.dart';
import '../../../../core/services/cache_service.dart';
import 'auth_providers.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginWithCredentials _loginWithCredentials;
  final LoginWithGoogle _loginWithGoogle;
  final SignUp _signUp;
  final Logout _logout;
  final GetCurrentUser _getCurrentUser;

  AuthNotifier({
    required LoginWithCredentials loginWithCredentials,
    required LoginWithGoogle loginWithGoogle,
    required SignUp signUp,
    required Logout logout,
    required GetCurrentUser getCurrentUser,
  }) : _loginWithCredentials = loginWithCredentials,
       _loginWithGoogle = loginWithGoogle,
       _signUp = signUp,
       _logout = logout,
       _getCurrentUser = getCurrentUser,
       super(const AuthInitial()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = const AuthLoading();

    try {
      // Primeiro, tenta recuperar do cache
      final cachedData = await CacheService.getCachedUserData();

      if (cachedData != null) {
        // Verifica se o cache é válido (não expirou)
        final hasValidCache = await CacheService.hasValidUserCache();

        if (hasValidCache) {
          // Usa dados do cache para login automático
          state = AuthAuthenticated(cachedData.user);

          // Atualiza timestamp de último login
          await CacheService.updateLastLoginTimestamp();
          return;
        }
      }

      // Se não há cache válido, tenta verificar com API
      final result = await _getCurrentUser();
      result.fold(
        (failure) => state = const AuthUnauthenticated(),
        (user) => state = user != null
            ? AuthAuthenticated(user)
            : const AuthUnauthenticated(),
      );
    } catch (e) {
      // Em caso de erro, assume como não autenticado
      state = const AuthUnauthenticated();
    }
  }

  Future<void> loginWithCredentials(String email, String password) async {
    state = const AuthLoading();

    final result = await _loginWithCredentials(
      email: email,
      password: password,
    );

    result.fold((failure) => state = AuthError(failure.toString()), (
      authResult,
    ) async {
      // Cache dos dados após login bem-sucedido
      await _cacheAuthResult(authResult);
      state = AuthAuthenticated(authResult.user);
    });
  }

  Future<void> loginWithGoogle() async {
    state = const AuthLoading();

    final result = await _loginWithGoogle();

    result.fold((failure) => state = AuthError(failure.toString()), (
      authResult,
    ) async {
      // Cache dos dados após login bem-sucedido
      await _cacheAuthResult(authResult);
      state = AuthAuthenticated(authResult.user);
    });
  }

  /// Login direto usando um AuthResult já obtido (usado no callback Steam)
  Future<void> loginWithAuthResult(
    AuthResult authResult, {
    String? steamId,
  }) async {
    state = const AuthLoading();

    // Cache dos dados após login bem-sucedido
    await _cacheAuthResult(authResult, steamId: steamId);

    // Simular pequeno delay para UX
    await Future.delayed(const Duration(milliseconds: 500));
    state = AuthAuthenticated(authResult.user);
  }

  Future<void> signUp(SignUpRequest request) async {
    state = const AuthLoading();

    final result = await _signUp(request);

    result.fold((failure) => state = AuthError(failure.toString()), (
      authResult,
    ) async {
      // Cache dos dados após cadastro bem-sucedido
      await _cacheAuthResult(authResult);
      state = AuthAuthenticated(authResult.user);
    });
  }

  Future<void> logout() async {
    try {
      // Primeiro, limpa o cache
      await CacheService.clearUserCache();

      // Depois, executa o logout da API
      final result = await _logout();
      result.fold(
        (failure) => state = AuthError(failure.toString()),
        (_) => state = const AuthUnauthenticated(),
      );
    } catch (e) {
      // Mesmo com erro na API, garante que o estado local seja limpo
      state = const AuthUnauthenticated();
    }
  }

  /// Cache dos dados de autenticação
  Future<void> _cacheAuthResult(
    AuthResult authResult, {
    String? steamId,
  }) async {
    try {
      await CacheService.cacheUserData(
        user: authResult.user,
        authToken: authResult.accessToken,
        steamId: steamId,
      );
    } catch (e) {
      // Log do erro, mas não falha o login
      debugPrint('Erro ao salvar cache: $e');
    }
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(
    loginWithCredentials: ref.watch(loginWithCredentialsProvider),
    loginWithGoogle: ref.watch(loginWithGoogleProvider),
    signUp: ref.watch(signUpProvider),
    logout: ref.watch(logoutProvider),
    getCurrentUser: ref.watch(getCurrentUserProvider),
  );
});
