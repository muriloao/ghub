import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'features/auth/domain/entities/user_test.dart' as user_test;
import 'features/auth/domain/usecases/logout_test.dart' as logout_test;

import 'features/games/domain/entities/game_test.dart' as game_test;
import 'features/games/domain/usecases/get_user_games_test.dart'
    as get_user_games_test;

import 'features/onboarding/domain/entities/gaming_platform_test.dart'
    as gaming_platform_test;

import 'core/network/network_info_test.dart' as network_info_test;
import 'core/error/exceptions_and_failures_test.dart'
    as exceptions_failures_test;

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
        logout_test.main();
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
  });
}
