import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../user/dsuser.dart';
import 'package:flutter/material.dart';
import 'listinggridfs.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({Key? key}) : super(key: key);

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  final items = FirebaseFirestore.instance //index 0
      .collection('search_listings')
      .orderBy('time', descending: true)
      .snapshots();

  final freeItems = FirebaseFirestore.instance //index 1
      .collection('search_listings')
      .where('price', isEqualTo: 0)
      .snapshots();

  final hallsItems = FirebaseFirestore.instance
      .collection('search_listings')
      .where('location', whereIn: [0,1,2,3,4,5])
      .snapshots();

  final rcItems = FirebaseFirestore.instance
      .collection('search_listings')
      .where('location', whereIn: [7,8,9,10,11])
      .snapshots();

  final utrItems = FirebaseFirestore.instance
      .collection('search_listings')
      .where('location', isEqualTo: 12)
      .snapshots();

  final pgpItems = FirebaseFirestore.instance
      .collection('search_listings')
      .where('location', isEqualTo: 6)
      .snapshots();

  int index = 0; //0 set as default for all items, as inkwells tapped, index changes to reflect categorized items

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: Text('Listings', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
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
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.opaqueSeparator)
                ),
                height: 50,
                child: Material(child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            index = 0;
                          });
                        },
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index == 0 ?
                              CupertinoColors.opaqueSeparator :
                              CupertinoColors.lightBackgroundGray
                          ),
                          child: const Center(child: Text('All listings'),),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            index = 1;
                          });
                        },
                        child: Container(
                          width: 108,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index == 1 ?
                              CupertinoColors.opaqueSeparator :
                              CupertinoColors.lightBackgroundGray
                          ),
                          child: const Center(child: Text('Free listings'),),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            index = 2;
                          });
                        },
                        child: Container(
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index == 2 ?
                              CupertinoColors.opaqueSeparator :
                              CupertinoColors.lightBackgroundGray
                          ),
                          child: const Center(child: Text('Halls'),),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            index = 3;
                          });
                        },
                        child: Container(
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index == 3 ?
                              CupertinoColors.opaqueSeparator :
                              CupertinoColors.lightBackgroundGray
                          ),
                          child: const Center(child: Text('RCs'),),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            index = 4;
                          });
                        },
                        child: Container(
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index == 4 ?
                              CupertinoColors.opaqueSeparator :
                              CupertinoColors.lightBackgroundGray
                          ),
                          child: const Center(child: Text('UTR'),),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            index = 5;
                          });
                        },
                        child: Container(
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index == 5 ?
                              CupertinoColors.opaqueSeparator :
                              CupertinoColors.lightBackgroundGray
                          ),
                          child: const Center(child: Text('PGP'),),
                        ),
                      ),
                    ),
                  ],
                )),
              ),
              const SizedBox(height: 20,),
              index == 0 ?
              Flexible(
                  child: ListingGridFs(stream: items, showMySold: false)
              )
                  : index == 1 ?
              Flexible(
                  child: ListingGridFs(stream: freeItems, showMySold: false)
              )
                  : index == 2 ?
              Flexible(
                  child: ListingGridFs(stream: hallsItems, showMySold: false)
              )
                  : index == 3 ?
              Flexible(
                  child: ListingGridFs(stream: rcItems, showMySold: false)
              )
                  : index == 4 ?
              Flexible(
                  child: ListingGridFs(stream: utrItems, showMySold: false)
              )
                  :
              Flexible(
                  child: ListingGridFs(stream: pgpItems, showMySold: false)
              )
            ],
          ),
        )
    );
  }
}
