import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taksi/providers/usuario.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        title: Text("Taksi",style: TextStyle(color: Colors.black),),
        iconTheme: IconThemeData(color: Colors.pink),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text(Provider.of<Usuario>(context).correo),
              accountName: Text(Provider.of<Usuario>(context).nombre),
              currentAccountPicture: CircleAvatar(child: Image.network(Provider.of<Usuario>(context).foto),),

            )
          ],
        ),
      ),
    );
  }
}
