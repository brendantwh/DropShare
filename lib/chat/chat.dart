import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../listings/listing.dart';
import '../listings/report.dart';
import '../locations/location.dart';
import 'chathelper.dart';
import 'message.dart';
import 'bubble.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController messageController = TextEditingController();
  bool enableSend = false;

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // can't use this together with streambuilder
    // keeps refreshing the stream
    // todo: find workaround
    // messageController.addListener(() {
    //   setState(() {
    //     enableSend = (messageController.text.isEmpty) ? false : true;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    final helper = ModalRoute.of(context)?.settings.arguments as ChatHelper;
    final Listing listing = helper.listing;
    final String buyerId = helper.buyerId;

    int meetLocation = listing.location;
    bool locationSetStateCalled = false;
    DateTime? meetTime;
    bool timeSetStateCalled = false;

    final String price = listing.price == 0
        ? 'Free'
        : NumberFormat.currency(locale: 'en_SG', symbol: '\$')
            .format(listing.price);
    final int location = listing.location;

    final CollectionReference chat = FirebaseFirestore.instance
        .collection('search_listings')
        .doc(listing.docId)
        .collection('chats')
        .doc(buyerId)
        .collection('messages');

    final messages = chat.orderBy('time', descending: true).snapshots();

    final String currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    List<String> dates = <String>[];

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          trailing: Report(listing: listing)
      ),
      child: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              child: Stack(children: [
                Container(
                    height: double.infinity,
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: StreamBuilder<QuerySnapshot>(
                        stream: messages,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("Loading");
                          }

                          dates.clear();
                          for (var message in snapshot.data!.docs) {
                            Message msg = Message.fromFirestore(message
                                as DocumentSnapshot<Map<String, dynamic>>);
                            dates.add(msg.date!);
                          }
                          dates.add('show');  // for top bubble to always show datestamp

                          return ListView.separated(
                              separatorBuilder: (context, index) {
                                return const SizedBox(height: 4);
                              },
                              shrinkWrap: true,
                              reverse: true,
                              padding: const EdgeInsets.only(top: 10),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Message msg = Message.fromFirestore(snapshot
                                        .data!.docs[index]
                                    as DocumentSnapshot<Map<String, dynamic>>);
                                bool isMine = msg.sentBy == currentUid;

                                bool newDate;

                                if (dates[index] != dates[index + 1]) {
                                  newDate = true;
                                } else {
                                  newDate = false;
                                }
                                Container dateStamp = Container(
                                    margin: const EdgeInsets.fromLTRB(0, 14, 0, 5),
                                    child: Text(dates[index],
                                      style: const TextStyle(
                                          color: CupertinoColors.secondaryLabel,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600)
                                  )
                                );

                                if (index == snapshot.data!.docs.length - 1 &&
                                    index == 0) {
                                  // only one message, show date stamp
                                  return Column(
                                    children: [
                                      dateStamp,
                                      Bubble(msg: msg, isMine: isMine),
                                      const SizedBox(height: 56)
                                    ],
                                  );
                                } else if (index ==
                                    snapshot.data!.docs.length - 1) {
                                  // first chat bubble at the top, always show date stamp
                                  return Column(
                                    children: [
                                      const SizedBox(height: 72 + 32 - 14),
                                      dateStamp,
                                      Bubble(msg: msg, isMine: isMine)
                                    ],
                                  );
                                } else if (index == 0) {
                                  // last chat bubble at bottom
                                  return Column(
                                    children: [
                                      newDate
                                          ? dateStamp
                                          : const SizedBox.shrink(),
                                      Bubble(msg: msg, isMine: isMine),
                                      const SizedBox(height: 56),
                                    ],
                                  );
                                } else {
                                  // everything else in between
                                  return Column(
                                    children: [
                                      newDate
                                          ? dateStamp
                                          : const SizedBox.shrink(),
                                      Bubble(msg: msg, isMine: isMine),
                                    ],
                                  );
                                }
                              });
                        })),
                Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        ClipRect(
                          child: BackdropFilter(
                              filter: ui.ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
                              child: Container(
                                  height: 72,
                                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  decoration: const BoxDecoration(
                                      color: Color(0xEBF2F2F7),
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 0.3,
                                              color: CupertinoColors
                                                  .opaqueSeparator))),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(listing.title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600),
                                              textScaleFactor: 1.14,
                                          ),
                                          const SizedBox(height: 8),
                                          Wrap(
                                            direction: Axis.horizontal,
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            children: [
                                              const Icon(CupertinoIcons.money_dollar_circle_fill, size: 20, color: Color(0xFF86888C)),
                                              const SizedBox(width: 6),
                                              Text(price,
                                                  textScaleFactor: 0.90),
                                              const SizedBox(width: 30),
                                              const Icon(CupertinoIcons.house_fill, size: 20, color: Color(0xFF86888C)),
                                              const SizedBox(width: 6),
                                              Text(Location.values[location].locationName,
                                                  textScaleFactor: 0.90)
                                            ],
                                          )
                                        ],
                                      ),
                                      Container(
                                          padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                                          child: listing.showImage(square: true, ind: 0)
                                      )
                                    ],
                                  ))),
                        ),
                        ClipRect(
                          child: BackdropFilter(
                              filter: ui.ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
                              child: Container(
                                  height: 32,
                                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  decoration: const BoxDecoration(
                                      color: Color(0xEBF6F6FB),
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 0.3,
                                              color: CupertinoColors
                                                  .opaqueSeparator))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        spacing: 6,
                                        children: [
                                          const Icon(CupertinoIcons.location, size: 16, color: CupertinoColors.secondaryLabel),
                                          StatefulBuilder(
                                            builder: (context, innerSetState) {
                                              helper.getMeetLocation().then((loc) {
                                                if (mounted && !locationSetStateCalled) {
                                                  innerSetState(() {
                                                    meetLocation = loc;
                                                    locationSetStateCalled = true;
                                                  });
                                                }
                                              });
                                              return PullDownButton(
                                                  position: PullDownMenuPosition.under,
                                                  itemBuilder: (context) {
                                                    return Location.values
                                                        .map((loc) => PullDownMenuItem(
                                                        title: loc.locationName,
                                                        textStyle: TextStyle(
                                                          color: CupertinoColors.black,
                                                          fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily,
                                                        ),
                                                        onTap: () {
                                                          meetLocation = loc.index;
                                                          helper.manageMeetLocation(meetLocation);
                                                        })
                                                    ).toList();
                                                  },
                                                  buttonBuilder: (context, showMenu) {
                                                    return Container(
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: CupertinoColors.tertiarySystemFill),
                                                      height: 22,
                                                      child: CupertinoButton(
                                                          padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                                                          onPressed: showMenu,
                                                          child: Text(Location.values[meetLocation].locationName, style: const TextStyle(fontSize: 14.5),)
                                                      ),
                                                    );
                                                  }
                                              );
                                            }
                                          )
                                        ],
                                      ),
                                      Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        spacing: 6,
                                        children: [
                                          StatefulBuilder(
                                            builder: (context, innerSetState) {
                                              helper.getMeetTime().then((dt) {
                                                if (mounted && !timeSetStateCalled) {
                                                  innerSetState(() {
                                                    meetTime = dt;
                                                    timeSetStateCalled = true;
                                                  });
                                                }
                                              });

                                              return Container(
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: CupertinoColors.tertiarySystemFill),
                                                height: 22,
                                                child: CupertinoButton(
                                                    padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                                                    onPressed: () async {
                                                      DateTime? dt = await showCupertinoModalPopup<DateTime>(
                                                          context: context,
                                                          builder: (BuildContext context) => WillPopScope(
                                                              onWillPop: () async {
                                                                Navigator.pop(context, meetTime);
                                                                return true;
                                                              },
                                                              child: Container(
                                                                height: 216,
                                                                padding: const EdgeInsets.only(top: 6.0),
                                                                margin: EdgeInsets.only(
                                                                  bottom: MediaQuery.of(context).viewInsets.bottom,
                                                                ),
                                                                color: CupertinoColors.systemBackground.resolveFrom(context),
                                                                child: SafeArea(
                                                                  top: false,
                                                                  child: CupertinoDatePicker(
                                                                    initialDateTime: meetTime,
                                                                    use24hFormat: false,
                                                                    onDateTimeChanged: (DateTime newTime) {
                                                                      innerSetState(() {
                                                                        meetTime = newTime;
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              )
                                                          )
                                                      );
                                                      if (dt != null) {
                                                        helper.manageMeetTime(dt);
                                                      }
                                                    },
                                                    child: Text(meetTime == null ? 'Not set' : DateFormat('hh:mm a, dd MMM').format(meetTime!), style: const TextStyle(fontSize: 14.5))
                                                )
                                              );
                                            },
                                          ),
                                          const Icon(CupertinoIcons.time, size: 16, color: CupertinoColors.secondaryLabel)
                                        ],
                                      )
                                    ],
                                  ))),
                        )
                      ],
                    )
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipRect(
                        child: BackdropFilter(
                            filter: ui.ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                            child: Container(
                                decoration: const BoxDecoration(
                                    color: Color(0xEBFFFFFF)),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: CupertinoTextField(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: CupertinoColors.opaqueSeparator),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  controller: messageController,
                                  onChanged: (text) {
                                    // see TextEditingController listener for problem
                                    // setState(() { });
                                  },
                                  placeholder: 'Message',
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 5, 5),
                                  minLines: 1,
                                  maxLines: 5,
                                  textAlignVertical: TextAlignVertical.bottom,
                                  suffix: SizedBox(
                                      height: 32,
                                      width: 32,
                                      child: CupertinoButton(
                                          padding: const EdgeInsets.all(0),
                                          onPressed: // enableSend
                                              true
                                                  ? () {
                                                      if (messageController
                                                          .text.isEmpty) {
                                                        print('No');
                                                      } else {
                                                        Message msg = Message(
                                                            sentBy: currentUid,
                                                            message:
                                                                messageController
                                                                    .text
                                                                    .trim(),
                                                            time: '');
                                                        helper.manageChat();
                                                        chat.add(
                                                            msg.toFirestore());
                                                        messageController
                                                            .clear();
                                                      }
                                                    }
                                                  : null,
                                          child: const Icon(
                                              CupertinoIcons
                                                  .arrow_up_circle_fill,
                                              size: 32))),
                                  suffixMode: OverlayVisibilityMode.always,
                                )))))
              ])),
        ],
      )),
    );
  }
}