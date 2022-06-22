import 'package:flutter/cupertino.dart';

import 'listing.dart';

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
              Navigator.pushNamed(context, 'indiv',
                  arguments: l);
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
