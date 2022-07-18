import 'package:flutter/cupertino.dart';

class ReportList extends StatefulWidget {
  const ReportList({Key? key}) : super(key: key);

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
            middle: Text('Reported listings')
        ),
        child: SafeArea(
            minimum: const EdgeInsets.fromLTRB(20, 15, 20, 34),
            child: Center(
              child: Column(
                children: [
                  Text('Reported listings here')
                ],
              ),
            )
        )
    );
  }
}
