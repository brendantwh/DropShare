import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'listing.dart';

class ListingGridFs extends StatefulWidget {
  const ListingGridFs({Key? key, required this.stream}) : super(key: key);

  final Stream<QuerySnapshot<Map<String, dynamic>>> stream;

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

          return GridView.count(
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              crossAxisCount: 2,
              children: snapshot.data!.docs
                  .map<Widget>((DocumentSnapshot document) {
                Listing l = Listing.fromFirestore(document
                as DocumentSnapshot<Map<String, dynamic>>);

                if (l.visible) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'indiv',
                            arguments: l);
                      },
                      child: l.showListing()
                  );
                } else {
                  return Container();
                }
              }).whereType<GestureDetector>().toList());
        });
  }
}
