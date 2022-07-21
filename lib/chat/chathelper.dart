import 'package:cloud_firestore/cloud_firestore.dart';

import '../listings/listing.dart';

class ChatHelper {
  final Listing listing;
  final String buyerId;
  late int meetLocation;
  DateTime? meetTime;

  ChatHelper(this.listing, this.buyerId) {
    meetLocation = listing.location;
  }

  Future<DateTime?> getMeetTime() async {
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection('search_listings')
        .doc(listing.docId)
        .collection('chats')
        .doc(buyerId).get();

    try {
      meetTime = (data['meetTime'] as Timestamp).toDate();
    } catch (error) {
      meetTime = null;
    }

    return meetTime;
  }

  Future<int> getMeetLocation() async {
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection('search_listings')
        .doc(listing.docId)
        .collection('chats')
        .doc(buyerId).get();

    try {
      int receivedLocation = data['meetLocation'];
      if (meetLocation != receivedLocation) {
        meetLocation = receivedLocation;
      }
    } catch (error) {
      meetLocation = listing.location;
    }

    return meetLocation;
  }

  void manageChat(String msg) {
    final DocumentReference chat = FirebaseFirestore.instance
        .collection('search_listings')
        .doc(listing.docId)
        .collection('chats')
        .doc(buyerId);

    chat.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        chat.update({
          'lastUpdated': Timestamp.fromDate(DateTime.now()),
          'latestMsg': msg
        });
      } else {
        chat.set({
          'lastUpdated': Timestamp.fromDate(DateTime.now()),
          'latestMsg': msg
        });
      }
    });
  }

  void manageMeetLocation(int location) {
    final DocumentReference chat = FirebaseFirestore.instance
        .collection('search_listings')
        .doc(listing.docId)
        .collection('chats')
        .doc(buyerId);

    chat.get().then((docSnapshot) {
      meetLocation = location;
      if (docSnapshot.exists) {
        chat.update({'meetLocation': location});
      } else {
        chat.set({'meetLocation': location});
      }
    });
  }

  void manageMeetTime(DateTime dateTime) {
    final DocumentReference chat = FirebaseFirestore.instance
        .collection('search_listings')
        .doc(listing.docId)
        .collection('chats')
        .doc(buyerId);

    chat.get().then((docSnapshot) {
      meetTime = dateTime;
      if (docSnapshot.exists) {
        chat.update({'meetTime': Timestamp.fromDate(dateTime)});
      } else {
        chat.set({'meetTime': Timestamp.fromDate(dateTime)});
      }
    });
  }
}