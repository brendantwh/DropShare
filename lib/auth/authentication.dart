import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  Future signUp({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
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
    FirebaseFirestore.instance.collection('users').doc(user.uid).set({'username': username, 'email': user.email});
  }


  static void showErrorDialog(BuildContext context, String content) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
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
                  Authentication().user == null
                      ? Navigator.pushNamedAndRemoveUntil(context, 'login', (Route<dynamic> route) => false)
                      : Navigator.pushNamedAndRemoveUntil(context, 'listings', (Route<dynamic> route) => false);
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
}