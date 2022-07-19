import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../listings/listinggridfs.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final items = FirebaseFirestore.instance
      .collection('search_listings')
      .orderBy('time', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                automaticallyImplyLeading: false,
                middle: Text('[ADMIN] DropShare', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
                trailing: Wrap(spacing: 10, children: <Widget>[
                  GestureDetector(
                      key: const Key('adminDash'),
                      onTap: () {
                        Navigator.pushNamed(context, 'adminDash');
                      },
                      child: const Icon(
                          CupertinoIcons.settings))
                ])
            ),
            child: SafeArea(
              minimum: const EdgeInsets.fromLTRB(20, 15, 20, 34),
              child: Column(
                children: [
                  CupertinoButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'search');
                      },
                      child: const Text('Search')
                  ),
                  Flexible(
                      child: ListingGridFs(stream: items, showMySold: false)
                  )
                ],
              ),
            )
        )
    );
  }
}
