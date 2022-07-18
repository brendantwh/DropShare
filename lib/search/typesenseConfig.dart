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
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Typesense Config')
        ),
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 15, 20, 34),
          child: Center(
            child: Column(
              children: [
                CupertinoButton(
                    child: Text('Update schema'),
                    onPressed: () => collection()
                ),
                CupertinoButton(
                    child: Text('Retrieve all keys'),
                    onPressed: () => retrieveKeys()
                ),
                CupertinoButton(
                    child: Text('Retrieve all collections'),
                    onPressed: () => retrieveCollections()
                )
              ],
            ),
          )
        )
    );
  }

  Future<void> collection() async {
    await Search.adminClient.collection('search_listings').delete();
    await Search.adminClient.collections.create(Search.listingSchema);
  }

  Future<void> retrieveKeys() async {
    await Search.adminClient.keys.retrieve().then((res) => print(res));
  }

  Future<void> retrieveCollections() async {
    await Search.adminClient.collections.retrieve().then((res) => print(res));
  }
}