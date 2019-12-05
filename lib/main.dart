import 'package:flutter/material.dart';

import 'login/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TAK-SI',

      theme: ThemeData(
        // fontFamily: "Bebas",
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

