import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../user/dsuser.dart';
import 'listinggridfs.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({Key? key}) : super(key: key);

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
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
                middle: Text('DropShare', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
                trailing: Wrap(spacing: 10, children: <Widget>[
                  GestureDetector(
                      key: const Key('create'),
                      onTap: () {
                        Navigator.pushNamed(context, 'create');
                      },
                      child: const Icon(CupertinoIcons.add)),
                  GestureDetector(
                      key: const Key('userpage'),
                      onTap: () {
                        DsUser.getMine().then((user) {
                          Navigator.pushNamed(context, 'userpage', arguments: user);
                        });
                      },
                      child: const Icon(
                          CupertinoIcons.person_crop_circle))
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
