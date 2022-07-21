import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../listings/listing.dart';
import '../user/dsuser.dart';
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
        .collection('search_listings')
        .doc(listingId)
        .collection('chats')
        .orderBy('lastUpdated', descending: true)
        .snapshots();

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: Text('Chat list', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily))
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
                  String buyerId = document.id;
                  return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'chat', arguments: ChatHelper(listing, buyerId));
                      },
                      child: FutureBuilder(
                          future: DsUser(buyerId).getFull(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text("Loading");
                            }
                            DsUser buyer = snapshot.data as DsUser;

                            final doc = document as DocumentSnapshot<Map<String, dynamic>>;
                            String latestMsg = doc.data()!['latestMsg'];
                            Widget subheader;
                            TextStyle subStyle = const TextStyle(
                                fontSize: 16,
                                color: CupertinoColors.secondaryLabel,
                                fontWeight: FontWeight.w500
                            );

                            if (latestMsg.isEmpty || latestMsg == 'image') {
                              subheader = Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 6,
                                children: [
                                  const Icon(
                                      CupertinoIcons.photo_fill,
                                      size: 20,
                                      color: CupertinoColors.secondaryLabel
                                  ),
                                  Text(
                                      'Image',
                                      style: subStyle
                                  )
                                ],
                              );
                            } else {
                              subheader = Text(
                                  latestMsg,
                                  style: subStyle
                              );
                            }

                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: CupertinoColors.quaternarySystemFill),
                              margin: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                              padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
                              child: Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: [
                                  Wrap(
                                    direction: Axis.horizontal,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 8,
                                    children: [
                                      const Icon(CupertinoIcons.person_alt_circle, size: 40),
                                      Wrap(
                                          direction: Axis.vertical,
                                          spacing: 6,
                                          children: [
                                            Text(buyer.username,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18
                                                )),
                                            subheader
                                          ]
                                      )
                                    ],
                                  ),
                                  const Icon(CupertinoIcons.chevron_right, size: 20, color: CupertinoColors.secondaryLabel)
                                ],
                              )
                            );
                          }
                      )
                  );
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
