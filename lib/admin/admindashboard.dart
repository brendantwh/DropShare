import 'package:flutter/cupertino.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
            middle: Text('Admin Dashboard')
        ),
        child: SafeArea(
            minimum: const EdgeInsets.fromLTRB(20, 15, 20, 34),
            child: Center(
              child: Column(
                children: [
                  CupertinoButton(
                      child: const Text('Typesense functions'),
                      onPressed: () => Navigator.pushNamed(context, 'typesenseConfig')
                  ),
                  CupertinoButton(
                      child: const Text('View all users'),
                      onPressed: () => Navigator.pushNamed(context, 'userlist')
                  ),
                  CupertinoButton(
                      child: const Text('View all reported listings'),
                      onPressed: () => Navigator.pushNamed(context, 'reportlist')
                  ),
                  CupertinoButton(
                      child: const Text('Swap to normal user view'),
                      onPressed: () => Navigator.pushReplacementNamed(context, 'listings')
                  ),
                  CupertinoButton(
                      child: const Text('Swap to admin view'),
                      onPressed: () => Navigator.pushReplacementNamed(context, 'adminHome')
                  ),
                ],
              ),
            )
        )
    );
  }
}
