// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'listings.dart';
import 'login.dart';
import 'create.dart';

void main() {
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
