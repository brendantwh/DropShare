import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'listing.dart';

class ListingGrid extends StatefulWidget {
  const ListingGrid({Key? key, required this.stream}) : super(key: key);

  final Stream<QuerySnapshot<Map<String, dynamic>>> stream;

  @override
  State<ListingGrid> createState() => _ListingGridState();
}

class _ListingGridState extends State<ListingGrid> {
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
                      child: ListView(
                        children: [
                          Text('${l.title} ${l.sold ? '(sold)' : ''}'),
                          Image.network(l.imageURL, scale: 0.5,)
                        ],
                      )
                  );
                } else {
                  return Container();
                }
              }).toList());
        });
  }
}
