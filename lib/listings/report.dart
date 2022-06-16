import 'package:flutter/cupertino.dart';

import 'listing.dart';

class Report extends StatefulWidget {
  const Report({Key? key, required this.listing}) : super(key: key);

  final Listing listing;

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
              if (widget.listing.reported) {
                return CupertinoAlertDialog(
                    title: const Text('Listing reported'),
                    content: const Text('This listing has already been reported.'),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Ok'),
                      )
                    ]
                );
              } else {
                return CupertinoAlertDialog(
                    title: const Text('Report this listing?'),
                    content: const Text('Are you sure you want to report this listing?'),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      CupertinoDialogAction(
                        onPressed: () {
                          widget.listing.report();
                          Navigator.pop(context);
                          showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                    title: const Text('Listing reported'),
                                    content: const Text('This listing has been reported and will be reviewed by the DropShare team.'),
                                    actions: <CupertinoDialogAction>[
                                      CupertinoDialogAction(
                                          isDefaultAction: true,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Close'))
                                    ]
                                );
                              });
                        },
                        child: const Text('Report', style: TextStyle(color: CupertinoColors.destructiveRed)),
                      )
                    ]
                );
              }
            });
      },
      child: const Icon(CupertinoIcons.flag, color: CupertinoColors.destructiveRed),
    );
  }
}
