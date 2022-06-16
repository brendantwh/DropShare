import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  String title;
  final DateTime time;
  num price;
  int location;
  String? description;
  final String uid;
  bool visible;
  bool sold;
  String docId;

  Listing(
      {required this.title,
      required this.time,
      required this.price,
      required this.location,
      this.description,
      required this.uid,
      this.visible = true,
      this.sold = false,
      this.docId = ''
      }
      );

  factory Listing.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Listing(
        title: data?['title'] ?? '',
        time: (data?['time'] as Timestamp).toDate(),
        price: data?['price'].toDouble(),
        location: data?['location'].toInt(),
        description: data?['description'] ?? '',
        uid: data?['uid'] ?? 'Unknown',
        docId: snapshot.id,
        visible: data?['visible'] ?? false,
        sold: data?['sold'] ?? false
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'time': Timestamp.fromDate(time),
      'price': price,
      'location': location,
      'description': description,
      'uid': uid,
      'visible': visible,
      'sold': sold
    };
  }

  void update({required String title, required num price, required int location, required String description}) {
    this.title = title;
    this.price = price;
    this.location = location;
    this.description = description;
    FirebaseFirestore.instance
        .collection('listings')
        .doc(docId)
        .update({
      'title': title,
      'price': price,
      'location': location,
      'description': description
    });
  }

  void sell() {
    FirebaseFirestore.instance
        .collection('listings')
        .doc(docId)
        .update({'sold': true});
  }

  void unsell() {
    FirebaseFirestore.instance
        .collection('listings')
        .doc(docId)
        .update({'sold': false});
  }

  void hide() {
    FirebaseFirestore.instance
        .collection('listings')
        .doc(docId)
        .update({'visible': false});
  }

  void show() {
    FirebaseFirestore.instance
        .collection('listings')
        .doc(docId)
        .update({'visible': true});
  }

  void delete() {
    FirebaseFirestore.instance
        .collection('listings')
        .doc(docId)
        .delete();
  }
}