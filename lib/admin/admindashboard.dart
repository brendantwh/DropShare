import 'package:flutter/cupertino.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
            middle: Text('Admin Dashboard')
        ),
        child: SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(20, 15, 20, 34),
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      'Management'.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w500, color: CupertinoColors.systemGrey),
                      textScaleFactor: 0.87,
                    )
                ),
                Container(),
                GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'typesenseConfig'),
                    child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: CupertinoColors.secondarySystemFill),
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: Wrap(
                          direction: Axis.vertical,
                          alignment: WrapAlignment.center,
                          spacing: 6,
                          children: const [
                            Icon(CupertinoIcons.search_circle, size: 26),
                            const Text('Typesense', style: TextStyle(fontWeight: FontWeight.w500))
                          ],
                        )
                    )
                ),
                GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'userlist'),
                    child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: CupertinoColors.secondarySystemFill),
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: Wrap(
                          direction: Axis.vertical,
                          alignment: WrapAlignment.center,
                          spacing: 6,
                          children: const [
                            Icon(CupertinoIcons.person_3_fill, size: 26),
                            const Text('View all users', style: TextStyle(fontWeight: FontWeight.w500))
                          ],
                        )
                    )
                ),
                GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'reportlist'),
                    child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: CupertinoColors.secondarySystemFill),
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: Wrap(
                          direction: Axis.vertical,
                          alignment: WrapAlignment.center,
                          spacing: 6,
                          children: const [
                            Icon(CupertinoIcons.flag_circle, size: 26),
                            const Text('Reported listings', style: TextStyle(fontWeight: FontWeight.w500))
                          ],
                        )
                    )
                ),
                Container(),
                Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      'Swap Views'.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w500, color: CupertinoColors.systemGrey),
                      textScaleFactor: 0.87,
                    )
                ),
                Container(),
                GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, 'listings'),
                    child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: CupertinoColors.secondarySystemFill),
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: Wrap(
                          direction: Axis.vertical,
                          alignment: WrapAlignment.center,
                          spacing: 6,
                          children: const [
                            Icon(CupertinoIcons.arrow_right_arrow_left_circle, size: 26),
                            const Text('Normal view', style: TextStyle(fontWeight: FontWeight.w500))
                          ],
                        )
                    )
                ),
                GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, 'adminHome'),
                    child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: CupertinoColors.secondarySystemFill),
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: Wrap(
                          direction: Axis.vertical,
                          alignment: WrapAlignment.center,
                          spacing: 6,
                          children: const [
                            Icon(CupertinoIcons.arrow_right_arrow_left_circle, size: 26),
                            const Text('Admin view', style: TextStyle(fontWeight: FontWeight.w500))
                          ],
                        )
                    )
                )
              ],
            )
        )
    );
  }
}
