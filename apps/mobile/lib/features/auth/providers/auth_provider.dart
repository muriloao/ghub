import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ghub_mobile/features/auth/data/models/user_model.dart';
import 'package:ghub_mobile/features/auth/data/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

/// Estado da autenticação
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Estado da autenticação com dados do usuário
class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Provider do estado de autenticação
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    return const AuthState(status: AuthStatus.initial);
  }

  /// Autentica com token do GitHub
  Future<void> authenticateWithToken(String token) async {
    state = state.copyWith(status: AuthStatus.loading);

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.authenticateWithToken(token);

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }

  /// Busca dados do usuário atual
  Future<void> getCurrentUser() async {
    state = state.copyWith(status: AuthStatus.loading);

    final repository = ref.read(authRepositoryProvider);
    final result = await repository.getCurrentUser();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }

  /// Faz logout
  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.logout();

    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Limpa erros
  void clearError() {
    state = state.copyWith(
      status: AuthStatus.initial,
      errorMessage: null,
    );
  }
}
