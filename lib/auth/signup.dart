import 'package:flutter/cupertino.dart';
import 'authentication.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final Authentication auth = Authentication();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool loading = false;

    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
            middle: Text('Sign up')
        ),
        child: Center(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: CupertinoTextField(
                  controller: usernameController,
                  placeholder: 'Username',
                  autocorrect: false,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: CupertinoTextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  placeholder: 'NUS email',
                  autocorrect: false,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: CupertinoTextField(
                  obscureText: true,
                  controller: passwordController,
                  placeholder: 'Password',
                ),
              ),
              Container(
                  height: 70,
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: StatefulBuilder(
                    builder: (context, innerSetState) {
                      return CupertinoButton.filled(
                        disabledColor: CupertinoColors.inactiveGray,
                        onPressed: loading
                            ? null
                            : () async {
                              if (usernameController.text.isEmpty) {
                                Authentication.showErrorDialog(context, 'Username field is empty');
                              } else if (usernameController.text.length > 16) {
                                Authentication.showErrorDialog(context, 'Username should contain at most 16 characters');
                              } else if (emailController.text.isEmpty) {
                                Authentication.showErrorDialog(context, 'Email field is empty');
                              } else if (passwordController.text.isEmpty) {
                                Authentication.showErrorDialog(context, 'Password field is empty');
                              } else {
                                if (!(emailController.text.trim().toLowerCase().endsWith('nus.edu')) && !(emailController.text.trim().toLowerCase().endsWith('nus.edu.sg'))) {
                                  Authentication.showErrorDialog(context, 'Use a valid NUS email');
                                } else {
                                  try {
                                    innerSetState(() => loading = true);
                                    await auth.signUp(username: usernameController.text.trim(), email: emailController.text.trim(), password: passwordController.text).then((result) {
                                      if (result == null) {
                                        auth.createUsername(usernameController.text);
                                        Navigator.pushNamedAndRemoveUntil(context, 'verify', (Route<dynamic> route) => false);
                                      } else {
                                        innerSetState(() => loading = false);
                                        Authentication.showErrorDialog(context, result);
                                      }
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              }
                            },
                        child: loading ? const CupertinoActivityIndicator(color: CupertinoColors.white) : const Text('Sign up'),
                      );
                    },
                  )
              )
            ],
          )
        )

        );
  }
}