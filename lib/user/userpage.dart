import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/authentication.dart';
import '../listings/listinggrid.dart';

class Userpage extends StatefulWidget {
  const Userpage({Key? key}) : super(key: key);

  @override
  State<Userpage> createState() => _UserpageState();
}

class _UserpageState extends State<Userpage> {
  final userListings = FirebaseFirestore.instance
      .collection('listings')
      .orderBy('time', descending: true)
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
      .snapshots();
  final Authentication auth = Authentication();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: const Text('Your account'),
            trailing: GestureDetector(
              onTap: () {
                showCupertinoDialog(
                    barrierDismissible: true,
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
        ),
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 0),
          child: ListingGrid(stream: userListings),
        ));
  }
}
