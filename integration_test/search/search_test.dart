import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropshare/listings/indiv.dart';
import 'package:dropshare/listings/listinggridsearch.dart';
import 'package:dropshare/search/searchpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Remember to firebase emulators:start --import ./firebase-data (--export-on-exit)
// Remember to brew services start typesense-server
//             brew services stop typesense-server
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  Widget app = CupertinoApp(
      initialRoute: 'search',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case 'search':
            return CupertinoPageRoute(builder: (_) => const SearchPage(), settings: settings);
          case 'indiv':
            return CupertinoPageRoute(builder: (context) => const IndivListing(), settings: settings);
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

  group('Search page displays correctly', () {
    testWidgets('Shows search bar', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoSearchTextField), findsOneWidget);
    });

    testWidgets('Is empty at launch', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final gridFinder = find.byType(ListingGridSearch);
      expect(gridFinder, findsOneWidget);

      final listingFinder = find.descendant(of: gridFinder, matching: find.byType(ClipRRect));
      expect(listingFinder, findsNothing);
    });
  });

  group('Search page shows correct results', () {
    testWidgets('Search for fan yields one correct result', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final searchBarFinder = find.byType(CupertinoSearchTextField);
      expect(searchBarFinder, findsOneWidget);

      await tester.enterText(searchBarFinder, 'fan');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle(Duration(milliseconds: 250));

      final resultFinder = find.text('1 listing found');
      expect(resultFinder, findsOneWidget);

      final gridFinder = find.byType(ListingGridSearch);
      expect(gridFinder, findsOneWidget);

      final listingFinder = find.descendant(of: gridFinder, matching: find.byType(ClipRRect));
      expect(listingFinder, findsOneWidget);

      final fanFinder = find.descendant(of: listingFinder, matching: find.text('Table fan'));
      expect(fanFinder, findsOneWidget);
    });

    testWidgets('Result passes correct details to indiv page', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final searchBarFinder = find.byType(CupertinoSearchTextField);
      expect(searchBarFinder, findsOneWidget);

      await tester.enterText(searchBarFinder, 'fan');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle(Duration(milliseconds: 250));

      final resultFinder = find.text('1 listing found');
      expect(resultFinder, findsOneWidget);

      final gridFinder = find.byType(ListingGridSearch);
      expect(gridFinder, findsOneWidget);

      final listingFinder = find.descendant(of: gridFinder, matching: find.byType(ClipRRect));
      expect(listingFinder, findsOneWidget);

      final fanFinder = find.descendant(of: listingFinder, matching: find.text('Table fan'));
      expect(fanFinder, findsOneWidget);

      await tester.tap(fanFinder);
      await tester.pumpAndSettle(Duration(milliseconds: 250));

      final titleFinder = find.text('Table fan');
      final priceFinder = find.text('Price: \$10.00');
      final locationFinder = find.text('Location: Temasek');
      final descFinder = find.text('Description: Nice fan');
      final userFinder = find.text('Created by: another user');
      expect(titleFinder, findsOneWidget);
      expect(priceFinder, findsOneWidget);
      expect(locationFinder, findsOneWidget);
      expect(descFinder, findsOneWidget);
      expect(userFinder, findsOneWidget);
    });
  });
}