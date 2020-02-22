import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taksi/providers/usuario.dart';

class UserProfilePage extends StatelessWidget {
  var context;
  UserProfilePage(this.context);
  String _status = '';

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.5, //2.6
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Provider.of<Usuario>(context).foto != null
              ? NetworkImage(Provider.of<Usuario>(context).foto)
              : AssetImage('assets/person.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Provider.of<Usuario>(context).foto != null
                ? NetworkImage(Provider.of<Usuario>(context).foto)
                : AssetImage('assets/person.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 10.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      Provider.of<Usuario>(context).nombre,
      style: _nameTextStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildStatus(BuildContext context) {
    if (Provider.of<Usuario>(context).inicio == 'facebook') {
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
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildGetInTouch(BuildContext context) {
    String califi;
    if (Provider.of<Usuario>(context).calificacion.isEmpty) {
      califi = 'Aun no tienes calificación';
    } else {
      califi = Provider.of<Usuario>(context).calificacion;
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
                  leading: Icon(Icons.email),
                  subtitle: Text(Provider.of<Usuario>(context).correo),
                ),
                ListTile(
                  title: Text("Teléfono"),
                  leading: Icon(Icons.phone),
                  subtitle: Text(Provider.of<Usuario>(context).telefono),
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

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildCoverImage(screenSize),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 6.4),
                  _buildProfileImage(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildFullName(),
                  _buildStatus(context),
                  SizedBox(height: 10.0),
                  _buildGetInTouch(context),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
