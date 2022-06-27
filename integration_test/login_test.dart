import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dropshare/main.dart' as app;
import 'package:flutter/cupertino.dart';

//MUST BE LOGGED OUT AT FIRST

void main() {
  group('login to app', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('with no email field', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      //Finders for email and password
      final email = find.byKey(const Key('login_email'));
      final password = find.byKey(const Key('login_key'));
      final loginButton = find.byKey(const Key('login_button'));

      //Enter email and password
      await tester.enterText(email, '');
      await tester.enterText(password, 'dropshare');
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('email empty')), findsOneWidget);
      
    });

    testWidgets('with no password field', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      //Finders for email and password
      final email = find.byKey(const Key('login_email'));
      final password = find.byKey(const Key('login_key'));
      final loginButton = find.byKey(const Key('login_button'));

      //Enter email and password
      await tester.enterText(email, 'drop@share.com');
      await tester.enterText(password, '');
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('email empty')), findsOneWidget);
      
    });

    testWidgets('with valid user', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      //Finders for email and password
      final email = find.byKey(const Key('login_email'));
      final password = find.byKey(const Key('login_key'));
      final loginButton = find.byKey(const Key('login_button'));

      //Enter email and password
      await tester.enterText(email, 'drop@share.com');
      await tester.enterText(password, 'dropshare');
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('Success')), findsOneWidget);
    });
  });
}