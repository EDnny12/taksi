import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController login = TextEditingController();
  TextEditingController contrasena = TextEditingController();

  TextFormField campos(final text, final controller,final pass) {
    return !pass ?TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        filled: true,
        hintText: text,

      ),
    ):TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        filled: true,
        hintText: text,

       suffixIcon:
       GestureDetector(
         onTap: () {

         },
         child: Icon(
          Icons.visibility
         ),
       ),
      ),
    );
  }

  RaisedButton aceptar() {
    return RaisedButton(
      child: const Text("Iniciar Sesión"),
      shape: StadiumBorder(),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/logo.png"),

            campos("Usuario", login,false),
            const SizedBox(
              height: 10.0,
            ),
            campos("Contraseña", contrasena,true),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: <Widget>[

               FlatButton(
                 padding: EdgeInsets.all(0.0),
                 child: const Text("¿Olvidaste tu contraseña?",
                   style: const TextStyle(fontStyle: FontStyle.italic),
                 ),
                 onPressed: () {},
               ),
               FlatButton(
                 padding: EdgeInsets.all(0.0),
                 child: const Text("Registrarse",
                   style: const TextStyle(fontStyle: FontStyle.italic)
                 ),
                 onPressed: () {},
               ),
             ],
           )
             ,

           const SizedBox(
              height: 60.0,
            ),

            SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: 40.0,
                child: aceptar()),

            const SizedBox(height: 50.0,),

                 FacebookSignInButton(onPressed: () {
                    // call authentication logic
                  },
                    borderRadius: 12.0,
                    text: "Iniciar con Facebook",
                  ),

                   const SizedBox(height: 10.0,),
                   GoogleSignInButton(
                    text: "Iniciar con Google",
                    onPressed: () {/* ... */},
                    borderRadius: 12.0,
                  ),



          ],
        ),
      ),
    );
  }
}
