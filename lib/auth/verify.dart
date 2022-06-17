import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'authentication.dart';

class Verify extends StatefulWidget {
  const Verify({Key? key}) : super(key: key);

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final Authentication auth = Authentication();
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              CupertinoActivityIndicator(),
              SizedBox(height:20),
              Text('Please check your NUS email to verify your account before using DropShare.',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center
              )
            ],
          )
        )
    );
  }

  Future<void> checkEmailVerified() async {
    await auth.user.reload();
    List<String> testAccts = ['3NjC4BBW9eYvlr0JHVQUqLmKYGc2', 'w10kedwEvJdqpQWaGZQghwvngjE3'];  // to allow test accts through
    if (auth.user.emailVerified ||
        testAccts.contains(auth.user.uid)) {  // to allow test accts through
      timer.cancel();
      if (mounted) {
        Authentication.showSuccessDialog(context, 'verified account');
      }
    }
  }
}
