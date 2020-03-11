import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taksi/dialogs/dialogError.dart';
import 'package:taksi/login/ingresarCodigo.dart';
import 'package:taksi/login/login.dart';
import 'package:taksi/providers/estilos.dart';
import 'package:taksi/providers/usuario.dart';

final GlobalKey<ScaffoldState> scaffoldKey2 = GlobalKey<ScaffoldState>();
final FirebaseAuth _auth = FirebaseAuth.instance;

class PhoneSignInSection extends StatefulWidget {
  String nombre, correo, foto, inicio;
  PhoneSignInSection(this.nombre, this.correo, this.foto, this.inicio);
  @override
  State<StatefulWidget> createState() =>
      PhoneSignInSectionState(nombre, correo, foto, inicio);
}

class PhoneSignInSectionState extends State<PhoneSignInSection> {

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  String _message = '';
  String _verificationId;
  String nombre, correo, foto, inicio;
  PhoneSignInSectionState(this.nombre, this.correo, this.foto, this.inicio);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey2,
      appBar: AppBar(
        elevation: 0,
        title: Estilos().estilo2(context, 'Completa tu información'),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Nombre',
                          style: TextStyle(fontSize: 17, color: Colors.black54),
                          textAlign: TextAlign.justify,
                        ),
                        Text(
                          nombre,
                          style: TextStyle(fontSize: 19),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Correo',
                          style: TextStyle(fontSize: 17, color: Colors.black54),
                          textAlign: TextAlign.justify,
                        ),
                        Text(
                          correo,
                          style: TextStyle(fontSize: 19),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          child: const Text(
                            'Ingrese su número de teléfono y recibirá un '
                                'código de verificación',
                            style:
                            TextStyle(fontSize: 17, color: Colors.black54),
                            textAlign: TextAlign.justify,
                          ),
                          alignment: Alignment.center,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: _phoneNumberController,
                          maxLength: 10,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 20),
                          decoration: InputDecoration(
                              prefixText: "+52 ",
                              icon: Image.asset(
                                //prefixIcon
                                "assets/mexico.png",
                                height: 30,
                                scale: 2,
                              ),
                              labelText: 'Número telefónico'),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          alignment: Alignment.center,
                          child: FlatButton(
                            onPressed: () async {
                              if (_phoneNumberController.text.isNotEmpty) {
                                if (_phoneNumberController.text.length < 10) {
                                  scaffoldKey2.currentState.showSnackBar(SnackBar(
                                      content: Text(
                                          'Ingrese un número de teléfono valido')));
                                } else {
                                  _verifyPhoneNumber();
                                }
                              } else {
                                scaffoldKey2.currentState.showSnackBar(SnackBar(
                                    content:
                                    Text('Ingrese su número de teléfono')));
                              }
                            },
                            child: const Text('Continuar'),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Al precionar continuar, confirmo que leí y estoy de acuerdo con los términos y condiones por el uso del servicio',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.justify,
                        ),
                        /*TextField(
                          controller: _smsController,
                          decoration:
                              const InputDecoration(labelText: 'Codigo de verificación'),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: RaisedButton(
                            onPressed: () async {
                              _signInWithPhoneNumber();
                            },
                            child: const Text('iniciar sesion'),
                          ),
                        ),*/
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            _message,
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Example code of how to verify phone number
  void _verifyPhoneNumber() async {
    var firebaseAuth = await FirebaseAuth.instance;
    setState(() {
      _message = '';
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      setState(() {
        _message = 'Código de verificación de recuperación automática';
      });

      firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((AuthResult value) async {
        if (value.user != null) {
          setState(() {
            _message = 'Bienvenido a Tak-si';
          });

          Firestore.instance
              .collection('usuarios')
              .where('telefono', isEqualTo: '+52' + _phoneNumberController.text)
              .getDocuments().then((verificar) {
            if (verificar.documents.isEmpty) {
              Firestore.instance.collection('usuarios').document().setData({
                'telefono': '+52' + _phoneNumberController.text,
                'codigos': FieldValue.arrayUnion([''])
              });
              print('datos creados');
            } else {
              print('datos no creados');
            }
          });

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('correo', correo);
          prefs.setString('nombre', nombre);
          prefs.setString('foto', foto);
          prefs.setString('telefono', '+52' + _phoneNumberController.text);
          prefs.setString('inicio', inicio);

          onAuthenticationSuccessful();
        } else {
          setState(() {
            dialogError().Dialog_Error(
                context, 'Verifique su código', 'Código invalido', 'login');
            _message = '';
          });
        }
      }).catchError((error) {
        setState(() {
          dialogError().Dialog_Error(context, 'Lo sentimos',
              'Algo salió mal, por favor intente más tarde', 'login');
          _message = '';
        });
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        if (authException.message.contains('not authorized')) {
          dialogError().Dialog_Error(context, 'Lo sentimos',
              'Algo salió mal, por favor intente mas tarde', 'login');
          _message = '';
        } else if (authException.message.contains('Network')) {
          dialogError().Dialog_Error(context, 'Lo sentimos',
              'Verifique su conexión a Internet e intente nuevamente', 'login');
          _message = '';
        } else {
          dialogError().Dialog_Error(context, 'Lo sentimos',
              'Algo salió mal, por favor intente más tarde', 'login');
          _message = '';
        }
        //_message = 'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      scaffoldKey2.currentState.showSnackBar(SnackBar(
        content: Text('Código enviado al número ' +
            _phoneNumberController.text.toString()),
      ));
      _verificationId = verificationId;
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => Codigo(_auth, _verificationId, correo,
                  nombre, foto, inicio, '+52' + _phoneNumberController.text)));
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: '+52' + _phoneNumberController.text,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  // Example code of how to sign in with phone.
  void _signInWithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsController.text,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        _message = 'Successfully signed in, uid: ' + user.uid;
      } else {
        _message = 'Sign in failed';
      }
    });
  }

/*
  void _signInWithPhoneNumber(String smsCode) async {
    _authCredential = await PhoneAuthProvider.getCredential(
        verificationId: actualCode, smsCode: smsCode);
    firebaseAuth.signInWithCredential(_authCredential).catchError((error) {
      setState(() {
        status = 'Something has gone wrong, please try later';
      });
    }).then((FirebaseUser user) async {
      setState(() {
        status = 'Authentication successful';
      });
      onAuthenticationSuccessful();
    });
  }
*/

  void onAuthenticationSuccessful() {
    Provider.of<Usuario>(context).correo = correo;
    Provider.of<Usuario>(context).nombre = nombre;
    Provider.of<Usuario>(context).foto = foto;
    Provider.of<Usuario>(context).inicio = inicio;
    Provider.of<Usuario>(context).telefono =
        '+52' + _phoneNumberController.text;
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
