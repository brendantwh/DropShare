import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  
  final freeItems = FirebaseFirestore.instance
      .collection('search_listings')
      .where('price', isEqualTo: 0)
      .snapshots();

  int index = 0;

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
                        Navigator.pushNamed(context, 'userpage');
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        style: ButtonStyle(side: MaterialStateProperty.all(const BorderSide(color: CupertinoColors.activeBlue, style: BorderStyle.solid))),
                        onPressed: () {
                          setState(() {
                            index = 0;
                          });
                        }, 
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Align(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                              ),
                            ),
                            Text('All listings')
                          ]),
                      ),
                      OutlinedButton(
                        style: ButtonStyle(side: MaterialStateProperty.all(const BorderSide(color: CupertinoColors.activeBlue, style: BorderStyle.solid))),
                        onPressed: () {
                          setState(() {
                            index = 1;
                          });
                        }, 
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Align(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                              ),
                            ),
                            Text('Free Listings')
                          ]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25,),
                  index == 0 ?
                  Flexible(
                      child: ListingGridFs(stream: items, showMySold: false)
                  ) 
                  : 
                  Flexible(
                      child: ListingGridFs(stream: freeItems, showMySold: false)
                  ) ,
                ],
              ),
            )
        )
    );
  }
}
