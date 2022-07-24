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
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: Text('Your account', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily), textScaleFactor: 1),
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
            ])
        ),
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 15, 20, 34),
          child: Column(
            children: [
              // to access admin dashboard
              StatefulBuilder(builder: (context, innerSetState) {
                DsUser.getMine().then((DsUser user) {
                  if (mounted) {
                    innerSetState(() {
                      isAdmin = user.admin;
                    });
                  }
                });
                if (isAdmin) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: Wrap(
                      spacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const UsernameText('You are ', ''),
                        Container(
                          height: 20,
                          child: CupertinoButton(
                              color: const Color(0xfff2f4f5),
                              padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                              onPressed: () => Navigator.pushNamed(context, 'adminDash'),
                              child: const Text(
                                  'Admin Dashboard',
                                  style: TextStyle(
                                      color: CupertinoColors.activeBlue,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14
                                  )
                              )
                          )
                        )
                      ],
                    )
                  );
                } else {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: const UsernameText('You are ', ''),
                  );
                }
              }),
              Flexible(
                  child: ListingGridFs(stream: userListings, showMySold: true)
              )
            ],
          ),
        ));
  }
}
