import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taksi/providers/usuario.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String _status = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false, //true
              pinned: true, //false
              //snap: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text('Mi cuenta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    )),
                background: Image.network(
                  Provider.of<Usuario>(context, listen: true).foto,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildFullName(),
              _buildStatus(context),
              SizedBox(height: 10.0),
              _buildGetInTouch(context),
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      Provider.of<Usuario>(context, listen: true).nombre,
      style: _nameTextStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildStatus(BuildContext context) {
    if (Provider.of<Usuario>(context, listen: true).inicio == 'facebook') {
      _status = 'Inició sesión con Facebook';
    } else {
      _status = 'Inició sesión con Google';
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        _status,
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildGetInTouch(BuildContext context) {
    String califi;
    if (Provider.of<Usuario>(context, listen: true).calificacion == null) {
      califi = 'Error al obtener su calificación';
    } else if (Provider.of<Usuario>(context, listen: true).calificacion.isEmpty) {
      califi = 'Aun no tienes calificación';
    } else {
      califi = Provider.of<Usuario>(context, listen: true).calificacion;
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
          child: Container(
            height: 200,
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 0,
                ),
                ListTile(
                  title: Text("Correo Electrónico"),
                  leading: Icon(Icons.email, color: Colors.lightBlue,),
                  subtitle: Text(Provider.of<Usuario>(context, listen: true).correo),
                ),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      Text("Teléfono"),
                      SizedBox(width: 5,),
                      Icon(FontAwesomeIcons.checkCircle, color: Colors.lightBlue,size: 15.0,),
                    ],
                  ),
                  leading: Icon(Icons.phone, color: Colors.lightBlue,),
                  subtitle: Text(Provider.of<Usuario>(context, listen: true).telefono),
                ),
                ListTile(
                  title: Text("Calificación"),
                  leading: Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  subtitle: Text(califi),
                ),
              ],
            ),
          ),
        ),
        elevation: 10.0,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

}

