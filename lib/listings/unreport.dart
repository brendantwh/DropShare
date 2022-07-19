import 'package:flutter/cupertino.dart';

import 'listing.dart';

class Unreport extends StatefulWidget {
  const Unreport({Key? key, required this.listing}) : super(key: key);

  final Listing listing;

  @override
  State<Unreport> createState() => _UnreportState();
}

class _UnreportState extends State<Unreport> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        color: widget.listing.reported
            ? CupertinoColors.destructiveRed
            : const Color(0xfff2f4f5),
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        onPressed: widget.listing.reported
            ? () {
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                          title: Text('[ADMIN] Listing reported',
                              style: TextStyle(
                                  fontFamily: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .fontFamily)),
                          content: Text(
                              'This listing has been reported. Would you like to unreport this listing?',
                              style: TextStyle(
                                  fontFamily: CupertinoTheme.of(context)
                                      .textTheme
                                      .textStyle
                                      .fontFamily)),
                          actions: <CupertinoDialogAction>[
                            CupertinoDialogAction(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No',
                                  style: TextStyle(
                                      fontFamily: CupertinoTheme.of(context)
                                          .textTheme
                                          .textStyle
                                          .fontFamily)),
                            ),
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              onPressed: () {
                                Navigator.pop(context);
                                widget.listing.unreport();
                                showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                          title: Text('[ADMIN] Listing unreported', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
                                          content: Text('This listing has been unreported.', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
                                          actions: <CupertinoDialogAction>[
                                            CupertinoDialogAction(
                                                isDefaultAction: true,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  widget.listing.reported = false;
                                                  Navigator.pushReplacementNamed(context, 'indiv', arguments: widget.listing);
                                                },
                                                child: Text('Close', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)))
                                          ]
                                      );
                                    });
                              },
                              child: Text('Yes',
                                  style: TextStyle(
                                      fontFamily: CupertinoTheme.of(context)
                                          .textTheme
                                          .textStyle
                                          .fontFamily)),
                            )
                          ]);
                    });
              }
            : null,
        child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            children: widget.listing.reported
                ? const [
                    Icon(CupertinoIcons.flag_fill,
                        color: CupertinoColors.white),
                    Text('Unreport',
                        style: TextStyle(
                            color: CupertinoColors.white,
                            fontWeight: FontWeight.w500))
                  ]
                : const [
                    Icon(CupertinoIcons.flag_slash,
                        color: CupertinoColors.systemGrey),
                    Text('Not reported',
                        style: TextStyle(color: CupertinoColors.systemGrey))
                  ]));
  }
}
