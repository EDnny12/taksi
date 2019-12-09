import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:taksi/providers/metodos.dart';
class Log extends StatefulWidget {
  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<Log> {

  // Controladores para campos de texto de Login
  TextEditingController login = TextEditingController();
  TextEditingController contrasena = TextEditingController();

  //Controlador para el PageView
  PageController controlador=PageController();

  //Controladores para campos de texto de Registrarse
  TextEditingController nombre = TextEditingController();
  TextEditingController apellidos = TextEditingController();
  TextEditingController telefono = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController contra1 = TextEditingController();
  TextEditingController contra2 = TextEditingController();

  // Variable para manipular el estado de la visibilidad en login
  bool visibilidad=false;

  bool visibilidad1=false;
  bool visibilidad2=false;

  // Variable que almacena la foto de perfil
  var image=null;


  // Metodos para animar el PageView
   void registro(){
    controlador.animateToPage(1, duration: Duration(seconds: 1), curve: Curves.easeInOut);
   }
  void loginUp(){
    controlador.animateToPage(0, duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }

  // Array de iconos
  final iconos=[Icon(Icons.mail),Icon(Icons.person),Icon(Icons.phone)];

   final escritura=[TextInputType.emailAddress,TextInputType.text,TextInputType.phone];

   // Campo de texto para Login y Registro
  TextFormField campos(final text, final controller,final pass,final value) {
    return !pass ?TextFormField(
      controller: controller,
      keyboardType: escritura[value],
      decoration: InputDecoration(
        suffixIcon: iconos[value],
        border: const UnderlineInputBorder(),

        hintText: text,

      ),
    ):TextFormField(

      controller: controller,
      obscureText: value==10?!visibilidad:value==11?!visibilidad1:!visibilidad2,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        //filled: true,
        hintText: text,

        suffixIcon:
        GestureDetector(
          onTap: () {
            setState(() {
             if(value==10){
               visibilidad=!visibilidad;
             }else if(value==11){
               visibilidad1=!visibilidad1;
             }else{
               visibilidad2=!visibilidad2;
             }

            });
          },
          child: Icon(
              value==10 ? visibilidad ? Icons.visibility:Icons.visibility_off
              : value==11? visibilidad1 ? Icons.visibility:Icons.visibility_off
               :    visibilidad2 ? Icons.visibility:Icons.visibility_off
          ),
        ),
      ),
    );
  }


  // Boton para iniciar sesión
  RaisedButton aceptar() {
    return RaisedButton(
      child: const Text("Iniciar Sesión"),
      shape: StadiumBorder(),
      onPressed: () {},
    );
  }

  // Boton para registrarse
  RaisedButton registrarse() {
    return RaisedButton(
      child: const Text("Registrarse"),
      shape: StadiumBorder(),
      onPressed: () {},
    );
  }

  @override
  void dispose() {
    login.dispose();
    contrasena.dispose();
    controlador.dispose();
    super.dispose();
  }

  SingleChildScrollView loginUI(){
    return    SingleChildScrollView(
      child: Padding(

        padding: const EdgeInsets.all(18.0),

        child: Card(

          child: Padding(
            padding: EdgeInsets.only(left: 13.0,right: 13.0),
            child: Column(

              children: <Widget>[
                const SizedBox(height: 15.0),
                Image.asset("assets/logo.png",scale: 2.5),

                campos("Usuario", login,false,0),
                const SizedBox(
                  height: 10.0,
                ),
                campos("Contraseña", contrasena,true,10),

                const SizedBox(height: 1.0,),
                Align(
                  alignment: Alignment.topRight,

                  child: FlatButton(
                    padding: EdgeInsets.all(0.0),
                    child: const Text("¿Olvidaste tu contraseña?",

                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                    onPressed: () {},
                  ),
                ),



                const SizedBox(
                  height: 18.0,
                ),

                SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 40.0,
                    child: aceptar()),
                const SizedBox(height: 15.0,),
                Divider(),
                const SizedBox(height: 15.0,),
                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FacebookSignInButton(onPressed: () {
                      // call authentication logic
                    },
                      borderRadius: 12.0,
                      text: "Facebook",
                    ),

                    const SizedBox(height: 10.0,),
                    GoogleSignInButton(
                      text: "Google",
                      onPressed: () {/* ... */},
                      borderRadius: 12.0,
                    ),
                  ],
                )
                ,
                const SizedBox(height: 40.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    const Text("¿Aún no tienes cuenta?"),
                    const SizedBox(width: 5.0,),
                    FloatingActionButton(

                      onPressed: (){
                        registro();
                      },child: Icon(Icons.arrow_forward),

                    ),
                  ],
                ),
                const SizedBox(height: 5.0,),


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
  SingleChildScrollView registroUI(){
    return

      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),

          child: Card(

            child: Padding(
              padding: EdgeInsets.only(left: 13.0,right: 13.0),
              child: Column(

                children: <Widget>[

                  const SizedBox(height: 15.0),
                  Image.asset("assets/logo.png",scale: 2.5),



                  campos("Nombre", nombre,false,1),
                  const SizedBox(
                    height: 10.0,
                  ),
                  campos("Apellidos", apellidos,false,1),
                  const SizedBox(
                    height: 10.0,
                  ),

                  campos("Correo", correo,false,0),
                  const SizedBox(
                    height: 10.0,
                  ),






                  campos("Teléfono", telefono,false,2),
                  const SizedBox(
                    height: 10.0,
                  ),
                  campos("Contraseña", contra1,true,11),
                  const SizedBox(height: 10.0,),
                  campos("Confirmar contraseña", contra2,true,12),
                  ListTile(
                      onTap: (){
                        Metodos().selectImage().then((foto){
                          setState(() {

                            image=foto;
                          });
                        });
                      },
                      title: const Text("Seleccionar foto..."),
                      trailing: image != null ?Image.file(image):const Text("foto")
                  ),
                  const SizedBox(height: 15.0,),




                  const SizedBox(
                    height: 18.0,
                  ),

                  SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 40.0,
                      child: registrarse()),

                  const SizedBox(height: 20.0,),
                  Row(
                    children: <Widget>[
                      FloatingActionButton(onPressed: (){
                        loginUp();
                      },child: Icon(Icons.arrow_back),


                      ),
                      const SizedBox(width: 5.0,),
                      const Text("¿Ya tienes cuenta?")
                    ],
                  ),
                  const SizedBox(height: 5.0,)



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
            PageView(
              controller: controlador,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                 loginUI(),
                registroUI(),
              ],
            ),


          ],
        ),
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

