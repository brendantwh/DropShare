import 'package:flutter/cupertino.dart';
import 'listing.dart';
import 'package:dropshare/locations/location.dart';
import 'package:intl/intl.dart';

class IndivListing extends StatefulWidget {
  const IndivListing({Key? key}) : super(key: key);

  @override
  State<IndivListing> createState() => _IndivListingState();
}

class _IndivListingState extends State<IndivListing> {
  @override
  Widget build(BuildContext context) {
    final listing = ModalRoute.of(context)?.settings.arguments as Listing;
    final String time = DateFormat('hh:mm a, dd MMM yyyy').format(listing.time);
    final String location = Location.values[listing.location].locationName;
    final String price = NumberFormat.currency(locale: 'en_SG', symbol: '\$').format(listing.price);

    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Listing')
        ),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child:
              ListView(
                children: [
                  Text('Item: ${listing.title}'),
                  Text('Price: $price'),
                  Text('Location: $location'),
                  Text('Time: $time'),
                ],
              )

          )
        )
    );
  }
}
