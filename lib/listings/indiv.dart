import 'unreport.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../chat/chathelper.dart';
import '../user/dsuser.dart';
import 'listing.dart';
import 'report.dart';
import '../locations/location.dart';

class IndivListing extends StatefulWidget {
  const IndivListing({Key? key}) : super(key: key);

  @override
  State<IndivListing> createState() => _IndivListingState();
}

class _IndivListingState extends State<IndivListing> {
  void _manageListingActionSheet(BuildContext context, Listing listing) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Manage your listing', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
        ),
        actions: listing.sold
            ? <CupertinoActionSheetAction>[
                CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteListingAlertDialog(context, listing);
                  },
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    children: [
                      const Icon(CupertinoIcons.trash, color: CupertinoColors.destructiveRed),
                      Text('Delete listing', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily))
                    ],
                  ),
                ),
                CupertinoActionSheetAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                      _sellStatusAlertDialog(context, listing);
                    },
                    child: Text('Mark as unsold', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily))
                )
              ]
            : <CupertinoActionSheetAction>[
                CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteListingAlertDialog(context, listing);
                  },
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    children: [
                      const Icon(CupertinoIcons.trash, color: CupertinoColors.destructiveRed),
                      Text('Delete listing', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily))
                    ],
                  ),
                ),
                CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'create', arguments: listing);
                    },
                    child: Text('Edit listing', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily))
                ),
                CupertinoActionSheetAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                      _sellStatusAlertDialog(context, listing);
                    },
                    child: Text('Mark as sold', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily))
                )
              ],
      ),
    );
  }

  void _deleteListingAlertDialog(BuildContext context, Listing listing) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text('Delete listing?', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
        content: Text('Are you sure you want to delete this listing?', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              listing.hide();
              Navigator.pop(context);
            },
            child: Text('Yes', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
          )
        ],
      ),
    );
  }

  void _sellStatusAlertDialog(BuildContext context, Listing listing) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text('Mark as ${listing.sold ? 'unsold' : 'sold'}?', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
        content: Text('Are you sure you want to mark this listing as ${listing.sold ? 'unsold' : 'sold'}?', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              if (listing.sold) {
                listing.unsell();
                listing.sold = false;
              } else {
                listing.sell();
                listing.sold = true;
              }
              Navigator.pop(context);
              Navigator.pushNamed(
                  context,
                  'indiv',
                  arguments: listing
              );
            },
            child: Text('Yes', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
          )
        ],
      ),
    );
  }

  void _adminActionSheet(BuildContext context, Listing listing) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('Manage this listing', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _deleteListingAlertDialog(context, listing);
            },
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                const Icon(CupertinoIcons.trash, color: CupertinoColors.destructiveRed),
                Text('Delete listing', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily))
              ],
            ),
          ),
          CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'create', arguments: listing);
              },
              child: Text('Edit listing', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily))
          ),
        ]
      ),
    );
  }

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
    bool reported = listing.reported;

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: Report(listing: listing),
        ),
        child: Container(
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 34),
            child: ListView(
              children: [
                mounted ? Container(child: listing.showImageSwiper(), height: 300,) : Container(),
                const SizedBox(height: 24),
                Text(listing.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                Text('Price: $price'),
                Text('Location: $location'),
                Text('Time: $time'),
                const SizedBox(height: 20),
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

                  bool userIsSeller = listing.uid == me.uid;
                  bool userIsAdmin = me.admin;

                  if (userIsAdmin) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Unreport(listing: listing),
                        CupertinoButton(
                            color: const Color(0xfff2f4f5),
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            onPressed: () => _adminActionSheet(context, listing),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 10,
                              children: const [
                                Icon(CupertinoIcons.settings_solid, color: CupertinoColors.activeBlue),
                                Text(
                                    'Admin actions',
                                    style: TextStyle(
                                        color: CupertinoColors.activeBlue
                                    ))
                              ],
                            )
                        )
                      ],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                            color: const Color(0xffd9e6fa),
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            onPressed: listing.sold ? null : () {
                              userIsSeller
                                  ? Navigator.pushNamed(context, 'chatlist', arguments: listing) // I am the seller
                                  : Navigator.pushNamed(context, 'chat', arguments: ChatHelper(listing, me.uid)); // I am the buyer
                            },
                            child: listing.sold
                                ? const Text('Sold', style: TextStyle(color: CupertinoColors.systemGrey))
                                : userIsSeller
                                ? Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 10,
                              children: const [
                                Icon(CupertinoIcons.chat_bubble_2_fill, color: CupertinoColors.activeBlue),
                                Text('View chats',
                                    style: TextStyle(
                                        color: CupertinoColors.activeBlue,
                                        fontWeight: FontWeight.w500)
                                )
                              ],
                            )
                                : Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 10,
                              children: const [
                                Icon(CupertinoIcons.mail_solid, color: CupertinoColors.activeBlue),
                                Text('Message',
                                    style: TextStyle(
                                        color: CupertinoColors.activeBlue,
                                        fontWeight: FontWeight.w500)
                                )
                              ],
                            )
                        ),
                        userIsSeller
                            ? CupertinoButton(
                            color: const Color(0xfff2f4f5),
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            onPressed: () => _manageListingActionSheet(context, listing),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 10,
                              children: const [
                                Icon(CupertinoIcons.settings_solid, color: CupertinoColors.activeBlue),
                                Text(
                                    'Manage listing',
                                    style: TextStyle(
                                        color: CupertinoColors.activeBlue
                                    ))
                              ],
                            ))
                            : Container()
                      ],
                    );
                  }
                })
              ],
            )
        )
    );
  }
}
