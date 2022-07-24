import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/authentication.dart';
import '../listings/listinggridfs.dart';
import 'dsuser.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final userListings = FirebaseFirestore.instance
      .collection('search_listings')
      .orderBy('time', descending: true)
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
      .snapshots();
  final Authentication auth = Authentication();

  @override
  Widget build(BuildContext context) {
    final DsUser user = ModalRoute.of(context)?.settings.arguments as DsUser;

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: Text('Your profile', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily), textScaleFactor: 1),
            trailing: GestureDetector(
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
                                      Authentication.authRedirect(context);
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
        ),
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 15, 20, 34),
          child: Column(
            children: [
              user.profileCard(context),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(bottom: 10),
                  child: const Text(
                      'YOUR LISTINGS',
                      style: TextStyle(fontWeight: FontWeight.w500, color: CupertinoColors.systemGrey, fontSize: 14),
                  )
              ),
              Flexible(
                  child: ListingGridFs(stream: userListings, showMySold: true)
              )],
          ),
        ));
  }
}
