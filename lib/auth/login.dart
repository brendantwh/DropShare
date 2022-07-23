import 'package:flutter/cupertino.dart';
import 'authentication.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Authentication auth = Authentication();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool loading = false;

    return WillPopScope(
        onWillPop: () async => false,
        child: CupertinoPageScaffold(
          child: SafeArea(
            minimum: const EdgeInsets.fromLTRB(20, 0, 20, 34),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: 10,
                    children: const [
                      Text('👋', style: TextStyle(fontSize: 28)),
                      Text(
                        'Welcome to DropShare',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
                StatefulBuilder(
                  builder: (context, innerSetState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 40, 0, 5),
                          child: CupertinoTextField(
                            textInputAction: TextInputAction.next,
                            clearButtonMode: OverlayVisibilityMode.editing,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: CupertinoColors.separator)
                            ),
                            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                            key: const Key('login_email'),
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            placeholder: 'NUS email',
                            autocorrect: false,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                          child: CupertinoTextField(
                            clearButtonMode: OverlayVisibilityMode.editing,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: CupertinoColors.separator)
                            ),
                            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                            onSubmitted: (_) {
                              if (emailController.text.isEmpty) {
                                Authentication.showErrorDialog(context, 'Email field is empty');
                              } else if (passwordController.text.isEmpty) {
                                Authentication.showErrorDialog(context, 'Password field is empty');
                              } else {
                                try {
                                  innerSetState(() => loading = true);
                                  auth.signIn(
                                      email: emailController.text.trim(),
                                      password: passwordController.text).then((result) {
                                    innerSetState(() => loading = false);
                                    if (result == null) {
                                      Authentication.authRedirect(context);
                                    } else {
                                      Authentication.showErrorDialog(context, result);
                                    }
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              }
                            },
                            key: const Key('login_key'),
                            obscureText: true,
                            controller: passwordController,
                            placeholder: 'Password',
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                            child: CupertinoButton(
                              key: const Key('login_button'),
                              color: CupertinoColors.systemGreen,
                              disabledColor: CupertinoColors.inactiveGray,
                              onPressed: loading ? null : ()  {
                                if (emailController.text.isEmpty) {
                                  Authentication.showErrorDialog(context, 'Email field is empty');
                                } else if (passwordController.text.isEmpty) {
                                  Authentication.showErrorDialog(context, 'Password field is empty');
                                } else {
                                  try {
                                    innerSetState(() => loading = true);
                                    auth.signIn(
                                        email: emailController.text.trim(),
                                        password: passwordController.text).then((result) {
                                      innerSetState(() => loading = false);
                                      if (result == null) {
                                        Authentication.authRedirect(context);
                                      } else {
                                        Authentication.showErrorDialog(context, result);
                                      }
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              },
                              child: loading ? const CupertinoActivityIndicator(color: CupertinoColors.white) : const Text('Login', style: TextStyle(fontWeight: FontWeight.w600)),
                            )
                        )
                      ],
                    );
                  },
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Text('or ', style: TextStyle(fontSize: 16, color: CupertinoColors.secondaryLabel)),
                        GestureDetector(
                          key: const Key('sign up here'),
                          child: const Text('sign up', style: TextStyle(fontSize: 16, color: CupertinoColors.activeBlue, fontWeight: FontWeight.w600)),
                          onTap: () => Navigator.pushNamed(context, 'signup'),
                        )
                      ],
                    )
                )
              ],
            ),
          )
        )
    );
  }
}
