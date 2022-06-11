import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../chat/chathelper.dart';
import '../user/dsuser.dart';
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
    final Listing listing =
        ModalRoute.of(context)?.settings.arguments as Listing;
    final String time = DateFormat('hh:mm a, dd MMM yyyy').format(listing.time);
    final String location = Location.values[listing.location].locationName;
    final String price = listing.price == 0
        ? 'Free'
        : NumberFormat.currency(locale: 'en_SG', symbol: '\$')
            .format(listing.price);
    DsUser me = DsUser.placeholder;

    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(middle: Text('Listing')),
        child: SafeArea(
            child: Container(
                margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: ListView(
                  children: [
                    Text(listing.title,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 24),
                    Text('Price: $price'),
                    Text('Location: $location'),
                    Text('Time: $time'),
                    const SizedBox(height: 24),
                    Text('Description: ${listing.description}'),
                    UsernameText('Created by: ', '', user: DsUser(listing.uid)),
                    const SizedBox(height: 60),
                    StatefulBuilder(builder: (context, innerSetState) {
                      DsUser.getMine().then((DsUser user) {
                        if (mounted) {
                          innerSetState(() {
                            me = user;
                          });
                        }
                      });

                      return Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                              child: CupertinoButton(
                                  color: const Color(0xffd9e6fa),
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  onPressed: () {
                                    listing.uid == me.uid
                                        ? Navigator.pushNamed(
                                            context, 'chatlist',
                                            arguments:
                                                listing) // I am the seller
                                        : Navigator.pushNamed(context, 'chat',
                                            arguments: ChatHelper(listing,
                                                me.uid)); // I am the buyer
                                  },
                                  child: Text(
                                      listing.uid == me.uid
                                          ? 'View chats'
                                          : 'Message',
                                      style: const TextStyle(
                                          color: CupertinoColors.systemBlue,
                                          fontWeight: FontWeight.w500))
                              )
                          )
                      );
                    })
                  ],
                )
            )
        )
    );
  }
}
