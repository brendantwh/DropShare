import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../user/dsuser.dart';
import 'listing.dart';
import 'listinghelper.dart';

class ListingGridFs extends StatefulWidget {
  const ListingGridFs({Key? key, required this.stream, required this.showMySold, this.padding = EdgeInsets.zero}) : super(key: key);

  final Stream<QuerySnapshot<Map<String, dynamic>>> stream;
  final bool showMySold;
  final EdgeInsets padding;

  @override
  State<ListingGridFs> createState() => _ListingGridFsState();
}

class _ListingGridFsState extends State<ListingGridFs> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: widget.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          if (snapshot.data!.size == 0) {
            return const Center(
                child: Text(
                    'There\'s nothing here!',
                    style: TextStyle(
                        color: CupertinoDynamicColor.withBrightness(
                            color: CupertinoColors.secondaryLabel,
                            darkColor: CupertinoColors.systemGrey2)
                    ),
                    textScaleFactor: 0.87
                )
            );
          }

          return GridView.count(
              padding: widget.padding,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              crossAxisCount: 2,
              childAspectRatio: 0.78,
              children: snapshot.data!.docs
                  .map<Widget>((DocumentSnapshot document) {
                Listing l = Listing.fromFirestore(document
                as DocumentSnapshot<Map<String, dynamic>>);

                if (!l.visible || (!widget.showMySold && l.sold)) {
                  return Container();
                } else {
                  return GestureDetector(
                      onTap: () {
                        DsUser.getMine().then((me) {
                          DsUser(l.uid).getFull().then((seller) {
                            Navigator.pushNamed(context, 'indiv',
                                arguments: ListingHelper(l, me, seller));
                          });
                        });
                      },
                      child: l.showListingFull()
                  );
                }
              }).whereType<GestureDetector>().toList());
        });
  }
}
