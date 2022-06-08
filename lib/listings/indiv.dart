import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../chat/chathelper.dart';
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
    final Listing listing = ModalRoute.of(context)?.settings.arguments as Listing;
    final String time = DateFormat('hh:mm a, dd MMM yyyy').format(listing.time);
    final String location = Location.values[listing.location].locationName;
    final String price = listing.price == 0
        ? 'Free'
        : NumberFormat.currency(locale: 'en_SG', symbol: '\$').format(listing.price);
    final String creator = listing.uid;
    final String currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

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
                  Text('Description: ${listing.description}'),
                  Text('Created by: $creator'),
                  const SizedBox(height: 60),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      child: CupertinoButton(
                          color: const Color(0xffd9e6fa),
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          onPressed: () {
                            listing.uid == currentUid
                            ? Navigator.pushNamed(context, 'chatlist', arguments: listing)
                            : Navigator.pushNamed(context, 'chat', arguments: ChatHelper(listing, currentUid));
                          },
                          child: Text(
                              listing.uid == currentUid
                              ? 'View chats'
                              : 'Message',
                              style: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w500)
                          )
                      )
                    )
                  )
                ],
              )
          )
        )
    );
  }
}
