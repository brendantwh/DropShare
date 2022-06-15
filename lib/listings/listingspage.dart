import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'listing.dart';
import '../auth/authentication.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({Key? key}) : super(key: key);

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  final items = FirebaseFirestore.instance
      .collection('listings')
      .orderBy('time', descending: true)
      .snapshots();
  final Authentication auth = Authentication();
  String firestoreid = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                automaticallyImplyLeading: false,
                middle: const Text('DropShare'),
                trailing: Wrap(spacing: 10, children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'create');
                      },
                      child: const Icon(CupertinoIcons.add)),
                  GestureDetector(
                      onTap: () {
                        showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                  title: const Text('Sign out'),
                                  content: const Text(
                                      'Are you sure you want to sign out?'),
                                  actions: <CupertinoDialogAction>[
                                    CupertinoDialogAction(
                                      isDefaultAction: true,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('No'),
                                    ),
                                    CupertinoDialogAction(
                                      onPressed: () async {
                                        try {
                                          await auth.signOut().then((result) {
                                            if (result == null) {
                                              Authentication.showSuccessDialog(
                                                  context, 'signed out');
                                            } else {
                                              Authentication.showErrorDialog(
                                                  context, result);
                                            }
                                          });
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: const Text('Sign out',
                                          style: TextStyle(
                                              color: CupertinoColors
                                                  .destructiveRed)),
                                    )
                                  ]);
                            });
                      },
                      child: const Icon(
                          CupertinoIcons.person_crop_circle_badge_xmark))
                ])
            ),
            child: SafeArea(
                minimum: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: items,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }

                      return GridView.count(
                          crossAxisCount: 2,
                          children: snapshot.data!.docs
                              .map<Widget>((DocumentSnapshot document) {
                            Listing l = Listing.fromFirestore(document
                                as DocumentSnapshot<Map<String, dynamic>>);
                            return GestureDetector(
                                onTap: () {
                                  firestoreid = document.id;
                                  l.setfirestoredid(firestoreid);
                                  Navigator.pushNamed(context, 'indiv',
                                      arguments: l
                                    );
                                },
                                child: ListView(
                                  children: [
                                    Text(l.title),
                                    Image.network(l.imageURL, scale: 0.5,)
                                  ],
                                )
                              );
                          }).toList());
                    })
            )
        )
    );
  }
}
