// Cupertino design
import 'package:flutter/cupertino.dart';

import 'dart:io';

// Firebase packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_options.dart';

// DropShare pages
import 'admin/admindashboard.dart';
import 'admin/adminhome.dart';
import 'admin/reportlist.dart';
import 'admin/userlist.dart';
import 'auth/login.dart';
import 'auth/signup.dart';
import 'auth/verify.dart';
import 'chat/chat.dart';
import 'chat/chatlist.dart';
import 'listings/create.dart';
import 'listings/indiv.dart';
import 'listings/listingspage.dart';
import 'search/searchpage.dart';
import 'search/typesenseConfig.dart';
import 'user/profile.dart';
import 'user/modifypage.dart';
import 'user/usertyperedirect.dart';

bool useEmulator = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options:DefaultFirebaseOptions.currentPlatform);
  if (useEmulator) {
    FirebaseFirestore.instance.settings = const Settings(host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
    FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }
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
                : 'userTypeRedirect',
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
              return CupertinoPageRoute(builder: (context) => const Profile(), settings: settings);
            case 'modifypage':
              return CupertinoPageRoute(builder: (context) => const ModifyPage(), settings: settings);
            case 'typesenseConfig':
              return CupertinoPageRoute(builder: (_) => const TypesenseConfig(), settings: settings);
            case 'search':
              return CupertinoPageRoute(builder: (_) => const SearchPage(), settings: settings);
            case 'adminDash':
              return CupertinoPageRoute(builder: (context) => const AdminDashboard(), settings: settings);
            case 'userlist':
              return CupertinoPageRoute(builder: (_) => const UserList(), settings: settings);
            case 'reportlist':
              return CupertinoPageRoute(builder: (_) => const ReportList(), settings: settings);
            case 'userTypeRedirect':
              return CupertinoPageRoute(builder: (_) => const UserTypeRedirect(), settings: settings);
            case 'adminHome':
              return CupertinoPageRoute(builder: (_) => const AdminHome(), settings: settings);
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