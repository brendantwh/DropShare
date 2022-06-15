import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String title;
  final DateTime time;
  final num price;
  final int location;
  final String? description;
  final String imageURL;
  String firestoreid = '';
  bool reported;

  Listing(
      {required this.title,
      required this.time,
      required this.price,
      required this.location,
      this.description,
      required this.imageURL,
      required this.reported});

  factory Listing.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Listing(
        title: data?['title'] ?? '',
        time: (data?['time'] as Timestamp).toDate(),
        price: data?['price'].toDouble(),
        location: data?['location'].toInt(),
        description: data?['description'] ?? '',
        imageURL: data?['imageURL'] ?? '',
        reported: data?['reported']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'time': Timestamp.fromDate(time),
      'price': price,
      'location': location,
      'description': description,
      'imageURL': imageURL,
      'reported': reported
    };
  }
  
  void setfirestoredid(String id) {
    this.firestoreid = id;
  }
}