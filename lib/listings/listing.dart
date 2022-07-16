import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart'; 

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
  List imageURL;
  bool reported;

  Listing(
      {required this.title,
      required this.time,
      required this.price,
      required this.location,
      this.description,
      required this.uid,
      this.visible = true,
      this.sold = false,
      this.docId = '',
      required this.imageURL,
      this.reported = false});

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
        sold: data?['sold'] ?? false,
        imageURL: data?['imageURL'] ?? '',
        reported: data?['reported'] ?? false);
  }

  factory Listing.fromJson(
      Map<String, dynamic> data) {
    return Listing(
        title: data['title'],
        time: DateTime.fromMillisecondsSinceEpoch(data['time'] * 1000),
        price: data['price'].toDouble(),
        location: data['location'].toInt(),
        description: data['description'],
        uid: data['uid'],
        docId: data['id'],
        visible: data['visible'],
        sold: data['sold'],
        imageURL: data['imageURL'],
        reported: data['reported']);
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
      'sold': sold,
      'imageURL': imageURL,
      'reported': reported
    };
  }

  void update(
      {required String title,
      required num price,
      required int location,
      required String description,
      List? imageURL}) {
    this.title = title;
    this.price = price;
    this.location = location;
    this.description = description;
    FirebaseFirestore.instance.collection('search_listings').doc(docId).update({
      'title': title,
      'price': price,
      'location': location,
      'description': description,
      'imageURL': imageURL ?? this.imageURL
    });
  }

  void report() {
    FirebaseFirestore.instance
        .collection('search_listings')
        .doc(docId)
        .update({'reported': true});
  }

  void unreport() {
    FirebaseFirestore.instance
        .collection('search_listings')
        .doc(docId)
        .update({'reported': false});
  }

  void sell() {
    FirebaseFirestore.instance
        .collection('search_listings')
        .doc(docId)
        .update({'sold': true});
  }

  void unsell() {
    FirebaseFirestore.instance
        .collection('search_listings')
        .doc(docId)
        .update({'sold': false});
  }

  void hide() {
    FirebaseFirestore.instance
        .collection('search_listings')
        .doc(docId)
        .update({'visible': false});
  }

  void show() {
    FirebaseFirestore.instance
        .collection('search_listings')
        .doc(docId)
        .update({'visible': true});
  }

  void delete() {
    FirebaseFirestore.instance.collection('search_listings').doc(docId).delete();
  }

  OptimizedCacheImage showImage({required bool square, required int ind}) {
    if (square) {
      return OptimizedCacheImage(
        imageUrl: imageURL[ind],
        imageBuilder: (context, image) =>
            AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: image
                      )
                  ),
                )
            ),
      );
    } else {
      return OptimizedCacheImage(
        imageUrl: imageURL[ind],
        placeholder: (context, url) => const CupertinoActivityIndicator(),
        errorWidget: (context, url, error) => Text(error),
      );
    }
  }

  Swiper showImageSwiper() {
    return Swiper(
      itemCount: imageURL.length,
      itemBuilder: (context, index) {
        return PinchZoomImage(
          image: showImage(square: true, ind: index), 
          zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
          hideStatusBarWhileZooming: true,
        );
      },
      viewportFraction: 0.8,
      scale: 0.9,
      layout: SwiperLayout.DEFAULT,
      itemHeight: 400,
      itemWidth: 300,
      control: const SwiperControl(color: Colors.black, iconNext: null, iconPrevious: null),
      pagination: const SwiperPagination(builder: SwiperPagination.dots),
    );
  }

  ClipRRect showListing() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(children: [
          showImage(square: true, ind: 0),
          Align(
              alignment: Alignment.bottomCenter,
              child: ClipRect(
                child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
                    child: Container(
                        width: double.infinity,
                        height: 32,
                        padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                        decoration: const BoxDecoration(
                          color: Color(0x98F2F2F7),
                        ),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(title,
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15.5),
                              overflow: TextOverflow.ellipsis,
                            )
                        )
                    )
                ),
              )
          ),
          sold
              ? Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
                        child: Container(
                            alignment: Alignment.center,
                            width: 100,
                            height: 50,
                            padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                            decoration: const BoxDecoration(
                              color: Color(0x98F2F2F7),
                            ),
                            child: const Text('SOLD',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26, color: Color(0xFFFE3126)),
                            )
                        )
                    ),
                  )
                )
              : Container()
      ])
    );
  }
}
