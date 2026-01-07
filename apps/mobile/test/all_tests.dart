import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'features/auth/domain/entities/user_test.dart' as user_test;
import 'features/auth/domain/usecases/login_with_credentials_test.dart' as login_credentials_test;
import 'features/auth/domain/usecases/login_with_google_test.dart' as login_google_test;
import 'features/auth/domain/usecases/logout_test.dart' as logout_test;
import 'features/auth/data/repositories/auth_repository_impl_test.dart' as auth_repository_test;
import 'features/auth/presentation/providers/auth_providers_test.dart' as auth_providers_test;

import 'features/games/domain/entities/game_test.dart' as game_test;
import 'features/games/domain/usecases/get_user_games_test.dart' as get_user_games_test;

import 'features/onboarding/domain/entities/gaming_platform_test.dart' as gaming_platform_test;

import 'features/profile/domain/usecases/get_user_profile_test.dart' as get_user_profile_test;

import 'features/achievements/domain/usecases/get_steam_achievements_test.dart' as get_steam_achievements_test;

import 'core/network/network_info_test.dart' as network_info_test;
import 'core/error/exceptions_and_failures_test.dart' as exceptions_failures_test;

void main() {
  group('GHub Mobile - All Tests', () {
    group('Core Tests', () {
      group('Network', () {
        network_info_test.main();
      });
      
      group('Errors', () {
        exceptions_failures_test.main();
      });
    });

    group('Auth Feature Tests', () {
      group('Entities', () {
        user_test.main();
      });
      
      group('Use Cases', () {
        login_credentials_test.main();
        login_google_test.main();
        logout_test.main();
      });
      
      group('Repositories', () {
        auth_repository_test.main();
      });
      
      group('Providers', () {
        auth_providers_test.main();
      });
    });

    group('Games Feature Tests', () {
      group('Entities', () {
        game_test.main();
      });
      
      group('Use Cases', () {
        get_user_games_test.main();
      });
    });

    group('Onboarding Feature Tests', () {
      group('Entities', () {
        gaming_platform_test.main();
      });
    });

    group('Profile Feature Tests', () {
      group('Use Cases', () {
        get_user_profile_test.main();
      });
    });

    group('Achievements Feature Tests', () {
      group('Use Cases', () {
        get_steam_achievements_test.main();
      });
    });
  });
}