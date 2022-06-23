import 'package:dropshare/chat/message.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String uid = '12345';
  String message = 'unit test';
  DateTime date = DateTime.fromMillisecondsSinceEpoch(1655892770060);

  final firestore = FakeFirebaseFirestore();
  firestore.collection('search_listings')
      .doc('listingId')
      .collection('chats')
      .doc('docId')
      .set({
        'sentBy': uid,
        'message': message,
        'time': date
      });

  test('Get message from Firestore', () async {
    final snapshot = await firestore.collection('search_listings')
        .doc('listingId')
        .collection('chats')
        .doc('docId').get();

    Message m = Message.fromFirestore(snapshot);
    expect(m.sentBy, uid);
    expect(m.message, message);
    expect(m.date, '22 Jun 2022');
    expect(m.time, '06:12 pm');
  });
}