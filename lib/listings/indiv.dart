import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'listing.dart';
import '../locations/location.dart';
import 'listingspage.dart';

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
    final String imageURL = listing.imageURL;
    final String firestoreid = listing.firestoreid;
    bool reported = listing.reported;

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Listing'),
          trailing: Wrap(spacing: 10, children: <Widget>[
            GestureDetector(
              onTap: () {
                showCupertinoDialog(
                  context: context, 
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: const Text('Report this listing?'),
                      content: const Text('Are you sure you want to report this listing?'),
                      actions: <CupertinoDialogAction>[
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        CupertinoDialogAction(
                          onPressed: () {
                            final doc = FirebaseFirestore.instance.collection('listings').doc(firestoreid);
                            doc.update({
                              'reported': true,
                            });
                            listing.reported == true;
                            Navigator.pop(context);
                            showCupertinoDialog(
                              context: context, 
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: const Text('Listing reported'),
                                  content: const Text('This listing has been reported and will be reviewed by the DropShare team.'),
                                  actions: <CupertinoDialogAction>[
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Close'))
                                  ]
                                );
                              });
                        }, 
                        child: const Text('Report', style: TextStyle(color: CupertinoColors.destructiveRed)),
                        )
                      ]);
                  });
              },
              child: const Icon(CupertinoIcons.flag),
            )
          ])
        ),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: ListView(children: [
                  Text(
                      listing.title,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600)
                  ),
                  const SizedBox(height: 24),
                  Image.network(imageURL),
                  const SizedBox(height: 24),
                  Text('Price: $price'),
                  Text('Location: $location'),
                  Text('Time: $time'),
                  const SizedBox(height: 24),
                  Text('Description: ${listing.description}')
                ])
          )
        )
    );
  }
}
