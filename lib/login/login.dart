import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taksi/dialogs/dialogError.dart';
import 'package:taksi/dialogs/loader.dart';
import 'package:taksi/login/phone_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;
Map userProfile;

class Log extends StatefulWidget {
  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<Log> {
  @override
  void initState() {
    //currentUser();
    super.initState();
  }

  void facebookLogin() async {

    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        userProfile = profile;
        Navigator.of(context).pop();
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => PhoneSignInSection(userProfile["name"],
                    userProfile["email"], userProfile["picture"]["data"]["url"], 'facebook')));
        break;
      case FacebookLoginStatus.cancelledByUser:
        Navigator.of(context).pop();
        print("cancelo");
        break;
      case FacebookLoginStatus.error:
        Navigator.of(context).pop();
        dialogError().Dialog_Error(context, 'Error al iniciar sesión',
            'Ocurrio un error al iniciar sesión, por favor intentelo de nuevo', 'login');
        print(result.errorMessage);
        break;
    }
  }

  /*void onLoginFb(final token) async {
    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: token,
    );
    final FirebaseUser = (await _auth.signInWithCredential(credential)).user;

    Provider.of<Usuario>(context).correo = FirebaseUser.email;
    Provider.of<Usuario>(context).nombre = FirebaseUser.displayName;
    Provider.of<Usuario>(context).foto = FirebaseUser.photoUrl;
    Provider.of<Usuario>(context).telefono = FirebaseUser.phoneNumber;
  }*/

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser =
        await _googleSignIn.signIn().catchError((error) {
          Navigator.of(context).pop();
          dialogError().Dialog_Error(context, 'Error al iniciar sesión',
              'Ocurrio un error al iniciar sesión, por favor intentelo de nuevo', 'login');
      print('error al iniciar sesion');
    });
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    /*final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );*/
    if (googleUser.displayName != null) {

      print(googleUser.displayName);
      Navigator.of(context).pop();
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => PhoneSignInSection(googleUser.displayName,
                  googleUser.email, googleUser.photoUrl, 'google')));
    }

    /*final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    if (user.email != null) {
      //Provider.of<Usuario>(context).correo = user.email;
      //Provider.of<Usuario>(context).nombre = user.displayName;
      //Provider.of<Usuario>(context).foto = user.photoUrl;
      //Provider.of<Usuario>(context).telefono = user.phoneNumber;
    }*/

    //return user;
  }

  SingleChildScrollView loginUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 15.0),
                Image.asset("assets/logo.png", scale: 1.2),
                const SizedBox(height: 10.0,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FacebookSignInButton(
                      onPressed: () {
                        // call authentication logic
                        Loader().ShowCargando(context, 'Iniciando sesión con Facebook');
                        facebookLogin();
                      },
                      borderRadius: 12.0,
                      text: "Facebook",
                    ),
                    const SizedBox(height: 10.0,),
                    GoogleSignInButton(
                      text: "Google",
                      onPressed: () {
                        Loader().ShowCargando(context, 'Iniciando sesión con Google');
                        _handleSignIn();
                      },
                      borderRadius: 12.0,
                    ),
                  ],
                )
              ],
            ),
          ),
          elevation: 10.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
      ),
    );
  }

  /*Future<void> currentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _auth.currentUser().then((use) {
      if (use != null) {
        if (use.phoneNumber != null) {
          Provider.of<Usuario>(context).telefono = use.phoneNumber;
          Provider.of<Usuario>(context).correo = prefs.getString('correo');
          Provider.of<Usuario>(context).nombre = prefs.getString('nombre');
          Provider.of<Usuario>(context).foto = prefs.getString('foto');
          Provider.of<Usuario>(context).inicio = prefs.getString('inicio');
        }
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          fondo(),
          Center(child: loginUI()),
        ],
      ),
    );
  }
}

class gradiente extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blue, Colors.red])),
    );
  }
}

class fondo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Positioned(
          top: -(size.width) * 0.9,
          child: Container(
            width: size.height * 0.6,
            height: size.height * 0.6,
            decoration: BoxDecoration(
                //color: Color(0xFFFA8072),
                color: Colors.blue[300],
                borderRadius: BorderRadius.circular(600.0)),
          ),
        ),
        Positioned(
          top: -(size.width) * 0.7,
          left: -(size.width) * 0.65,
          child: RotatedBox(
            quarterTurns: 1,
            child: Container(
              width: size.height * 0.6,
              height: size.height * 0.6,
              decoration: BoxDecoration(
                  // color:Color(0xFFFFD700),
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(1000.0)),
            ),
          ),
        ),
        Positioned(
          bottom: -(size.width) * 0.75,
          right: -(size.width) * 0.85,
          child: Container(
            width: size.height * 0.6,
            height: size.height * 0.6,
            decoration: BoxDecoration(
                //color: Color(0xFFFFD700),
                color: Colors.blue,
                borderRadius: BorderRadius.circular(2000.0)),
          ),
        ),
        Positioned(
          bottom: -(size.width) * 0.7,
          left: -(size.width) * 0.65,
          child: Container(
            width: size.height * 0.6,
            height: size.height * 0.6,
            decoration: BoxDecoration(
                //color: Color(0xFFFFD700),
                color: Colors.blue[300],
                borderRadius: BorderRadius.circular(2000.0)),
          ),
        ),
      ],
    );
  }
}
