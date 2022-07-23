import 'package:flutter/cupertino.dart';

import '../user/dsuser.dart';
import 'listing.dart';
import 'listinghelper.dart';

class ListingGridSearch extends StatefulWidget {
  const ListingGridSearch({Key? key, required this.searchResults, this.padding = EdgeInsets.zero}) : super(key: key);

  final List<dynamic> searchResults;
  final EdgeInsets padding;

  @override
  State<ListingGridSearch> createState() => _ListingGridSearchState();
}

class _ListingGridSearchState extends State<ListingGridSearch> {
  @override
  Widget build(BuildContext context) {
    Iterable<Widget> list = widget.searchResults.map<Widget>((res) {
      Listing l = Listing.fromJson(res['document']);
      if (l.visible) {
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
      } else {
        return Container();
      }
    });

    return GridView.count(
        padding: widget.padding,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        crossAxisCount: 2,
        childAspectRatio: 0.78,
        children: list.whereType<GestureDetector>().toList()
    );
  }
}
