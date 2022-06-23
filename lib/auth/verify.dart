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
            children: [
              const CupertinoActivityIndicator(),
              const SizedBox(height: 40),
              const Text('Please check your NUS email to verify your account before using DropShare.',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center
              ),
              const SizedBox(height: 40),
              CupertinoButton(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                color: const Color(0xfff2f4f5),
                onPressed: () async {
                  timer.cancel();
                  await auth.signOut().then((result) {
                    if (result == null) {
                      Authentication.showSuccessDialog(
                          context, 'signed out');
                    } else {
                      Authentication.showErrorDialog(
                          context, result);
                    }
                  });
                },
                child:  Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: const [
                    Icon(
                        CupertinoIcons.person_crop_circle_badge_xmark,
                        color: CupertinoColors.activeBlue,
                        size: 26
                    ),
                    Text(
                        'Sign out',
                        style: TextStyle(
                            fontSize: 15.5,
                            color: CupertinoColors.activeBlue
                        )
                    )
                  ],
                )
              )
            ],
          )
        )
    );
  }

  Future<void> checkEmailVerified() async {
    await auth.user.reload();
    List<String> testAccts = ['drop@share.com', 'chat@test.com'];  // to allow test accts through
    if (auth.user.emailVerified ||
        testAccts.contains(auth.user.email)) {  // to allow test accts through
      timer.cancel();
      if (mounted) {
        Authentication.showSuccessDialog(context, 'verified account');
      }
    }
  }
}
