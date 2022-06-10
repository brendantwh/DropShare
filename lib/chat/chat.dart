import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../listings/listing.dart';
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
    final String buyerId = helper.buyerId;
    final Listing listing = helper.listing;
    final String price = listing.price == 0
        ? 'Free'
        : NumberFormat.currency(locale: 'en_SG', symbol: '\$')
            .format(listing.price);

    final CollectionReference chat = FirebaseFirestore.instance
        .collection('listings')
        .doc(listing.docId)
        .collection('chats')
        .doc(buyerId)
        .collection('messages');

    final messages = chat.orderBy('time', descending: true).snapshots();

    final String currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    List<String> dates = <String>[];

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          trailing: GestureDetector(
              onTap: () {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                          title: const Text('Report this listing?'),
                          content: const Text(
                              'Are you sure you want to report this listing?'),
                          actions: <CupertinoDialogAction>[
                            CupertinoDialogAction(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('No'),
                            ),
                            CupertinoDialogAction(
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Report',
                                    style: TextStyle(
                                        color: CupertinoColors.destructiveRed)))
                          ]);
                    });
              },
              child: const Text(
                'Report',
                style: TextStyle(color: CupertinoColors.destructiveRed),
              ))),
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
                                return const SizedBox(height: 5);
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

                                Text dateStamp = Text(dates[index],
                                    style: const TextStyle(
                                        color: CupertinoColors.secondaryLabel,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600));

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
                                      const SizedBox(height: 72),
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
                    child: ClipRect(
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
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 7),
                                      Text(price,
                                          style: const TextStyle(fontSize: 16))
                                    ],
                                  ),
                                  const SizedBox(child: Text('Picture'))
                                ],
                              ))),
                    )),
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
                                                        ChatHelper.manageChat(
                                                            listing.docId!,
                                                            buyerId);
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
