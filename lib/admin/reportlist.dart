import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../listings/listinggridfs.dart';

class ReportList extends StatefulWidget {
  const ReportList({Key? key}) : super(key: key);

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  final reportedListings = FirebaseFirestore.instance
      .collection('search_listings')
      .orderBy('time', descending: true)
      .where('reported', isEqualTo: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: Text(
                'Reported listings',
                style: TextStyle(
                fontFamily: CupertinoTheme.of(context)
                    .textTheme
                    .textStyle
                    .fontFamily),
                textScaleFactor: 1)
        ),
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(20, 0, 20, 34),
          child: ListingGridFs(stream: reportedListings, showMySold: true, padding: const EdgeInsets.fromLTRB(0, 110, 0, 0))
        )
    );
  }
}
