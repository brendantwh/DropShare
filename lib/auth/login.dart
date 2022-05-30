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
    return CupertinoPageScaffold(
        child: Center(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(10, 100, 10, 10),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: CupertinoTextField(
                  controller: emailController,
                  placeholder: 'Email',
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: CupertinoTextField(
                  obscureText: true,
                  controller: passwordController,
                  placeholder: 'Password',
                ),
              ),
              Container(
                  height: 70,
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: CupertinoButton(
                    color: CupertinoColors.systemGreen,
                    child: const Text('Login'),
                    onPressed: () async {
                      if (emailController.text.isEmpty) {
                        Authentication.showErrorDialog(context, 'Email field is empty');
                      } else if (passwordController.text.isEmpty) {
                        Authentication.showErrorDialog(context, 'Password field is empty');
                      } else {
                        try {
                          await auth.signIn(
                              email: emailController.text,
                              password: passwordController.text).then((result) {
                            if (result == null) {
                              Authentication.showSuccessDialog(
                                  context, 'signed in');
                            } else {
                              Authentication.showErrorDialog(context, result);
                            }
                          });
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                  )
              ),
              Container(
                  height: 70,
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: CupertinoButton(
                    child: const Text('Sign up here'),
                    onPressed: () {
                      Navigator.pushNamed(context, 'signup');
                    },
                  ))
            ],
          )
        )
    );
  }
}
