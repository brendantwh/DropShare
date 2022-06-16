import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  void _manageListingActionSheet(BuildContext context, Listing listing) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Manage your listing'),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
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
                    children: const [
                      Icon(CupertinoIcons.trash, color: CupertinoColors.destructiveRed),
                      Text('Delete listing')
                    ],
                  ),
                ),
                CupertinoActionSheetAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                      _sellStatusAlertDialog(context, listing);
                    },
                    child: const Text('Mark as unsold')
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
                    children: const [
                      Icon(CupertinoIcons.trash, color: CupertinoColors.destructiveRed),
                      Text('Delete listing')
                    ],
                  ),
                ),
                CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'create', arguments: listing);
                    },
                    child: const Text('Edit listing')
                ),
                CupertinoActionSheetAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                      _sellStatusAlertDialog(context, listing);
                    },
                    child: const Text('Mark as sold')
                )
              ],
      ),
    );
  }

  void _deleteListingAlertDialog(BuildContext context, Listing listing) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Delete listing?'),
        content: const Text('Are you sure you want to delete this listing?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'userpage');
              listing.hide();
            },
            child: const Text('Yes'),
          )
        ],
      ),
    );
  }

  void _sellStatusAlertDialog(BuildContext context, Listing listing) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text('Mark as ${listing.sold ? 'unsold' : 'sold'}?'),
        content: Text('Are you sure you want to mark this listing as ${listing.sold ? 'unsold' : 'sold'}?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              listing.sold ? listing.unsell() : listing.sell();
              Navigator.pushReplacementNamed(context, 'userpage');
            },
            child: const Text('Yes'),
          )
        ],
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
                            listing.report();
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
              child: const Icon(CupertinoIcons.flag, color: CupertinoColors.destructiveRed),
            )
          ])
        ),
        child: SafeArea(
            child: Container(
                margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: ListView(
                  children: [
                    Text(listing.title,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 24),
                    Image.network(listing.imageURL),
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

                      bool userIsSeller = listing.uid == me.uid;

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
                    })
                  ],
                )
            )
        )
    );
  }
}
