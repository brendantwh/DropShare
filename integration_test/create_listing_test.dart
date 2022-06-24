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

      final create = find.byKey(const Key('create'));
      await tester.tap(create);
      await tester.pumpAndSettle();

      //Finders for email and password
      final title = find.byKey(const Key('create title'));
      final createButton = find.byKey(const Key('create button'));

      //Enter email and password
      await tester.enterText(title, '');
      await tester.pumpAndSettle();

      await tester.tap(createButton);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('empty title create')), findsOneWidget);
    });

    // Not working at one go have to do separately
    // testWidgets('with no photo field', (tester) async {
    //   app.main();
    //   await tester.pumpAndSettle();

    //   //Tap success dialog
    //   final successalertDialog = find.byType(CupertinoDialogAction);
    //   await tester.tap(successalertDialog);
    //   await tester.pumpAndSettle();

    //   final create = find.byKey(const Key('create'));
    //   await tester.tap(create);
    //   await tester.pumpAndSettle();

    //   //Finders for email and password
    //   final title = find.byKey(const Key('create title'));
    //   final createButton = find.byKey(const Key('create button'));

    //   //Enter email and password
    //   await tester.enterText(title, 'dropshare');
    //   await tester.pumpAndSettle();

    //   await tester.tap(createButton);
    //   await tester.pumpAndSettle();

    //   expect(find.byKey(const Key('empty title create')), findsOneWidget);
    // });
  });
}