import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../listings/listing.dart';
import '../listings/listinghelper.dart';
import '../locations/location.dart';
import '../user/dsuser.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    DsUser user = ModalRoute.of(context)?.settings.arguments as DsUser;
    final userLocListings = FirebaseFirestore.instance
        .collection('search_listings')
        .where('location', isEqualTo: user.location)
        .orderBy('time', descending: true)
        .where('visible', isEqualTo: true)
        .where('sold', isEqualTo: false)
        .limit(2)
        .snapshots();
    final latestListings = FirebaseFirestore.instance
        .collection('search_listings')
        .orderBy('time', descending: true)
        .where('visible', isEqualTo: true)
        .where('sold', isEqualTo: false)
        .limit(2)
        .snapshots();

    return WillPopScope(
        onWillPop: () async => false,
        child: CupertinoPageScaffold(
            child: CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                    automaticallyImplyLeading: false,
                    largeTitle: Text(
                      'Home',
                      style: TextStyle(
                          fontFamily: CupertinoTheme.of(context)
                              .textTheme
                              .textStyle
                              .fontFamily,
                          letterSpacing: -0.7,
                      ),
                      textScaleFactor: 1
                    ),
                    trailing: GestureDetector(
                        key: const Key('create'),
                        onTap: () {
                          Navigator.pushNamed(context, 'create');
                        },
                        child: const Icon(CupertinoIcons.add))
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: SafeArea(
                    top: false,
                    minimum: const EdgeInsets.fromLTRB(20, 0, 20, 34),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // container for search bar
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                            child: CupertinoSearchTextField(
                                focusNode: FocusNode(canRequestFocus: false),
                                onTap: () => Navigator.pushNamed(context, 'search')
                            )
                        ),
                        // gesturedetector to profile
                        GestureDetector(
                          key: const Key('to profile'),
                          onTap: () {
                            Navigator.pushNamed(context, 'userpage', arguments: user).then((val) {
                              DsUser.getMine().then((newUser) {
                                setState(() {
                                  user = newUser;
                                });
                              });
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: CupertinoColors.quaternarySystemFill),
                              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                              padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                              width: double.infinity,
                              child: Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                children: [
                                  Wrap(
                                    direction: Axis.horizontal,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 10,
                                    children: [
                                      const Icon(CupertinoIcons.person_alt_circle, size: 46),
                                      Wrap(
                                        direction: Axis.vertical,
                                        spacing: 5,
                                        children: [
                                          Wrap(
                                            direction: Axis.horizontal,
                                            alignment: WrapAlignment.spaceAround,
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            children: [
                                              Text(user.username,
                                                  style: const TextStyle(
                                                      fontSize: 18, fontWeight: FontWeight.w600),
                                                  overflow: TextOverflow.ellipsis),
                                            ],
                                          ),
                                          Wrap(
                                            direction: Axis.horizontal,
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            spacing: 6,
                                            children: [
                                              Icon(
                                                user.location >= 0 && user.location <= 5
                                                    ? CupertinoIcons.house_fill
                                                    : CupertinoIcons.building_2_fill,
                                                size: 16,
                                                color: CupertinoColors.secondaryLabel,
                                              ),
                                              Text(Location.values[user.location].fullName,
                                                  style: const TextStyle(fontSize: 16)),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Icon(CupertinoIcons.chevron_forward, size: 28, color: CupertinoColors.secondaryLabel)
                                ],
                              )),
                        ),
                        // container for recent listings text
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.fromLTRB(0, 25, 0, 15),
                          child: Text('Recent listings at ${Location.values[user.location].fullName}', style: TextStyle(fontSize: 17, color: CupertinoColors.secondaryLabel)),
                        ),
                        // streambuilder for recent listings in your area
                        StreamBuilder<QuerySnapshot>(
                            stream: userLocListings,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                print(snapshot.error);
                                return const SizedBox(
                                  height: 184,
                                  child: Center(
                                      child: Text(
                                        'Something went wrong!',
                                        style: TextStyle(
                                            color: CupertinoDynamicColor.withBrightness(
                                                color: CupertinoColors.secondaryLabel,
                                                darkColor: CupertinoColors.systemGrey2),
                                            fontSize: 14
                                        ),
                                      )
                                  ),
                                );
                              }

                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CupertinoActivityIndicator());
                              }

                              if (snapshot.data!.size == 0) {
                                return const SizedBox(
                                  height: 184,
                                  child: Center(
                                      child: Text(
                                          'There\'s nothing here!',
                                          style: TextStyle(
                                              color: CupertinoDynamicColor.withBrightness(
                                                  color: CupertinoColors.secondaryLabel,
                                                  darkColor: CupertinoColors.systemGrey2
                                              ),
                                              fontSize: 14
                                          ),
                                      )
                                  ),
                                );
                              }

                              return SizedBox(
                                  height: 184,
                                  child: ListView.builder(
                                    clipBehavior: Clip.none,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.size >= 3 ? 3 : snapshot.data!.size + 1,
                                    itemBuilder: (context, index) {
                                      if (index == snapshot.data!.size) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(context, 'listings', arguments: user.location);
                                            },
                                            child: Container(
                                                alignment: Alignment.topCenter,
                                                width: 140,
                                                child: AspectRatio(
                                                    aspectRatio: 1,
                                                    child: Container(
                                                      alignment: Alignment.centerRight,
                                                      padding: const EdgeInsets.only(right: 16),
                                                      decoration: BoxDecoration(color: CupertinoColors.quaternarySystemFill, borderRadius: BorderRadius.circular(14)),
                                                      child: Wrap(
                                                        direction: Axis.vertical,
                                                        crossAxisAlignment: WrapCrossAlignment.end,
                                                        spacing: 10,
                                                        children: const [
                                                          Icon(CupertinoIcons.arrow_right_circle_fill, size: 20),
                                                          Text('more listings', style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 15),)
                                                        ],
                                                      ),
                                                    )
                                                )
                                            )
                                        );
                                      } else {
                                        Listing l = Listing.fromFirestore(snapshot.data!.docs[index] as DocumentSnapshot<Map<String, dynamic>>);
                                        return GestureDetector(
                                            onTap: () {
                                              DsUser.getMine().then((me) {
                                                DsUser(l.uid).getFull().then((seller) {
                                                  Navigator.pushNamed(context, 'indiv',
                                                      arguments: ListingHelper(l, me, seller));
                                                });
                                              });
                                            },
                                            child: l.showListingFullSmall()
                                        );
                                      }
                                    },
                                  )
                              );
                            }),
                        // container for recent listings text
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.fromLTRB(0, 35, 0, 15),
                          child: const Text('Recent listings in NUS', style: TextStyle(fontSize: 17, color: CupertinoColors.secondaryLabel)),
                        ),
                        // streambuilder for recent listings
                        StreamBuilder<QuerySnapshot>(
                            stream: latestListings,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const SizedBox(
                                  height: 184,
                                  child: Center(
                                      child: Text(
                                        'Something went wrong!',
                                        style: TextStyle(
                                            color: CupertinoDynamicColor.withBrightness(
                                                color: CupertinoColors.secondaryLabel,
                                                darkColor: CupertinoColors.systemGrey2),
                                            fontSize: 14
                                        ),
                                      )
                                  ),
                                );
                              }

                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CupertinoActivityIndicator());
                              }

                              if (snapshot.data!.size == 0) {
                                return const SizedBox(
                                  height: 184,
                                  child: Center(
                                      child: Text(
                                          'There\'s nothing here!',
                                          style: TextStyle(
                                              color: CupertinoDynamicColor.withBrightness(
                                                  color: CupertinoColors.secondaryLabel,
                                                  darkColor: CupertinoColors.systemGrey2),
                                              fontSize: 14
                                          ),
                                      )
                                  ),
                                );
                              }

                              return SizedBox(
                                  height: 184,
                                  child: ListView.builder(
                                    clipBehavior: Clip.none,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.size >= 3 ? 3 : snapshot.data!.size + 1,
                                    itemBuilder: (context, index) {
                                      if (index == snapshot.data!.size) {
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(context, 'listings');
                                            },
                                            child: Container(
                                              alignment: Alignment.topCenter,
                                              width: 140,
                                              child: AspectRatio(
                                                  aspectRatio: 1,
                                                  child: Container(
                                                    alignment: Alignment.centerRight,
                                                    padding: const EdgeInsets.only(right: 16),
                                                    decoration: BoxDecoration(color: CupertinoColors.quaternarySystemFill, borderRadius: BorderRadius.circular(14)),
                                                    child: Wrap(
                                                      direction: Axis.vertical,
                                                      crossAxisAlignment: WrapCrossAlignment.end,
                                                      spacing: 10,
                                                      children: const [
                                                        Icon(CupertinoIcons.arrow_right_circle_fill, size: 20),
                                                        Text('more listings', style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 15),)
                                                      ],
                                                    ),
                                                  )
                                              )
                                            )
                                        );
                                      } else {
                                        Listing l = Listing.fromFirestore(snapshot.data!.docs[index] as DocumentSnapshot<Map<String, dynamic>>);
                                        return GestureDetector(
                                            onTap: () {
                                              DsUser.getMine().then((me) {
                                                DsUser(l.uid).getFull().then((seller) {
                                                  Navigator.pushNamed(context, 'indiv',
                                                      arguments: ListingHelper(l, me, seller));
                                                });
                                              });
                                            },
                                            child: l.showListingFullSmall()
                                        );
                                      }
                                    },
                                  )
                              );
                            }),
                        // container for button to view all listings
                        Container(
                            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                            child: CupertinoButton(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              color: CupertinoColors.quaternarySystemFill,
                              onPressed: () => Navigator.pushNamed(context, 'listings'),
                              child: Text('View all listings', style: TextStyle(color: CupertinoColors.activeBlue)),
                            )
                        )
                      ],
                    ),
                  )
                )
              ],
            )
        )
    );
  }
}
