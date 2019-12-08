import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taksi/providers/usuario.dart';
import 'login/login.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>Usuario()),
      ],
      child: MaterialApp(
        title: 'TAK-SI',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Log(),
      ),
    );
  }
}

