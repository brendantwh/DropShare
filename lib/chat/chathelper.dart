import 'package:cloud_firestore/cloud_firestore.dart';

import '../listings/listing.dart';

class ChatHelper {
  final Listing listing;
  final String buyerId;

  ChatHelper(this.listing, this.buyerId);

  static void manageChat(String listingId, String buyerId) {
    final DocumentReference chat = FirebaseFirestore.instance
        .collection('search_listings')
        .doc(listingId)
        .collection('chats')
        .doc(buyerId);

    chat.get().then((docSnapshot) {
    if (docSnapshot.exists) {
      chat.update({'lastUpdated': Timestamp.fromDate(DateTime.now())});
    } else {
      chat.set({'lastUpdated': Timestamp.fromDate(DateTime.now())});
    }
    });
  }
}