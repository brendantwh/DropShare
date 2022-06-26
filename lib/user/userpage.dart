import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/authentication.dart';
import '../listings/listinggridfs.dart';
import 'dsuser.dart';

class Userpage extends StatefulWidget {
  const Userpage({Key? key}) : super(key: key);

  @override
  State<Userpage> createState() => _UserpageState();
}

class _UserpageState extends State<Userpage> {
  final userListings = FirebaseFirestore.instance
      .collection('search_listings')
      .orderBy('time', descending: true)
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
      .snapshots();
  final Authentication auth = Authentication();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: Text('Your account', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
            trailing: Wrap(spacing: 10, children: <Widget>[
              GestureDetector(
                  key: const Key('sign out button'),
                  onTap: () {
                    showCupertinoDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                              title: Text(
                                  'Sign out',
                                  style: TextStyle(
                                      fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily
                                  )
                              ),
                              content: Text(
                                  'Are you sure you want to sign out?',
                                  style: TextStyle(
                                      fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily
                                  )
                              ),
                              actions: <CupertinoDialogAction>[
                                CupertinoDialogAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                      'No',
                                      style: TextStyle(
                                          fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily
                                      )
                                  ),
                                ),
                                CupertinoDialogAction(
                                  key: const Key('final sign out'),
                                  isDefaultAction: true,
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
                                  child: Text('Sign out',
                                      style: TextStyle(
                                          color: CupertinoColors
                                              .destructiveRed,
                                          fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily
                                      )
                                  ),
                                )
                              ]);
                        });
                  },
                  child: const Icon(
                      CupertinoIcons.person_crop_circle_badge_xmark)),
              // to access Typesense admin client
              // GestureDetector(
              //     onTap: () {
              //       Navigator.pushNamed(context, 'typesenseConfig');
              //     },
              //     child: const Icon(
              //         CupertinoIcons.settings))
            ])
        ),
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 15, 20, 34),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: const UsernameText('You are ', ''),
              ),
              Flexible(
                  child: ListingGridFs(stream: userListings)
              )
            ],
          ),
        ));
  }
}
