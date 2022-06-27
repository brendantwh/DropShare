import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dropshare/main.dart' as app;
import 'package:flutter/cupertino.dart';

//MUST BE LOGGED OUT AT FIRST

void main() {
  group('sign up', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('with no username field', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final signuphere = find.byKey(const Key('sign up here'));
      await tester.tap(signuphere);
      await tester.pumpAndSettle();

      //Finders for email and password
      final username = find.byKey(const Key('username'));
      final email = find.byKey(const Key('email signup'));
      final password = find.byKey(const Key('password signup'));
      final signupbutton = find.byKey(const Key('signupbutton'));

      //Enter email and password
      await tester.enterText(username, '');
      await tester.enterText(email, 'drop@share.com');
      await tester.enterText(password, 'dropshare');
      await tester.pumpAndSettle();

      await tester.tap(signupbutton);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('email empty')), findsOneWidget);     
    });

    testWidgets('with more than 16 username characters', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final signuphere = find.byKey(const Key('sign up here'));
      await tester.tap(signuphere);
      await tester.pumpAndSettle();

      //Finders for email and password
      final username = find.byKey(const Key('username'));
      final email = find.byKey(const Key('email signup'));
      final password = find.byKey(const Key('password signup'));
      final signupbutton = find.byKey(const Key('signupbutton'));

      //Enter email and password
      await tester.enterText(username, '123456789tettffsse');
      await tester.enterText(email, 'drop@share.com');
      await tester.enterText(password, 'dropshare');
      await tester.pumpAndSettle();

      await tester.tap(signupbutton);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('email empty')), findsOneWidget);     
    });

    testWidgets('with non valid nus email', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final signuphere = find.byKey(const Key('sign up here'));
      await tester.tap(signuphere);
      await tester.pumpAndSettle();

      //Finders for email and password
      final username = find.byKey(const Key('username'));
      final email = find.byKey(const Key('email signup'));
      final password = find.byKey(const Key('password signup'));
      final signupbutton = find.byKey(const Key('signupbutton'));

      //Enter email and password
      await tester.enterText(username, '123456789tettffsse');
      await tester.enterText(email, 'leedekai@hotmail.com');
      await tester.enterText(password, 'dropshare');
      await tester.pumpAndSettle();

      await tester.tap(signupbutton);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('email empty')), findsOneWidget);     
    });

    // testWidgets('with valid nus email', (tester) async {
    //   app.main();
    //   await tester.pumpAndSettle();

    //   final signuphere = find.byKey(const Key('sign up here'));
    //   await tester.tap(signuphere);
    //   await tester.pumpAndSettle();

    //   //Finders for email and password
    //   final username = find.byKey(const Key('username'));
    //   final email = find.byKey(const Key('email signup'));
    //   final password = find.byKey(const Key('password signup'));
    //   final signupbutton = find.byKey(const Key('signupbutton'));

    //   //Enter email and password
    //   await tester.enterText(username, 'dklee');
    //   await tester.enterText(email, 'e0725481@u.nus.edu');
    //   await tester.enterText(password, 'password1');
    //   await tester.pumpAndSettle();

    //   await tester.tap(signupbutton);
    //   await tester.pumpAndSettle();

    //   expect(find.byKey(const Key('Success')), findsOneWidget);     
    // });


  });
}