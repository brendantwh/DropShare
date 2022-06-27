import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dropshare/main.dart' as app;
import 'package:flutter/cupertino.dart';

//MUST BE LOGGED OUT AT FIRST

void main() {
  group('create listings', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('with no title field', (tester) async {
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

      //Sign in
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      //Tap success dialog
      expect(find.byKey(const Key('Success')), findsOneWidget);
      final successalertDialog = find.byType(CupertinoDialogAction);
      await tester.tap(successalertDialog);
      await tester.pumpAndSettle();

      //Tap on userpage
      final userPage = find.byKey(const Key('userpage'));
      await tester.tap(userPage);
      await tester.pumpAndSettle();

      //Tap on sign out
      final signOut = find.byKey(const Key('sign out button'));
      await tester.tap(signOut);
      await tester.pumpAndSettle();

      //Tap on sign out cupertino alert dialog
      final finalsignout = find.byKey(const Key('final sign out'));
      await tester.tap(finalsignout);
      await tester.pumpAndSettle();

      //Expect success
      expect(find.byKey(const Key('Success')), findsOneWidget);
    });
  });
}