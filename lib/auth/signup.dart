import 'package:flutter/cupertino.dart';
import 'authentication.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final Authentication auth = Authentication();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
            middle: Text('Sign up')
        ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
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
                  child: CupertinoButton.filled(
                    child: const Text('Sign up'),
                    onPressed: () async {
                      try {
                        await auth.signUp(email: emailController.text, password: passwordController.text).then((result) {
                          if (result == null) {
                            Authentication.showSuccessDialog(context, 'registered account');
                          } else {
                            Authentication.showErrorDialog(context, result);
                          }
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                  ))
            ],
          )
        )

        );
  }
}