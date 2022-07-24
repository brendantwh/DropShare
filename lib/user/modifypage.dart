import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../auth/authentication.dart';
import '../locations/location.dart';
import 'dsuser.dart';

class ModifyPage extends StatefulWidget {
  const ModifyPage({Key? key}) : super(key: key);

  @override
  State<ModifyPage> createState() => _ModifyPageState();
}

class _ModifyPageState extends State<ModifyPage> {
  final TextEditingController usernameController = TextEditingController();
  int _selectedLocation = 0;

  @override
  Widget build(BuildContext context) {
    final DsUser user = ModalRoute.of(context)?.settings.arguments as DsUser;
    usernameController.text = user.username;
    _selectedLocation = user.location;

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Edit your profile', style: TextStyle(fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily), textScaleFactor: 1),
          trailing: GestureDetector(
            onTap: () {
              if (usernameController.text.length > 16) {
                Authentication.showErrorDialog(context, 'Username should contain at most 16 characters');
              } else {
                user.update(usernameController.text, _selectedLocation);
                // Navigator.pushNamedAndRemoveUntil(
                //     context,
                //     'userpage',
                //     ModalRoute.withName('userpage'),
                //     arguments: user
                // );
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, 'userpage', arguments: user);
              }
            },
            child: const Icon(CupertinoIcons.checkmark)
          ),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(0, 15, 0, 34),
          child: CupertinoFormSection.insetGrouped(
              header: Text('Your profile'.toUpperCase()),
              children: [
                CupertinoFormRow(
                  prefix: const Text('Username'),
                  padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                  child: CupertinoTextFormFieldRow(
                    controller: usernameController,
                    placeholder: 'Username',
                  ),
                ),
                CupertinoFormRow(
                  prefix: const Text('Location'),
                  padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                  child: PullDownButton(
                      position: PullDownMenuPosition.under,
                      itemBuilder: (context) {
                        return Location.values
                            .map((loc) => PullDownMenuItem(
                            title: loc.fullName,
                            textStyle: TextStyle(
                              color: CupertinoColors.black,
                              fontFamily: CupertinoTheme.of(context).textTheme.textStyle.fontFamily,
                            ),
                            onTap: () {
                              _selectedLocation = loc.index;
                            })
                        ).toList();
                      },
                      buttonBuilder: (context, showMenu) {
                        return Container(
                            padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                            child: CupertinoButton(
                                minSize: 32,
                                color: CupertinoColors.tertiarySystemFill,
                                onPressed: showMenu,
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Text(
                                    Location.values[_selectedLocation].fullName,
                                    style: const TextStyle(color: CupertinoColors.black)
                                )
                            )
                        );
                      }
                  ),
                )
              ]
          )
        )
    );
  }
}
