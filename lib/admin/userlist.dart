import 'package:flutter/cupertino.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
            middle: Text('User list')
        ),
        child: SafeArea(
            minimum: const EdgeInsets.fromLTRB(20, 15, 20, 34),
            child: Center(
              child: Column(
                children: [
                  Text('User list here')
                ],
              ),
            )
        )
    );
  }
}
