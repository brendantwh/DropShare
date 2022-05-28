import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'listing.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({Key? key}) : super(key: key);

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  late final items =
      FirebaseFirestore.instance.collection('listings').snapshots();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            automaticallyImplyLeading: false,
            middle: const Text('DropShare'),
            trailing: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'create');
                },
                child: const Icon(CupertinoIcons.add))),
        child: SafeArea(
            minimum: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 0),
            child: StreamBuilder<QuerySnapshot>(
                stream: items,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  return GridView.count(
                      crossAxisCount: 2,
                      children: snapshot.data!.docs
                          .map<Widget>((DocumentSnapshot document) {
                        Listing l = Listing.fromFirestore(
                            document as DocumentSnapshot<Map<String, dynamic>>);
                        return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, 'indiv',
                                  arguments: l);
                            },
                            child: Text(l.title));
                      }).toList());
                })));
  }
}
