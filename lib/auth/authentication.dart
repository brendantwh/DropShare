import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../user/dsuser.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  Future signUp({required String username, required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password)
          .then((res) async {
            await user!.updateDisplayName(username);
            user.sendEmailVerification();
          }
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  void createUsername(String username) {
    FirebaseFirestore.instance.collection('users').doc(user.uid).set({'username': username, 'email': user.email, 'admin': false, 'emailVerified': false});
  }

  void updateEmailVerification(bool verified) {
    FirebaseFirestore.instance.collection('users').doc(user.uid).update({'emailVerified': verified});
  }


  static void showErrorDialog(BuildContext context, String content) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        key: const Key('email empty'),
        title: Text(
            'Error',
            style: TextStyle(
                fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily
            )
        ),
        content: Text(content),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
                'Ok',
                style: TextStyle(
                    fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily
                )
            ),
          )
        ],
      ),
    );
  }

  static void showSuccessDialog(BuildContext context, String action) {
    showCupertinoModalPopup<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => WillPopScope(
          onWillPop: () async => false,
          child: CupertinoAlertDialog(
            key: const Key('Success'),
            title: Text(
                'Success',
                style: TextStyle(
                    fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily
                )
            ),
            content: Text(
                'Successfully $action',
                style: TextStyle(
                    fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily
                )
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  List<String> testAccts = ['drop@share.com', 'chat@test.com', 'drop2@share.com'];  // to allow test accts through
                  Authentication().user == null
                      ? Navigator.pushNamedAndRemoveUntil(context, 'login', (Route<dynamic> route) => false)
                      : Authentication().user!.emailVerified ||
                      testAccts.contains(Authentication().user.email)  // to allow test accts through
                      ? DsUser.getMine().then((user) => Navigator.pushNamedAndRemoveUntil(context, 'home', (Route<dynamic> route) => false, arguments: user))
                      : Navigator.pushNamedAndRemoveUntil(context, 'verify', (Route<dynamic> route) => false);
                },
                child: Text(
                    'Ok',
                    style: TextStyle(
                        fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily
                    )
                ),
              )
            ],
          ))
    );
  }

  static void authRedirect(BuildContext context) {
    List<String> testAccts = ['drop@share.com', 'chat@test.com', 'drop2@share.com'];

    Authentication().user == null
        ? Navigator.pushNamedAndRemoveUntil(context, 'login', (Route<dynamic> route) => false)
        : Authentication().user!.emailVerified ||
        testAccts.contains(Authentication().user.email)  // to allow test accts through
        ? DsUser.getMine().then((user) => Navigator.pushNamedAndRemoveUntil(context, 'home', (Route<dynamic> route) => false, arguments: user))
        : Navigator.pushNamedAndRemoveUntil(context, 'verify', (Route<dynamic> route) => false);
  }
}