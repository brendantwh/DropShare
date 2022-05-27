import 'package:flutter/cupertino.dart';

class Listings extends StatefulWidget {
  const Listings({Key? key}) : super(key: key);

  @override
  State<Listings> createState() => _ListingsState();
}

class _ListingsState extends State<Listings> {
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
        child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(15, (index) {
              return Center(child: Text('Item $index'));
            })));
  }
}
