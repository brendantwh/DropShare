import 'package:cloud_firestore/cloud_firestore.dart';

import 'search.dart';
import 'package:flutter/cupertino.dart';

class TypesenseConfig extends StatefulWidget {
  const TypesenseConfig({Key? key}) : super(key: key);

  @override
  State<TypesenseConfig> createState() => _TypesenseConfigState();
}

class _TypesenseConfigState extends State<TypesenseConfig> {
  @override
  Widget build(BuildContext context) {
    // for Typesense admin client
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        navigationBar: const CupertinoNavigationBar(
            middle: Text('Typesense', textScaleFactor: 1)
        ),
        child: SafeArea(
            minimum: const EdgeInsets.fromLTRB(0, 0, 0, 34),
            child: Column(
              children: [
                CupertinoFormSection.insetGrouped(
                    header: Text('Core'.toUpperCase()),
                    children: [
                      CupertinoFormRow(
                          padding: const EdgeInsets.fromLTRB(20, 10, 14, 10),
                          prefix: Text('Server health'),
                          child: FutureBuilder(
                            future: Search.health,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Container(
                                    padding: const EdgeInsets.fromLTRB(0, 2, 2, 2),
                                    child: const CupertinoActivityIndicator()
                                );
                              }

                              Icon status = snapshot.data as Icon;
                              return status;
                            }
                          )
                      ),
                      CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            showCupertinoModalPopup<void>(
                              context: context,
                              builder:  (context) => CupertinoAlertDialog(
                                title: const Text('Typesense domain'),
                                content: Text(Search.domain),
                                actions: <CupertinoDialogAction>[
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Close'),
                                  )
                                ],
                              ),
                            );
                          },
                          child: const CupertinoFormRow(
                              prefix: Text('Typesense domain', style: TextStyle(color: CupertinoColors.link)),
                              child: Icon(null, size: 18, color: CupertinoColors.secondaryLabel)
                          )
                      ),
                      CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            retrieveKeys();
                            showConsoleDialog(context);
                          },
                          child: const CupertinoFormRow(
                              padding: const EdgeInsets.fromLTRB(20, 10, 14, 10),
                              prefix: Text('Retrieve all keys', style: TextStyle(color: CupertinoColors.link)),
                              child: Icon(CupertinoIcons.device_laptop, color: CupertinoColors.link)
                          )
                      ),
                    ]
                ),
                CupertinoFormSection.insetGrouped(
                    header: Text('Collection'.toUpperCase()),
                    footer: Wrap(
                        spacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Icon(CupertinoIcons.info, size: 16, color:CupertinoColors.secondaryLabel),
                          Container(
                            padding: const EdgeInsets.only(top: 2),
                            child: const Text('Use retrieve with Flutter console.'),
                          )
                        ]
                    ),
                    children: [
                      CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            int tsCount = await Search.docCount;
                            var fs = await FirebaseFirestore.instance.collection('search_listings').get();
                            int fsCount = fs.docs.length;
                            showCupertinoModalPopup<void>(
                              context: context,
                              builder:  (context) => CupertinoAlertDialog(
                                title: const Text('Document count'),
                                content: Center(
                                  child: Wrap(
                                    direction: Axis.vertical,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      Text('Typesense count: $tsCount'),
                                      Text('Firestore count: $fsCount')
                                    ],
                                  ),
                                ),
                                actions: <CupertinoDialogAction>[
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Close'),
                                  )
                                ],
                              ),
                            );
                          },
                          child: const CupertinoFormRow(
                              prefix: Text('Document count', style: TextStyle(color: CupertinoColors.link)),
                              child: Icon(null, size: 18, color: CupertinoColors.secondaryLabel)
                          )
                      ),
                      CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            retrieveCollections();
                            showConsoleDialog(context);
                          },
                          child: const CupertinoFormRow(
                            padding: const EdgeInsets.fromLTRB(20, 10, 14, 10),
                              prefix: Text('Retrieve collection schema', style: TextStyle(color: CupertinoColors.link)),
                              child: Icon(CupertinoIcons.device_laptop, color: CupertinoColors.link)
                          )
                      ),
                    ]
                )
              ],
            )
        )
    );
  }

  // Future<void> collection() async {
  //   await Search.adminClient.collection('search_listings').delete();
  //   await Search.adminClient.collections.create(Search.listingSchema);
  // }

  Future<void> retrieveKeys() async {
    await Search.adminClient.keys.retrieve().then((res) => print(res));
  }

  Future<void> retrieveCollections() async {
    await Search.adminClient.collection('search_listings').retrieve().then((res) => print(res));
  }

  void showConsoleDialog(context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Use with console'),
        content: const Text('Check Flutter console for details.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          )
        ],
      ),
    );
  }
}