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
        : NumberFormat.currency(locale: 'en_SG', symbol: '\$').format(listing.price);
    

    final CollectionReference chat = FirebaseFirestore.instance
        .collection('listings')
        .doc(listing.docId)
        .collection('chats')
        .doc(buyerId)
        .collection('messages');

    final messages = chat.orderBy('time', descending: true).snapshots();

    final String currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
            middle: Text('Chat')
        ),
        child: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      decoration: const BoxDecoration(
                          color: CupertinoColors.secondarySystemBackground,
                          border: Border(
                              bottom: BorderSide(width: 1, color: CupertinoColors.opaqueSeparator))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  listing.title,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)
                              ),
                              const SizedBox(height: 7),
                              Text(price, style: const TextStyle(fontSize: 16))
                            ],
                          ),
                          const SizedBox(
                            child: Text('Picture')
                          )
                        ],
                      )
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: messages,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text("Loading");
                            }

                            return ListView.separated(
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 5);
                                },
                                shrinkWrap: true,
                                reverse: true,
                                padding: const EdgeInsets.only(top: 10),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  Message msg = Message.fromFirestore(snapshot.data!.docs[index] as DocumentSnapshot<Map<String, dynamic>>);
                                  bool isMine = msg.sentBy == currentUid;

                                  return Bubble(msg: msg, isMine: isMine);
                                }
                            );
                          })
                    )
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: CupertinoTextField(
                        decoration: BoxDecoration(
                          border: Border.all(color: CupertinoColors.opaqueSeparator),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        controller: messageController,
                        onChanged: (text) {
                          // see TextEditingController listener for problem
                          // setState(() { });
                        },
                        placeholder: 'Message',
                        padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
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
                                      if (messageController.text.isEmpty) {
                                        print('No');
                                      } else {
                                        Message msg = Message(
                                            sentBy: currentUid,
                                            message: messageController.text.trim(),
                                            time: ''
                                        );
                                        ChatHelper.manageChat(listing.docId!, buyerId);
                                        chat.add(msg.toFirestore());
                                        messageController.clear();
                                      }
                                    }
                                    : null,
                                child: const Icon(CupertinoIcons.arrow_up_circle_fill, size: 32)
                            )
                        ),
                        suffixMode: OverlayVisibilityMode.always,
                      )
                  )
                ],
            )
        ),
    );
  }
}
