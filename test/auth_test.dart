import 'package:dropshare/main.dart' as app;
import 'package:dropshare/auth/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;
}

void main() {

  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  final Authentication auth = Authentication();

  setUp(() {});
  tearDown(() {});

  test('emit occurs', () async {
    app.main();
    expectLater(auth.user, _mockUser);
  });


}