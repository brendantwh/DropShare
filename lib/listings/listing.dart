import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String title;
  final DateTime time;
  final num price;
  final int location;

  Listing(
      {required this.title,
      required this.time,
      required this.price,
      required this.location});

  factory Listing.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Listing(
        title: data?['title'] as String,
        time: (data?['time'] as Timestamp).toDate(),
        price: data?['price'].toDouble(),
        location: data?['location'].toInt());
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'time': time,
      'price': price,
      'location': location,
    };
  }
}
//
// Listing _listingFromJson(Map<String, dynamic> json) {
//   return Listing(
//     json['title'] as String,
//     time: (json['time'] as Timestamp).toDate(),
//     price: json['price'] as double,
//     location: json['location'] as int,
//   );
// }
//
// Map<String, dynamic> _listingToJson(Listing instance) =>
//     <String, dynamic> {
//       'title': instance.title,
//       'time': instance.time,
//       'price': instance.price,
//       'location': instance.location,
//     };
//
