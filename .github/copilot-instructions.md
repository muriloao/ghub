# GHub Mobile - Copilot Instructions

## Project Overview
GHub é um aplicativo Flutter que segue **Clean Architecture** para sincronização de estatísticas de jogos de múltiplas plataformas (Steam, Epic Games, Xbox). Usa **Riverpod** para state management e implementa OAuth2/OpenID para integrações.

## Architecture & Structure
- **Clean Architecture**: Features divididas em `data/`, `domain/`, `presentation/`
- **Feature-based structure**: Cada feature em `lib/features/[feature_name]/`
- **Core services**: Configurações globais em `lib/core/`
- **Code generation**: Usa Freezed, JSON Serializable e Retrofit

## Key Development Patterns

### State Management
- **Riverpod providers** são definidos por feature em arquivos `*_providers.dart`
- Use `StateNotifier` para estados complexos, `Provider` para dependências
- Exemplo: `authStateProvider`, `gamesStateProvider`

### Data Layer
- **Repository pattern**: Interfaces em `domain/repositories/`, implementações em `data/repositories/`
- **Data sources**: Local (`*_local_data_source.dart`) e Remote (`*_remote_data_source.dart`)
- **Models**: Classes com Freezed para JSON serialization

### API Integration
- **Base URL**: Configurado em `AppConstants.baseUrl`
- **Environment variables**: Configs sensíveis usam `String.fromEnvironment()`
- **Platform APIs**: Steam, Epic, Xbox têm services específicos em `features/auth/data/services/`

## Essential Workflows

### Code Generation
```bash
dart run build_runner build --delete-conflicting-outputs
```
Necessário após modificar models, repositories ou services com annotations.

### Platform Configuration
- **Steam**: Requer API key em `STEAM_API_KEY` environment variable
- **Epic Games**: Client ID/Secret em `EPIC_CLIENT_ID`, `EPIC_CLIENT_SECRET`
- **Xbox**: Azure AD credentials em `XBOX_CLIENT_ID`, `XBOX_CLIENT_SECRET`

### Deep Linking
- Custom scheme `ghub://` configurado para OAuth callbacks
- Routes definidas em `lib/core/router/app_router.dart`

## Critical Files
- [`lib/core/constants/app_constants.dart`](lib/core/constants/app_constants.dart): Base URLs, timeouts, storage keys
- [`lib/core/config/`](lib/core/config/): Platform-specific configurations
- [`pubspec.yaml`](pubspec.yaml): Dependencies com versões específicas
- [`build.yaml`](build.yaml): Code generation settings

## Development Guidelines

### Error Handling
- Use `Either<Failure, T>` pattern com dartz package
- Custom exceptions: `ServerException`, `CacheException`, `AuthenticationException`
- Failures: `ServerFailure`, `CacheFailure`, `ValidationFailure`

### Testing
- Mock implementations para data sources
- Provider overrides para testing com Riverpod
- Use `flutter test` para unit tests

### Authentication Flow
1. OAuth redirect para browser/WebView
2. Callback capturado via deep link
3. Token exchange e user data storage
4. State management via `authStateProvider`

## Platform-Specific Notes
- **Steam**: OpenID flow + API key para dados de jogos
- **Epic**: OAuth2 standard com scopes específicos
- **Xbox**: Multi-step auth (Live → Xbox Live → XSTS)
- **Rate limiting**: Implementado por platform (configs em `*_config.dart`)

## Common Commands
```bash
flutter pub get                    # Install dependencies
flutter analyze                   # Static analysis
dart format .                     # Format code
flutter pub outdated              # Check outdated packages
```