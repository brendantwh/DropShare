import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropshare/auth/login.dart';
import 'package:dropshare/listings/indiv.dart';
import 'package:dropshare/user/userpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Remember to firebase emulators:start --import ./firebase-data --export-on-exit
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  Widget app = CupertinoApp(
      initialRoute: 'userpage',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case 'userpage':
            return CupertinoPageRoute(builder: (_) => const Userpage(), settings: settings);
          case 'indiv':
            return CupertinoPageRoute(builder: (context) => const IndivListing(), settings: settings);
          case 'login':
            return CupertinoPageRoute(builder: (_) => const Login(), settings: settings);
        }
      }
  );

  setUpAll(() async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.settings = const Settings(host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
    FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseAuth.instance.signInWithEmailAndPassword(email: 'drop@share.com', password: 'dropshare');
  });

  group('Userpage shows correct user', () {
    testWidgets('Correct username', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      expect(find.text('You are firebase emulator'), findsOneWidget);
    });

    testWidgets('Correct user listings', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      expect(find.byType(ClipRRect), findsOneWidget);
    });
  });

  group('Userpage allows user to sign out', () {
    testWidgets('Has sign out button', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      expect(find.byIcon(CupertinoIcons.person_crop_circle_badge_xmark), findsOneWidget);
    });

    testWidgets('Sign out prompt appears', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final iconFinder = find.byIcon(CupertinoIcons.person_crop_circle_badge_xmark);
      expect(iconFinder, findsOneWidget);

      await tester.tap(iconFinder);
      await tester.pumpAndSettle();

      final signOutFinder = find.descendant(of: find.byType(CupertinoDialogAction), matching: find.text('Sign out'));
      expect(signOutFinder, findsOneWidget);
    });

    testWidgets('Successfully sign out', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final iconFinder = find.byIcon(CupertinoIcons.person_crop_circle_badge_xmark);
      expect(iconFinder, findsOneWidget);

      await tester.tap(iconFinder);
      await tester.pumpAndSettle();

      final signOutFinder = find.descendant(of: find.byType(CupertinoDialogAction), matching: find.text('Sign out'));
      expect(signOutFinder, findsOneWidget);

      await tester.tap(signOutFinder);
      await tester.pumpAndSettle();
      expect(find.text('Successfully signed out'), findsOneWidget);

      final actionFinder = find.descendant(of: find.byType(CupertinoDialogAction), matching: find.text('Ok'));
      await tester.tap(actionFinder);
      await tester.pumpAndSettle();
      expect(find.text('Login'), findsOneWidget);
    });
  });
}