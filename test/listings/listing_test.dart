import 'package:dropshare/listings/listing.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final firestore = FakeFirebaseFirestore();

  test('Listing adds to and retrieves from Firestore correctly', () async {
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

    final snapshot = await firestore.collection('search_listings')
        .orderBy('time', descending: true)
        .get();

    Listing fromFs = Listing.fromFirestore(snapshot.docs.first);

    expect(fromFs.title, l.title);
    expect(fromFs.description, l.description);
    expect(fromFs.price, l.price);
    expect(fromFs.location, l.location);
    expect(fromFs.uid, l.uid);
  });
}