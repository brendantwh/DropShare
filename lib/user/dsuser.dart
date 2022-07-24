import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../locations/location.dart';

class DsUser {
  static DsUser placeholder = DsUser('Loading', 'Loading', 'Loading', false);

  String username;
  String uid;
  String email;
  bool admin;
  bool adminView;
  bool emailVerified;
  int location;

  DsUser(this.uid,
      [this.username = 'Unknown',
      this.email = 'Unknown',
      this.admin = false,
      this.adminView = false,
      this.emailVerified = false,
      this.location = 0]);

  factory DsUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return DsUser(snapshot.id, data['username'], data['email'], data['admin'],
        data['adminView'], data['emailVerified'], data['location']);
  }

  static Future<DsUser> getMine() async {
    String myUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    DocumentSnapshot<Map<String, dynamic>> data =
        await FirebaseFirestore.instance.collection('users').doc(myUid).get();

    return DsUser(myUid, data['username'], data['email'], data['admin'],
        data['adminView'], data['emailVerified'], data['location']);
  }

  Future<DsUser> getFull() async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!data.exists) {
      return this;
    }

    return DsUser(uid, data['username'], data['email'], data['admin'],
        data['adminView'], data['emailVerified'], data['location']);
  }

  void update(String username, int location) {
    this.username = username;
    this.location = location;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'username': username, 'location': location});
  }

  void swapView(bool adminView) {
    this.adminView = adminView;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'adminView': adminView});
  }

  Container smallUserCard() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: CupertinoColors.secondarySystemGroupedBackground),
      margin: const EdgeInsets.fromLTRB(0, 6, 0, 0),
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: GestureDetector(
          onTap: () {},
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Wrap(direction: Axis.vertical, spacing: 3, children: [
                Text(username,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16)),
                Wrap(
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  children: [
                    Text(email,
                        style: const TextStyle(
                            fontSize: 16, color: CupertinoColors.systemGrey)),
                    emailVerified
                        ? const Icon(CupertinoIcons.check_mark_circled_solid,
                            size: 18, color: CupertinoColors.systemGrey)
                        : const Icon(CupertinoIcons.xmark_circle_fill,
                            size: 18, color: CupertinoColors.systemRed)
                  ],
                )
              ]),
              Text(admin ? 'Admin' : '',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: CupertinoColors.systemBlue))
            ],
          )),
    );
  }

  Container profileCard(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: CupertinoColors.quaternarySystemFill),
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
        width: double.infinity,
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 10,
          children: [
            Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                const Icon(CupertinoIcons.person_alt_circle, size: 46),
                Wrap(
                  direction: Axis.vertical,
                  spacing: 5,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.spaceAround,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(username,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      children: [
                        Icon(
                          location >= 0 && location <= 5
                              ? CupertinoIcons.house_fill
                              : CupertinoIcons.building_2_fill,
                          size: 16,
                          color: CupertinoColors.secondaryLabel,
                        ),
                        Text(Location.values[location].fullName,
                            style: const TextStyle(fontSize: 16)),
                      ],
                    )
                  ],
                ),
              ],
            ),
            GestureDetector(
                key: const Key('modify profile'),
                onTap: () {
                  Navigator.pushNamed(context, 'modifypage', arguments: this);
                },
                child: const Icon(CupertinoIcons.pencil_circle, size: 28)),
            admin
                ? Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(top: 10),
                    height: 30,
                    child: CupertinoButton(
                        color: CupertinoColors.systemBlue,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        onPressed: () =>
                            Navigator.pushNamed(context, 'adminDash', arguments: this),
                        child: const Text('Admin Dashboard',
                            style: TextStyle(
                                color: CupertinoColors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14))))
                : Container()
          ],
        ));
  }
}

class UsernameText extends StatefulWidget {
  const UsernameText(this.textBefore, this.textAfter,
      {Key? key, this.textStyle, this.user, this.link = false})
      : super(key: key);

  final TextStyle? textStyle;
  final DsUser? user;
  final bool link;
  final String textBefore;
  final String textAfter;

  @override
  State<UsernameText> createState() => _UsernameTextState();
}

class _UsernameTextState extends State<UsernameText> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.user == null ? DsUser.getMine() : widget.user!.getFull(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          DsUser user = snapshot.data as DsUser;

          if (widget.link) {
            return Text(
              '${widget.textBefore} ${user.username} ${widget.textAfter}',
              style: const TextStyle(color: CupertinoColors.activeBlue),
            );
          } else if (widget.textStyle != null) {
            return Text(
                '${widget.textBefore}${user.username}${widget.textAfter}',
                style: widget.textStyle);
          } else {
            return Text(
                '${widget.textBefore}${user.username}${widget.textAfter}');
          }
        });
  }
}
