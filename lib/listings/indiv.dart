import 'listinghelper.dart';
import 'unreport.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../chat/chathelper.dart';
import '../user/dsuser.dart';
import 'listing.dart';
import 'report.dart';
import '../locations/location.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:io';

class IndivListing extends StatefulWidget {
  const IndivListing({Key? key}) : super(key: key);

  @override
  State<IndivListing> createState() => _IndivListingState();
}

class _IndivListingState extends State<IndivListing> {
  void _manageListingActionSheet(BuildContext context, ListingHelper helper) {
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
        actions: helper.listing.sold
            ? <CupertinoActionSheetAction>[
                CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteListingAlertDialog(context, helper);
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
                      _sellStatusAlertDialog(context, helper);
                    },
                    child: Text('Mark as unsold', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily))
                )
              ]
            : <CupertinoActionSheetAction>[
                CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteListingAlertDialog(context, helper);
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
                      Navigator.pushNamed(context, 'create', arguments: helper);
                    },
                    child: Text('Edit listing', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily))
                ),
                CupertinoActionSheetAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                      _sellStatusAlertDialog(context, helper);
                    },
                    child: Text('Mark as sold', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily))
                )
              ],
      ),
    );
  }

  void _deleteListingAlertDialog(BuildContext context, ListingHelper helper) {
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
              helper.listing.hide();
              Navigator.pushReplacementNamed(context, 'userpage', arguments: helper.me);
            },
            child: Text('Yes', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
          )
        ],
      ),
    );
  }

  void _sellStatusAlertDialog(BuildContext context, ListingHelper helper) {
    Listing listing = helper.listing;

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
                  arguments: helper
              );
            },
            child: Text('Yes', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
          )
        ],
      ),
    );
  }

  void _adminActionSheet(BuildContext context, ListingHelper helper) {
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
              _deleteListingAlertDialog(context, helper);
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
                Navigator.pushNamed(context, 'create', arguments: helper);
              },
              child: Text('Edit listing', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily))
          ),
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final helper = ModalRoute.of(context)?.settings.arguments as ListingHelper;

    final Listing listing = helper.listing;
    final DsUser me = helper.me;
    final DsUser seller = helper.seller;

    // final String time = DateFormat('hh:mm a, dd MMM yyyy').format(listing.time);
    final String relativeTime = timeago.format(listing.time);
    final String location = Location.values[listing.location].fullName;
    final String price = listing.price == 0
        ? 'Free'
        : NumberFormat.currency(locale: 'en_SG', symbol: '\$')
            .format(listing.price);

    bool userIsAdmin = me.admin;
    bool adminView = me.adminView;
    bool userIsSeller = listing.uid == me.uid;

    Widget actions;
    if (userIsAdmin && adminView) {
      actions = Unreport(helper: helper);
    } else {
      actions = CupertinoButton(
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
      );
    }

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: (userIsAdmin && adminView)
              ? GestureDetector(
                  onTap: () => _adminActionSheet(context, helper),
                  child: Icon(CupertinoIcons.gear),
                )
              : userIsSeller
              ? GestureDetector(
                  onTap: () => _manageListingActionSheet(context, helper),
                  child: Icon(CupertinoIcons.settings_solid),
                )
              : Report(helper: helper),
        ),
        child: Column(
          children: [
            SizedBox(height: Platform.isIOS ? 90 : 68),
            mounted
                ? Container(
                    child: AspectRatio(aspectRatio: 1, child: listing.showImageSwiper()),
                  )
                : Container(),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(listing.title,
                          style: const TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w600)),
                      Container(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(relativeTime, style: TextStyle(fontSize: 15))
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        direction: Axis.vertical,
                        spacing: 18,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10,
                            children: [
                              const Icon(CupertinoIcons.money_dollar_circle_fill, size: 20, color: Color(0xFF86888C)),
                              Text(price, style: TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10,
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Icon(
                                    listing.location >= 0 && listing.location <= 5
                                        ? CupertinoIcons.house_fill
                                        : CupertinoIcons.building_2_fill,
                                    size: 20,
                                    color: CupertinoColors.secondaryLabel,
                                  )
                              ),
                              Text(location),
                            ],
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10,
                            children: [
                              Icon(CupertinoIcons.person_crop_circle_fill, size: 20, color: Color(0xFF86888C)),
                              Text(seller.username)
                            ],
                          )
                        ],
                      ),
                      actions
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 18, bottom: 18),
                    decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: CupertinoColors.separator))
                    ),
                  ),
                  Text(listing.description!)
                ],
              ),
            )
          ],
        )
    );
  }
}
