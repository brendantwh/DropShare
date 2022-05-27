import 'package:flutter/cupertino.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String login = 'Login';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: CupertinoTextField(
                  controller: nameController,
                  placeholder: 'Username',
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
                    child: const Text('Login'),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, 'listings');
                    },
                  ))
            ],
          )
        )

        );
  }
}
