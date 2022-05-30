import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String title;
  final DateTime time;
  final num price;
  final int location;
  final String? description;

  Listing(
      {required this.title,
      required this.time,
      required this.price,
      required this.location,
      this.description});

  factory Listing.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Listing(
        title: data?['title'] ?? '',
        time: (data?['time'] as Timestamp).toDate(),
        price: data?['price'].toDouble(),
        location: data?['location'].toInt(),
        description: data?['description'] ?? ''
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'time': Timestamp.fromDate(time),
      'price': price,
      'location': location,
      'description': description
    };
  }
}