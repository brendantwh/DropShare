import 'package:flutter/cupertino.dart';

import 'listinghelper.dart';

class Report extends StatefulWidget {
  const Report({Key? key, required this.helper}) : super(key: key);

  final ListingHelper helper;

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              if (widget.helper.listing.reported) {
                return CupertinoAlertDialog(
                    title: Text('Listing reported', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
                    content: Text('This listing has already been reported.', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Ok', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
                      )
                    ]
                );
              } else {
                return CupertinoAlertDialog(
                    title: Text('Report this listing?', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
                    content: Text('Are you sure you want to report this listing?', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
                      ),
                      CupertinoDialogAction(
                        onPressed: () {
                          widget.helper.listing.report();
                          Navigator.pop(context);
                          showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                    title: Text('Listing reported', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
                                    content: Text('This listing has been reported and will be reviewed by the DropShare team.', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
                                    actions: <CupertinoDialogAction>[
                                      CupertinoDialogAction(
                                          isDefaultAction: true,
                                          onPressed: () {
                                            Navigator.pop(context);
                                            widget.helper.listing.reported = true;
                                            Navigator.pushReplacementNamed(context, 'indiv', arguments: widget.helper);
                                          },
                                          child: Text('Close', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)))
                                    ]
                                );
                              });
                        },
                        child: Text('Report', style: TextStyle(color: CupertinoColors.destructiveRed, fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily)),
                      )
                    ]
                );
              }
            });
      },
      child: Icon(
          widget.helper.listing.reported
              ? CupertinoIcons.flag_fill
              : CupertinoIcons.flag,
          color: CupertinoColors.destructiveRed
      ),
    );
  }
}
