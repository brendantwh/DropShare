import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'listing.dart';
import '../locations/location.dart';

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
    final String price = listing.price == 0
        ? 'Free'
        : NumberFormat.currency(locale: 'en_SG', symbol: '\$').format(listing.price);

    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Listing')
        ),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child:
              ListView(
                children: [
                  Text(
                      listing.title,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600)
                  ),
                  const SizedBox(height: 24),
                  Text('Price: $price'),
                  Text('Location: $location'),
                  Text('Time: $time'),
                  const SizedBox(height: 24),
                  Text('Description: ${listing.description}')
                ],
              )
          )
        )
    );
  }
}
