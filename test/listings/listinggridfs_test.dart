import 'package:dropshare/listings/listinggridfs.dart';
import 'package:dropshare/listings/listing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

void main() {
  final firestore = FakeFirebaseFirestore();
  Listing l = Listing(
      title: 'Title',
      time: DateTime.fromMillisecondsSinceEpoch(1655892770060),
      price: 0,
      location: 0,
      description: 'description',
      uid: 'uid',
      visible: true,
      sold: false,
      imageURL: 'imageURL',
      reported: false);
  firestore.collection('search_listings').add(l.toFirestore());

  var stream = firestore
      .collection('search_listings')
      .snapshots();
  
  Widget app = CupertinoApp(
      home: ListingGridFs(stream: stream)
  );

  testWidgets('Listing appears on grid', (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    final finder = find.descendant(of: find.byType(ListingGridFs), matching: find.byType(ClipRRect));
    expect(finder, findsOneWidget);
  });
  
  testWidgets('Listing has correct title', (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    final listingFinder = find.descendant(of: find.byType(ListingGridFs), matching: find.byType(ClipRRect));
    final finder = find.descendant(of: listingFinder, matching: find.text('Title'));
    expect(finder, findsOneWidget);
  });

  testWidgets('Listing has image', (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    final listingFinder = find.descendant(of: find.byType(ListingGridFs), matching: find.byType(ClipRRect));
    final finder = find.descendant(of: listingFinder, matching: find.byType(OptimizedCacheImage));
    expect(finder, findsOneWidget);
  });
}