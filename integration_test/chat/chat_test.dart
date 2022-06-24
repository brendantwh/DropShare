import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropshare/chat/bubble.dart';
import 'package:dropshare/chat/chat.dart';
import 'package:dropshare/chat/chatlist.dart';
import 'package:dropshare/listings/indiv.dart';
import 'package:dropshare/listings/listinggridfs.dart';
import 'package:dropshare/listings/listingspage.dart';
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
      initialRoute: 'listings',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case 'listings':
            return CupertinoPageRoute(builder: (_) => const ListingsPage(), settings: settings);
          case 'indiv':
            return CupertinoPageRoute(builder: (context) => const IndivListing(), settings: settings);
          case 'chat':
            return CupertinoPageRoute(builder: (context) => const Chat(), settings: settings);
          case 'chatlist':
            return CupertinoPageRoute(builder: (context) => const Chatlist(), settings: settings);
        }
      }
  );
  String listingTitle = 'Google Home mini';

  setUpAll(() async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.settings = const Settings(
        host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
    FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'drop@share.com', password: 'dropshare');
  });

  group('Can message another user', () {
    testWidgets('Table fan listing should show "Message" button', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      final listingsFinder = find.descendant(of: find.byType(ListingGridFs), matching: find.byType(ClipRRect));
      expect(listingsFinder, findsNWidgets(2));

      final fanFinder = find.descendant(of: listingsFinder, matching: find.text('Table fan'));
      expect(fanFinder, findsOneWidget);
      await tester.tap(fanFinder);
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      final buttonFinder = find.descendant(of: find.byType(Row), matching: find.byType(CupertinoButton));
      expect(buttonFinder, findsOneWidget);

      final messageFinder = find.descendant(of: buttonFinder, matching: find.text('Message'));
      expect(messageFinder, findsOneWidget);
    });

    testWidgets('Chat page appears', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      final listingsFinder = find.descendant(of: find.byType(ListingGridFs), matching: find.byType(ClipRRect));
      expect(listingsFinder, findsNWidgets(2));

      final fanFinder = find.descendant(of: listingsFinder, matching: find.text('Table fan'));
      expect(fanFinder, findsOneWidget);
      await tester.tap(fanFinder);
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      final buttonFinder = find.descendant(of: find.byType(Row), matching: find.byType(CupertinoButton));
      expect(buttonFinder, findsOneWidget);

      final messageFinder = find.descendant(of: buttonFinder, matching: find.text('Message'));
      expect(messageFinder, findsOneWidget);
      await tester.tap(messageFinder);
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      final bubbleFinder = find.descendant(of: find.byType(ListView), matching: find.byType(Bubble));
      expect(bubbleFinder, findsNothing);
    });

    testWidgets('Sends message successfully', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      final listingsFinder = find.descendant(of: find.byType(ListingGridFs), matching: find.byType(ClipRRect));
      expect(listingsFinder, findsNWidgets(2));

      final fanFinder = find.descendant(of: listingsFinder, matching: find.text('Table fan'));
      expect(fanFinder, findsOneWidget);
      await tester.tap(fanFinder);
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      final buttonFinder = find.descendant(of: find.byType(Row), matching: find.byType(CupertinoButton));
      expect(buttonFinder, findsOneWidget);

      final messageFinder = find.descendant(of: buttonFinder, matching: find.text('Message'));
      expect(messageFinder, findsOneWidget);
      await tester.tap(messageFinder);
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      final bubbleFinder = find.descendant(of: find.byType(ListView), matching: find.byType(Bubble));
      expect(bubbleFinder, findsNothing);

      final inputFinder = find.byType(CupertinoTextField);
      final sendFinder = find.descendant(of: inputFinder, matching: find.byType(CupertinoButton));
      expect(inputFinder, findsOneWidget);
      expect(sendFinder, findsOneWidget);

      await tester.enterText(inputFinder, 'Hello');
      await tester.tap(sendFinder);
      await tester.pumpAndSettle();
      expect(bubbleFinder, findsOneWidget);

      final contentFinder = find.descendant(of: bubbleFinder, matching: find.text('Hello'));
      expect(contentFinder, findsOneWidget);
    });
  });

  group('Can view listing chats', () {
    testWidgets('Google Home mini listing should show "View chats" and "Manage listing" buttons', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      final listingsFinder = find.descendant(of: find.byType(ListingGridFs), matching: find.byType(ClipRRect));
      expect(listingsFinder, findsNWidgets(2));

      final miniFinder = find.descendant(of: listingsFinder, matching: find.text(listingTitle));
      expect(miniFinder, findsOneWidget);
      await tester.tap(miniFinder);
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      final buttonsFinder = find.descendant(of: find.byType(Row), matching: find.byType(CupertinoButton));
      expect(buttonsFinder, findsNWidgets(2));

      final chatFinder = find.descendant(of: buttonsFinder, matching: find.text('View chats'));
      final manageFinder = find.descendant(of: buttonsFinder, matching: find.text('Manage listing'));
      expect(chatFinder, findsOneWidget);
      expect(manageFinder, findsOneWidget);
    });

    testWidgets('Chat listing appears', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      final listingsFinder = find.descendant(of: find.byType(ListingGridFs), matching: find.byType(ClipRRect));
      expect(listingsFinder, findsNWidgets(2));

      final miniFinder = find.descendant(of: listingsFinder, matching: find.text(listingTitle));
      expect(miniFinder, findsOneWidget);
      await tester.tap(miniFinder);
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      final buttonsFinder = find.descendant(of: find.byType(Row), matching: find.byType(CupertinoButton));
      expect(buttonsFinder, findsNWidgets(2));

      final chatFinder = find.descendant(of: buttonsFinder, matching: find.text('View chats'));
      expect(chatFinder, findsOneWidget);

      await tester.tap(chatFinder);
      await tester.pumpAndSettle();

      final userChatFinder = find.text('Chat with another user');
      expect(userChatFinder, findsOneWidget);
    });

    testWidgets('Other user message appears', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      final listingsFinder = find.descendant(of: find.byType(ListingGridFs), matching: find.byType(ClipRRect));
      expect(listingsFinder, findsNWidgets(2));

      final miniFinder = find.descendant(of: listingsFinder, matching: find.text(listingTitle));
      expect(miniFinder, findsOneWidget);
      await tester.tap(miniFinder);
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      final buttonsFinder = find.descendant(of: find.byType(Row), matching: find.byType(CupertinoButton));
      expect(buttonsFinder, findsNWidgets(2));

      final chatFinder = find.descendant(of: buttonsFinder, matching: find.text('View chats'));
      expect(chatFinder, findsOneWidget);

      await tester.tap(chatFinder);
      await tester.pumpAndSettle();

      final userChatFinder = find.text('Chat with another user');
      expect(userChatFinder, findsOneWidget);

      await tester.tap(userChatFinder);
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      final bubbleFinder = find.descendant(of: find.byType(ListView), matching: find.byType(Bubble));
      expect(bubbleFinder, findsOneWidget);

      final contentFinder = find.descendant(of: bubbleFinder, matching: find.text('I want'));
      expect(contentFinder, findsOneWidget);
    });
  });
}