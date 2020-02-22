import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taksi/dialogs/dialogError.dart';
import 'package:taksi/login/login.dart';
import 'package:taksi/providers/estilos.dart';
import 'package:taksi/providers/usuario.dart';


final GlobalKey<ScaffoldState> scaffoldKey2 = GlobalKey<ScaffoldState>();

class Codigo extends StatefulWidget {

  FirebaseAuth auth;
  String correo;
  String nombre;
  String foto;
  String inicio;
  String telefono;
  String verificationId;
  Codigo(this.auth, this.verificationId, this.correo, this.nombre, this.foto, this.inicio, this.telefono);

  @override
  _CodigoState createState() => _CodigoState(auth,verificationId, correo, nombre, foto, inicio, telefono);
}

class _CodigoState extends State<Codigo> {

  final TextEditingController _codigoController = TextEditingController();

  FirebaseAuth _auth;
  String _correo;
  String _nombre;
  String _foto;
  String _inicio;
  String _telefono;
  String _verificationId;
  _CodigoState(this._auth, this._verificationId, this._correo, this._nombre, this._foto, this._inicio, this._telefono);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey2,
      appBar: AppBar(
        elevation: 0,
        title: Estilos().estilo2(context, 'Código de verificación'),
        iconTheme: Estilos().colorIcon(context),
      ),
      body: Stack(
        children: <Widget>[
          fondo(),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 10.0,),
                        Image.asset("assets/logo.png", scale: 1.2),
                        const SizedBox(height: 10.0,),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: _codigoController,
                          maxLength: 6,
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                          decoration: InputDecoration(
                              labelText: 'Código de verificación'),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          alignment: Alignment.center,
                          child: FlatButton(
                            onPressed: () async {
                              if (_codigoController.text.isNotEmpty) {
                                if (_codigoController.text.length < 6) {
                                  scaffoldKey2.currentState.showSnackBar(SnackBar(
                                      content:
                                      Text('Ingrese un código valido')));
                                } else {
                                  _signInWithPhoneNumber();
                                }
                                //_verifyPhoneNumber();
                              } else {
                                scaffoldKey2.currentState.showSnackBar(SnackBar(
                                    content:
                                    Text('Ingrese el código de verificación')));
                              }
                            },
                            child: const Text('Verificar'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  void _signInWithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _codigoController.text,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() async {
      if (user != null) {
        print('bienvenido');
        Firestore.instance
            .collection('usuarios')
            .where('telefono', isEqualTo: _telefono)
            .getDocuments().then((verificar) {
          if (verificar.documents.isEmpty) {
            Firestore.instance.collection('usuarios').document().setData({
              'telefono': _telefono,
              'codigos': FieldValue.arrayUnion([''])
            });
            print('datos creados');
          } else {
            print('datos no creados');
          }
        });


        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('correo', _correo);
        prefs.setString('nombre', _nombre);
        prefs.setString('foto', _foto);
        prefs.setString('telefono', _telefono);
        prefs.setString('inicio', _inicio);

        onAuthenticationSuccessful();
        //_message = 'Successfully signed in, uid: ' + user.uid;
      } else {
        print('ocurrio un error');
        dialogError().Dialog_Error(
            context, 'Lo sentimos', 'Algo salio mal, por favor intentelo mas tarde', 'login');
        //_message = 'Sign in failed';
      }
    });
  }

  void onAuthenticationSuccessful() {
    Provider.of<Usuario>(context).correo = _correo;
    Provider.of<Usuario>(context).nombre = _nombre;
    Provider.of<Usuario>(context).foto = _foto;
    Provider.of<Usuario>(context).inicio = _inicio;
    Provider.of<Usuario>(context).telefono = '+52' + _telefono;
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
