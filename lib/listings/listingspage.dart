import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'listinggridfs.dart';
import '../locations/location.dart';
import 'dart:ui' as ui;

class ListingsPage extends StatefulWidget {
  const ListingsPage({Key? key}) : super(key: key);

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  Stream<QuerySnapshot<Map<String, dynamic>>> items = FirebaseFirestore.instance //index -2
      .collection('search_listings')
      .orderBy('time', descending: true)
      .snapshots();

  bool free = false;

  bool initialLocSet = false;
  Set<int> selectedLocations = {-2}; // -2 for all, -1 for free (unused)

  EdgeInsets outerPadding = const EdgeInsets.only(right: 6);
  EdgeInsets innerPadding = const EdgeInsets.fromLTRB(10, 2, 10, 2);

  @override
  Widget build(BuildContext context) {
    double pfPadding = Platform.isIOS ? 90 : 68;

    int? initialLoc = ModalRoute.of(context)?.settings.arguments as int?;
    if (!initialLocSet && initialLoc != null) {
      selectedLocations = {initialLoc};
      initialLocSet = true;
    }

    if (selectedLocations.isEmpty || selectedLocations.contains(-2) || selectedLocations.length >= 10) {
      if (free) {
        items = FirebaseFirestore.instance //index 0
            .collection('search_listings')
            .orderBy('time', descending: true)
            .where('price', isEqualTo: 0)
            .snapshots();
      } else {
        items = FirebaseFirestore.instance //index 0
            .collection('search_listings')
            .orderBy('time', descending: true)
            .snapshots();
      }
    } else {
      if (free) {
        items = FirebaseFirestore.instance
            .collection('search_listings')
            .where('location', whereIn: selectedLocations.toList())
            .where('price', isEqualTo: 0)
            .orderBy('time', descending: true)
            .snapshots();
      } else {
        items = FirebaseFirestore.instance
            .collection('search_listings')
            .where('location', whereIn: selectedLocations.toList())
            .orderBy('time', descending: true)
            .snapshots();
      }
    }

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: Text('Listings',
                style: TextStyle(
                    fontFamily: CupertinoTheme.of(context)
                        .textTheme
                        .textStyle
                        .fontFamily)),
            trailing: GestureDetector(
                key: const Key('create'),
                onTap: () {
                  Navigator.pushNamed(context, 'create');
                },
                child: const Icon(CupertinoIcons.add))),
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: 34),
          child: Stack(
            children: [
              selectedLocations.isEmpty
                  ? const Center(
                  child: Text(
                      'There\'s nothing here!',
                      style: TextStyle(
                          color: CupertinoDynamicColor.withBrightness(
                              color: CupertinoColors.secondaryLabel,
                              darkColor: CupertinoColors.systemGrey2)
                      ),
                      textScaleFactor: 0.87
                  )
              )
                  : selectedLocations.length >= 10
                  ? const Center(
                  child: Text(
                      'Select at most 10 filters',
                      style: TextStyle(
                          color: CupertinoDynamicColor.withBrightness(
                              color: CupertinoColors.secondaryLabel,
                              darkColor: CupertinoColors.systemGrey2)
                      ),
                      textScaleFactor: 0.87
                  )
              )
                  : Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: ListingGridFs(stream: items, showMySold: false, padding: EdgeInsets.only(top: pfPadding + 150))
              ),
              ClipRect(
                child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
                    child: Container(
                        width: double.infinity,
                        height: 140,
                        margin: EdgeInsets.fromLTRB(0, pfPadding, 0, 0),
                        decoration: const BoxDecoration(
                            color: Color(0xF7FFFFFF),
                            border: Border(
                                bottom: BorderSide(
                                    width: 0,
                                    color: CupertinoColors.opaqueSeparator)
                            )
                        ),
                        child: Column(
                          children: [
                            Container(
                                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: CupertinoSearchTextField(
                                    onTap: () => Navigator.pushNamed(context, 'search'))),
                            Container(
                              margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                              height: 30,
                              child: Material(
                                  color: const Color.fromARGB(0, 255, 255, 255),
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 2,
                                      itemBuilder: (context, index) {
                                        List<String> content = ['All listings', 'Free listings'];

                                        if (index == 0) {
                                          // All listings
                                          return Padding(
                                            padding: outerPadding,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (selectedLocations.contains(-2)) {
                                                    selectedLocations.clear();
                                                  } else {
                                                    selectedLocations.clear();
                                                    selectedLocations.add(-2);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                padding: innerPadding,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: selectedLocations.contains(-2)
                                                        ? CupertinoColors.opaqueSeparator
                                                        : CupertinoColors.lightBackgroundGray),
                                                child: Center(
                                                  child: Text(content[index]),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          // Free items
                                          return Padding(
                                            padding: outerPadding,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  free = !free;
                                                });
                                              },
                                              child: Container(
                                                padding: innerPadding,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: free
                                                        ? CupertinoColors.opaqueSeparator
                                                        : CupertinoColors.lightBackgroundGray),
                                                child: Center(
                                                  child: Text(content[index]),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                  )
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              height: 30,
                              child: Material(
                                  color: const Color.fromARGB(0, 255, 255, 255),
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 15,
                                      itemBuilder: (context, index) {
                                        List<String> content = Location.values.map((loc) => loc.shortName).toList();
                                        content.insert(0, 'All Halls');
                                        content.insert(8, 'All RCs');

                                        if (index == 0) {
                                          // All halls
                                          bool contains = selectedLocations.contains(0)
                                              && selectedLocations.contains(1)
                                              && selectedLocations.contains(2)
                                              && selectedLocations.contains(3)
                                              && selectedLocations.contains(4)
                                              && selectedLocations.contains(5);

                                          return Padding(
                                            padding: const EdgeInsets.only(left: 20, right: 6),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (contains) {
                                                    for (int i = 0; i <= 5; i++) {
                                                      selectedLocations.remove(-2);
                                                      selectedLocations.remove(i);
                                                    }
                                                  } else {
                                                    for (int i = 0; i <= 5; i++) {
                                                      selectedLocations.remove(-2);
                                                      selectedLocations.add(i);
                                                    }
                                                  }
                                                });
                                              },
                                              child: Container(
                                                padding: innerPadding,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: contains
                                                        ? CupertinoColors.opaqueSeparator
                                                        : CupertinoColors.lightBackgroundGray),
                                                child: Center(
                                                  child: Text(content[index]),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else if (index == 8) {
                                          // All RCs
                                          bool contains = selectedLocations.contains(7)
                                              && selectedLocations.contains(8)
                                              && selectedLocations.contains(9)
                                              && selectedLocations.contains(10)
                                              && selectedLocations.contains(11);

                                          return Padding(
                                            padding: outerPadding,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (contains) {
                                                    for (int i = 7; i <= 11; i++) {
                                                      selectedLocations.remove(i);
                                                      selectedLocations.remove(-2);
                                                    }
                                                  } else {
                                                    for (int i = 7; i <= 11; i++) {
                                                      selectedLocations.add(i);
                                                      selectedLocations.remove(-2);
                                                    }
                                                  }
                                                });
                                              },
                                              child: Container(
                                                padding: innerPadding,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: contains
                                                        ? CupertinoColors.opaqueSeparator
                                                        : CupertinoColors.lightBackgroundGray),
                                                child: Center(
                                                  child: Text(content[index]),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else if (index >= 1 && index <= 6){
                                          // Individual hall locations
                                          return Padding(
                                            padding: outerPadding,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedLocations.remove(-2);
                                                  if (selectedLocations.contains(index - 1)) {
                                                    selectedLocations.remove(index - 1);
                                                  } else {
                                                    selectedLocations.add(index - 1);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                padding: innerPadding,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: selectedLocations.contains(index - 1)
                                                        ? CupertinoColors.opaqueSeparator
                                                        : CupertinoColors.lightBackgroundGray),
                                                child: Center(
                                                  child: Text(content[index]),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else if (index == 7) {
                                          // PGP
                                          return Padding(
                                            padding: outerPadding,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedLocations.remove(-2);
                                                  if (selectedLocations.contains(index - 1)) {
                                                    selectedLocations.remove(index - 1);
                                                  } else {
                                                    selectedLocations.add(index - 1);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                padding: innerPadding,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: selectedLocations.contains(index - 1)
                                                        ? CupertinoColors.opaqueSeparator
                                                        : CupertinoColors.lightBackgroundGray),
                                                child: Center(
                                                  child: Text(content[index]),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else if (index >= 9 && index <= 13) {
                                          // Individual RC locations
                                          return Padding(
                                            padding: outerPadding,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedLocations.remove(-2);
                                                  if (selectedLocations.contains(index - 2)) {
                                                    selectedLocations.remove(index - 2);
                                                  } else {
                                                    selectedLocations.add(index - 2);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                padding: innerPadding,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: selectedLocations.contains(index - 2)
                                                        ? CupertinoColors.opaqueSeparator
                                                        : CupertinoColors.lightBackgroundGray),
                                                child: Center(
                                                  child: Text(content[index]),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          // UTR (last item)
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 20),
                                            child: InkWell(
                                              onTap: () {
                                                selectedLocations.remove(-2);
                                                setState(() {
                                                  if (selectedLocations.contains(index - 2)) {
                                                    selectedLocations.remove(index - 2);
                                                  } else {
                                                    selectedLocations.add(index - 2);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                padding: innerPadding,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: selectedLocations.contains(index - 2)
                                                        ? CupertinoColors.opaqueSeparator
                                                        : CupertinoColors.lightBackgroundGray),
                                                child: Center(
                                                  child: Text(content[index]),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                  )
                              ),
                            ),
                          ],
                        )
                    )
                ),
              )
            ],
          )
        ),
    );
  }
}