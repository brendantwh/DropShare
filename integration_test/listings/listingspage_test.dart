import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropshare/listings/create.dart';
import 'package:dropshare/listings/listing.dart';
import 'package:dropshare/listings/listinggridfs.dart';
import 'package:dropshare/listings/listingspage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

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
        }
      }
  );

  Listing l = Listing(
      title: 'Title',
      time: DateTime.fromMillisecondsSinceEpoch(1655892770060),
      price: 0,
      location: 0,
      description: 'description',
      uid: 'uid',
      visible: true,
      sold: false,
      imageURL: 'http://127.0.0.1:9199/v0/b/dropshare-b6a08.appspot.com/o/Images%2Fgoogle_home_mini.jpg?alt=media&token=24065415-3a19-47f7-a31c-51af99523734',
      reported: false);

  setUpAll(() async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.settings = const Settings(host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
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
      await tester.idle();
      await tester.pump(Duration.zero);

      final listingFinder = find.descendant(of: find.byType(ListingGridFs), matching: find.byType(ClipRRect));
      expect(listingFinder, findsOneWidget);
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
      await tester.pumpAndSettle();
      await tester.idle();
      await tester.pump(Duration.zero);

      final listingFinder = find.descendant(of: find.byType(ListingGridFs), matching: find.byType(ClipRRect));
      final titleFinder = find.descendant(of: listingFinder, matching: find.text(l.title));
      expect(titleFinder, findsOneWidget);
    });
  });
}