import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../listings/listing.dart';
import 'chathelper.dart';

class Chatlist extends StatefulWidget {
  const Chatlist({Key? key}) : super(key: key);

  @override
  State<Chatlist> createState() => _ChatlistState();
}

class _ChatlistState extends State<Chatlist> {
  @override
  Widget build(BuildContext context) {
    final Listing listing = ModalRoute.of(context)?.settings.arguments as Listing;
    final listingId = listing.docId;

    final chats = FirebaseFirestore.instance
        .collection('listings')
        .doc(listingId)
        .collection('chats')
        .snapshots();

    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
            middle: Text('Chat list')
        ),
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 0),
          child: StreamBuilder<QuerySnapshot>(
            stream: chats,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading');
              }

              if (snapshot.data!.size == 0) {
                return const Text('No chats');
              }

              return ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                  // Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  String buyerId = document.id;
                  return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'chat', arguments: ChatHelper(listing, buyerId));
                      },
                      child: Text(buyerId));
                })
                    .toList()
                    .cast()
              );
            },
          )
        )
    );
  }
}
