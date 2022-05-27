// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'listings.dart';
import 'login.dart';
import 'create.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options:DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'DropShare',
      home: const CupertinoPageScaffold(
          child: Login(),
        ),
      routes: {
        'listings': (_) => const Listings(),
        'login': (_) => const Login(),
        'create': (_) => const Create(),
      }
      );
  }
}
