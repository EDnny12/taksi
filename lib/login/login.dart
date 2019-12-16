import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:taksi/providers/usuario.dart';
import 'package:taksi/screen/main_screen.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;
class Log extends StatefulWidget {
  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<Log> {


  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    if(user.email!=null){
      Provider.of<Usuario>(context).correo=user.email;
      Provider.of<Usuario>(context).nombre=user.displayName;
      Provider.of<Usuario>(context).foto= user.photoUrl;
      Navigator.push(context, CupertinoPageRoute(builder: (context)=>Menu()));
    }


    return user;
  }



  SingleChildScrollView loginUI(){
    return    SingleChildScrollView(
      child: Padding(

        padding: const EdgeInsets.all(18.0),

        child: Card(

          child: Padding(
            padding:   EdgeInsets.all(MediaQuery.of(context).size.width*0.1),
            child: Column(

              children: <Widget>[
                const SizedBox(height: 15.0),
                Image.asset("assets/logo.png",scale: 1.0),

               const SizedBox(
                 height: 1.0,
               ),
                ListTile(
                    title: const Text("¡Organiza tu viaje!",textAlign: TextAlign.center,style: const TextStyle(fontWeight: FontWeight.bold),)),
               const SizedBox(
                 height: 10.0,
               ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FacebookSignInButton(onPressed: () {
                        // call authentication logic
                      },
                        borderRadius: 12.0,
                        text: "Facebook",
                      ),

                      const SizedBox(width: 5.0,),
                      GoogleSignInButton(
                        text: "Google",
                        onPressed: () {
                          _handleSignIn();
                        },
                        borderRadius: 12.0,
                      ),
                    ],
                  ),
                )




              ],
            ),
          ),

          elevation: 10.0,
          shape:  RoundedRectangleBorder(
              borderRadius:  BorderRadius.circular(20.0)),
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            fondo(),
            Center(child: loginUI()),


          ],
        ),
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
            colors: [Colors.blue, Colors.red]
        )
      ),
    );
  }
}

class fondo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Stack(children: <Widget>[

       Positioned(
         top: -(size.width)*0.9,

         child: Container(
           width: size.height*0.6,
           height: size.height*0.6,
           decoration:BoxDecoration(
             //color: Color(0xFFFA8072),
             color: Colors.red[200],
             borderRadius: BorderRadius.circular(600.0)
           ) ,
         ),
       ),
      Positioned(
        top: -(size.width)*0.7,
        left: -(size.width)*0.65,
        child: RotatedBox(
         quarterTurns: 1,
          child: Container(
            width: size.height*0.6,
            height: size.height*0.6,
            decoration:BoxDecoration(
               // color:Color(0xFFFFD700),
                color: Colors.pink[300],
                borderRadius: BorderRadius.circular(1000.0)
            ) ,
          ),
        ),
      ),
      Positioned(
       bottom: -(size.width)*0.75,
        right: -(size.width)*0.85,
        child: Container(
          width: size.height*0.6,
          height: size.height*0.6,
          decoration:BoxDecoration(
              //color: Color(0xFFFFD700),
               color: Colors.pink[300],
              borderRadius: BorderRadius.circular(2000.0)
          ) ,
        ),
      ),



    ],

    );
  }
}

