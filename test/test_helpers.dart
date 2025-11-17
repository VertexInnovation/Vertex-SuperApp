import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

// Test setup
Future<void> setupFirebaseMocks() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Setup mock Firebase
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Mock SharedPreferences
  SharedPreferences.setMockInitialValues({});
  
  // Setup any other mocks needed for tests
}

// Common test utilities
void printTestHeader(String testName) {
  print('\n' + '=' * 80);
  print('TEST: $testName');
  print('=' * 80);
}

// Common test matchers
final emailMatcher = isA<String>()
    .having((s) => s.contains('@'), 'contains @', isTrue)
    .having((s) => s.split('@').last.contains('.'), 'has domain', isTrue);

final passwordMatcher = isA<String>()
    .having((s) => s.length, 'length', greaterThanOrEqualTo(6));

// Common test data
const testEmail = 'test@example.com';
const testPassword = 'password123';
const testDisplayName = 'Test User';
const testUid = 'test-uid-123';
