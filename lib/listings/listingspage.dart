import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'listinggrid.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({Key? key}) : super(key: key);

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  final items = FirebaseFirestore.instance
      .collection('listings')
      .orderBy('time', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                automaticallyImplyLeading: false,
                middle: const Text('DropShare'),
                trailing: Wrap(spacing: 10, children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'create');
                      },
                      child: const Icon(CupertinoIcons.add)),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'userpage');
                      },
                      child: const Icon(
                          CupertinoIcons.person_crop_circle))
                ])
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 34),
              child: ListingGrid(stream: items)
            )
        )
    );
  }
}
