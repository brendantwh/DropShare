import 'package:flutter/cupertino.dart';

import 'dsuser.dart';

class UserTypeRedirect extends StatefulWidget {
  const UserTypeRedirect({Key? key}) : super(key: key);

  @override
  State<UserTypeRedirect> createState() => _UserTypeRedirectState();
}

class _UserTypeRedirectState extends State<UserTypeRedirect> {
  @override
  void initState() {
    DsUser.getMine().then((user) {
      if (user.admin) {
        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.pushNamedAndRemoveUntil(context, 'adminHome', (Route<dynamic> route) => false);
        });
      } else if (user.emailVerified) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushNamedAndRemoveUntil(context, 'listings', (Route<dynamic> route) => false);
        });
      } else {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushNamedAndRemoveUntil(context, 'verify', (Route<dynamic> route) => false);
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Center(
          child: Image.asset('assets/icon/transparent.png', scale: 0.5)
        )
    );
  }
}
