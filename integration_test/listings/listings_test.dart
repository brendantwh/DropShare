import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropshare/listings/create.dart';
import 'package:dropshare/listings/indiv.dart';
import 'package:dropshare/listings/listing.dart';
import 'package:dropshare/listings/listinggridfs.dart';
import 'package:dropshare/listings/listingspage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Remember to firebase emulators:start --import ./firebase-data (--export-on-exit)
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  Widget app = CupertinoApp(
      initialRoute: 'listings',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case 'listings':
            return CupertinoPageRoute(builder: (_) => const ListingsPage(), settings: settings);
          case 'create':
            return CupertinoPageRoute(builder: (_) => const Create(), settings: settings);
          case 'indiv':
            return CupertinoPageRoute(builder: (context) => const IndivListing(), settings: settings);
        }
      }
  );

  Listing l = Listing(
      title: 'Google Home mini',
      time: DateTime.fromMillisecondsSinceEpoch(1655892770060),
      price: 0,
      location: 0,
      description: 'description',
      uid: 'BSIx3o7X0nXlIjcDVxHw9pGTv7w7',
      visible: true,
      sold: false,
      imageURL: 'http://127.0.0.1:9199/v0/b/dropshare-b6a08.appspot.com/o/Image%2Fgoogle_home_mini.jpg?alt=media&token=90848b27-9db0-4e6c-94bc-325d974e2d3f',
      reported: false);

  setUpAll(() async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.settings = const Settings(host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
    FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseAuth.instance.signInWithEmailAndPassword(email: 'drop@share.com', password: 'dropshare');
  });

  group('Listings page shows touch points', () {
    testWidgets('Listings page shows search button', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      expect(find.text('Search'), findsOneWidget);
    });

    testWidgets('Listings page shows ListingGridFs', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      expect(find.byType(ListingGridFs), findsOneWidget);
    });

    testWidgets('Listings page shows listing', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final listingFinder = find.descendant(of: find.byType(ListingGridFs), matching: find.byType(ClipRRect));
      expect(listingFinder, findsNWidgets(2));
    });

    testWidgets('Listings page can access create page', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      final createFinder = find.descendant(of: find.byType(GestureDetector), matching: find.byIcon(CupertinoIcons.add));
      await tester.tap(createFinder);
      await tester.pumpAndSettle();
      expect(find.text('Create listing'), findsOneWidget);
    });
  });

  group('Listings page shows correct listing details', () {
    testWidgets('Listing has correct title', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      final listingFinder = find.descendant(of: find.byType(ListingGridFs), matching: find.byType(ClipRRect));
      final titleFinder = find.descendant(of: listingFinder, matching: find.text(l.title));
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('Listing passes correct details to indiv page', (tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      final listingsFinder = find.descendant(of: find.byType(ListingGridFs), matching: find.byType(ClipRRect));
      expect(listingsFinder, findsNWidgets(2));
      
      final miniFinder = find.descendant(of: listingsFinder, matching: find.text(l.title));
      expect(miniFinder, findsOneWidget);
      await tester.tap(miniFinder);
      await tester.pumpAndSettle(const Duration(milliseconds: 250));

      final titleFinder = find.text(l.title);
      final priceFinder = find.text('Price: Free');
      final locationFinder = find.text('Location: Eusoff');
      final descFinder = find.text('Description: description');
      final userFinder = find.text('Created by: firebase emulator');
      expect(titleFinder, findsOneWidget);
      expect(priceFinder, findsOneWidget);
      expect(locationFinder, findsOneWidget);
      expect(descFinder, findsOneWidget);
      expect(userFinder, findsOneWidget);
    });
  });
}