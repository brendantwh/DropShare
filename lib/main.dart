// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dropshare/listings/indiv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'listings/listingspage.dart';
import 'auth/login.dart';
import 'auth/signup.dart';
import 'listings/create.dart';

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
            FirebaseAuth.instance.currentUser == null ? 'login' : 'listings',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case 'listings':
              return CupertinoPageRoute(builder: (_) => const ListingsPage(), settings: settings);
            case 'login':
              return CupertinoPageRoute(builder: (_) => const Login(), settings: settings);
            case 'signup':
              return CupertinoPageRoute(builder: (_) => const Signup(), settings: settings);
            case 'create':
              return CupertinoPageRoute(builder: (_) => const Create(), settings: settings);
            case 'indiv':
              return CupertinoPageRoute(builder: (context) => const IndivListing(), settings: settings);
          }
        }
    );
  }
}