import 'package:flutter/cupertino.dart';

import '../user/dsuser.dart';
import 'listing.dart';
import 'listinghelper.dart';

class ListingGridSearch extends StatefulWidget {
  const ListingGridSearch({Key? key, required this.searchResults}) : super(key: key);

  final List<dynamic> searchResults;

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
            child: l.showListing()
        );
      } else {
        return Container();
      }
    });

    return GridView.count(
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        crossAxisCount: 2,
        children: list.whereType<GestureDetector>().toList()
    );
  }
}
