import 'package:flutter/cupertino.dart';

import '../user/dsuser.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    final DsUser user = ModalRoute.of(context)?.settings.arguments as DsUser;

    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
            middle: Text('Admin Dashboard')
        ),
        backgroundColor: CupertinoColors.systemGroupedBackground,
        child: SafeArea(
            // top: false,
            minimum: const EdgeInsets.fromLTRB(0, 15, 0, 34),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CupertinoFormSection.insetGrouped(
                    header: Text('Management'.toUpperCase()),
                    children: [
                      GestureDetector(
                          onTap: () => Navigator.pushNamed(context, 'typesenseConfig'),
                          child: CupertinoFormRow(
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                            prefix: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 12,
                              children: const [
                                Icon(CupertinoIcons.search_circle, size: 30),
                                Text('Typesense')
                              ],
                            ),
                            child: Icon(CupertinoIcons.chevron_forward, size: 18, color: CupertinoColors.secondaryLabel),
                          )
                      ),
                      GestureDetector(
                          onTap: () => Navigator.pushNamed(context, 'userlist'),
                          child: CupertinoFormRow(
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                            prefix: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 12,
                              children: const [
                                Icon(CupertinoIcons.person_3_fill, size: 30),
                                Text('View all users')
                              ],
                            ),
                            child: Icon(CupertinoIcons.chevron_forward, size: 18, color: CupertinoColors.secondaryLabel),
                          )
                      ),
                      GestureDetector(
                          onTap: () => Navigator.pushNamed(context, 'reportlist'),
                          child: CupertinoFormRow(
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                            prefix: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 12,
                              children: const [
                                Icon(CupertinoIcons.flag_circle, size: 30),
                                Text('Reported listings')
                              ],
                            ),
                            child: Icon(CupertinoIcons.chevron_forward, size: 18, color: CupertinoColors.secondaryLabel),
                          )
                      ),
                    ]
                ),
                CupertinoFormSection.insetGrouped(
                  header: Text('View'.toUpperCase()),
                  children: [
                    CupertinoFormRow(
                        prefix: Text('Toggle admin view'),
                        child: CupertinoSwitch(
                          onChanged: (bool adminView) {
                            setState(() {
                              user.swapView(adminView);
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) => Center(child: CupertinoActivityIndicator())
                              );
                              Future.delayed(const Duration(milliseconds: 300), () {
                                if (adminView) {
                                  Navigator.pushReplacementNamed(context, 'adminHome');
                                } else {
                                  Navigator.pushReplacementNamed(context, 'listings');
                                }
                              });
                            });
                          },
                          value: user.adminView,
                        )
                    ),

                  ],
                )
              ],
            )
        )
    );
  }
}
//
// Container(),
// Container(
// alignment: Alignment.bottomLeft,
// padding: const EdgeInsets.only(left: 6),
// child: Text(
// 'Swap Views'.toUpperCase(),
// style: const TextStyle(fontWeight: FontWeight.w500, color: CupertinoColors.systemGrey),
// textScaleFactor: 0.87,
// )
// ),
// Container(),
// Container(
// alignment: Alignment.topLeft,
// child: Text('Swap views')
// ),
// Container(
// alignment: Alignment.topRight,
// child: