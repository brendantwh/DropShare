// Cupertino design
import 'package:dropshare/chat/chatlist.dart';
import 'package:flutter/cupertino.dart';

import 'dart:io';

// Firebase packages
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// DropShare pages
import 'auth/login.dart';
import 'auth/signup.dart';
import 'auth/verify.dart';
import 'chat/chat.dart';
import 'listings/create.dart';
import 'listings/indiv.dart';
import 'listings/listingspage.dart';
import 'user/userpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options:DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        title: 'DropShare',
        navigatorKey: _navigatorKey,
        initialRoute:
            FirebaseAuth.instance.currentUser == null
                ? 'login'
                : FirebaseAuth.instance.currentUser!.emailVerified
                ? 'listings'
                : 'verify',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case 'listings':
              return CupertinoPageRoute(builder: (_) => const ListingsPage(), settings: settings);
            case 'login':
              return CupertinoPageRoute(builder: (_) => const Login(), settings: settings);
            case 'signup':
              return CupertinoPageRoute(builder: (_) => const Signup(), settings: settings);
            case 'verify':
              return CupertinoPageRoute(builder: (_) => const Verify(), settings: settings);
            case 'create':
              return CupertinoPageRoute(builder: (_) => const Create(), settings: settings);
            case 'indiv':
              return CupertinoPageRoute(builder: (context) => const IndivListing(), settings: settings);
            case 'chat':
              return CupertinoPageRoute(builder: (context) => const Chat(), settings: settings);
            case 'chatlist':
              return CupertinoPageRoute(builder: (context) => const Chatlist(), settings: settings);
            case 'userpage':
              return CupertinoPageRoute(builder: (_) => const Userpage(), settings: settings);
          }
        },
        theme: Platform.isIOS
            ? const CupertinoThemeData(brightness: Brightness.light) // Force light mode
            : const CupertinoThemeData(
                brightness: Brightness.light,  // Force light mode
                textTheme: CupertinoTextThemeData(
                  textStyle: TextStyle(
                      color: CupertinoColors.black,
                      fontFamily: 'Inter'
                  )
                )
              )
    );
  }
}