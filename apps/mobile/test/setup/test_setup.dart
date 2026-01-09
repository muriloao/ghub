import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock data setup for all tests
void setupTestEnvironment() {
  // Clear any existing SharedPreferences data
  SharedPreferences.setMockInitialValues({});

  // Setup global test configuration
  TestWidgetsFlutterBinding.ensureInitialized();
}
