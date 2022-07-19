import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DsUser {
  static DsUser placeholder = DsUser('Loading', 'Loading', 'Loading', false);

  String username;
  String uid;
  String email;
  bool admin;
  bool emailVerified;

  DsUser(this.uid, [this.username = 'Unknown', this.email = 'Unknown', this.admin = false, this.emailVerified = false]);

  factory DsUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return DsUser(
      snapshot.id,
      data['username'],
      data['email'],
      data['admin'],
      data['emailVerified']
    );
  }

  static Future<DsUser> getMine() async {
    String myUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance.collection('users').doc(myUid).get();

    return DsUser(myUid, data['username'], data['email'], data['admin']);
  }

  Future<DsUser> getFull() async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!data.exists) {
      return this;
    }

    return DsUser(uid, data['username'], data['email'], data['admin']);
  }

  Container userCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: CupertinoColors.quaternarySystemFill
      ),
      margin: const EdgeInsets.fromLTRB(0, 6, 0, 0),
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: GestureDetector(
          onTap: () {},
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Wrap(
                direction: Axis.vertical,
                spacing: 3,
                children: [
                  Text(username, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                  Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: [
                      Text(email, style: const TextStyle(fontSize: 16, color: CupertinoColors.systemGrey)),
                      emailVerified
                          ? const Icon(CupertinoIcons.check_mark_circled_solid, size: 18, color: CupertinoColors.systemGrey)
                          : const Icon(CupertinoIcons.xmark_circle_fill, size: 18, color: CupertinoColors.systemRed)
                    ],
                  )
                ]
              ),
              Text(admin ? 'Admin' : '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: CupertinoColors.systemBlue))
            ],
          )
      ),
    );
  }
}

class UsernameText extends StatefulWidget {
  const UsernameText(this.textBefore, this.textAfter, {Key? key, this.textStyle, this.user, this.link = false}) : super(key: key);

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
              return Text('${widget.textBefore}${user.username}${widget.textAfter}', style: widget.textStyle);
            } else {
              return Text('${widget.textBefore}${user.username}${widget.textAfter}');
            }
          }
      );
  }
}
