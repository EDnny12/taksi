import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taksi/providers/dynamic_theme.dart';
import 'package:taksi/providers/estilos.dart';
import 'package:taksi/providers/metodos.dart';
import 'package:taksi/providers/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taksi/screen/viajes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taksi/screen/viajesGratis.dart';
class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {




   String tiempo(){

     if(  DateTime.now().hour >= 0 &&DateTime.now().hour<12 ){
      return "¡Buenos Días!";
     }else if(DateTime.now().hour >= 12 &&DateTime.now().hour<18){
       return "¡Buenas Tardes!";
     }else{
       return "¡Buenas Noches!";
     }
   }

  @override
  void initState() {

    super.initState();
  }
  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark? Brightness.light: Brightness.dark);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

          elevation: 0.0,
        title: Estilos().estilo(context, "Tak-si"),
        backgroundColor: Estilos().background(context),
        iconTheme: Estilos().colorIcon(context),
),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
             Padding(
              padding: const EdgeInsets.only(left:15.0,bottom: 5.0,top: 25.0),
              child:  Text(tiempo(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),textAlign: TextAlign.center,),),


             ListTile(subtitle:Text(Provider.of<Usuario>(context).correo),title: Text(Provider.of<Usuario>(context).nombre),
             leading:CircleAvatar(
               radius: 25.0,
               backgroundImage:
               NetworkImage(Provider.of<Usuario>(context).foto),
               backgroundColor: Colors.transparent,
             ),
             ),

      Padding(
        padding: const EdgeInsets.only(top:0.0,right: 10.0),
        child:Row(

          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
           Calificacion(),
            const SizedBox(width: 2.0,),
           Icon(Icons.star,color: Color(0xFFFFD700),)
          ],
        )
      ),
            const SizedBox(height: 20,),
            const Padding(
                padding: const EdgeInsets.only(left:15.0,bottom: 5.0),
                child: const Text("Menú",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),),
            Divider(),
            ListTile(leading:const Icon(Icons.local_taxi) ,title: const Text("Mis viajes"),
            onTap: () {
              Navigator.of(context).pop();
             Navigator.push(context, CupertinoPageRoute(builder: (context)=>Viajes()));

            },
            ),
            ListTile(leading: const Icon(Icons.card_travel),title: const Text("Viajes gratis"),onTap: (){

              Navigator.push(context, CupertinoPageRoute(builder: (context)=>Gratis()));
            },),
            ListTile(leading: const Icon(Icons.share),title: const Text("Compartir"),),
            ListTile(leading: const Icon(Icons.help),title: const Text("Ayuda"),),


            const SizedBox(height: 40.0,),
           const  Padding(
              padding: const EdgeInsets.only(left:15.0,bottom: 5.0),
              child: const Text("Configuración",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),),
            Divider(),
            SwitchListTile(
              onChanged: (sa){

                  DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark? Brightness.light: Brightness.dark);

              },
              title: const Text("Tema oscuro"),subtitle: const Text("Experiencia de la interfaz ideal para la noche"),
            value: Theme.of(context).brightness==Brightness.dark?true:false,

            ),
            ListTile(leading: const Icon(Icons.exit_to_app),title: const Text("Cerrar sesión"),onTap: ()async{
              Navigator.of(context).pop();
              await FirebaseAuth.instance.signOut();
              Provider.of<Usuario>(context).nombre=null;
              Provider.of<Usuario>(context).foto= null;
              Provider.of<Usuario>(context).correo=null;

            },),
            const SizedBox(height: 40.0,),
            const  Padding(
              padding: const EdgeInsets.only(left:15.0,bottom: 5.0),
              child: const Text("Acerca de",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),),
            Divider(),
            ListTile(leading:Icon(Icons.developer_mode),title: Text("Tak-si"),
            subtitle: Text("Version 1.0.0 (Beta) © 2019 iSoft"),
            ),
          ],
        ),
      ),
    );
  }
}

class Calificacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("calificaciones_usuarios")
          .where("email", isEqualTo: Provider.of<Usuario>(context).correo)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return const Text('ERROR AL CARGAR LOS AVISOS');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Text("");

          default:
            return lista(snapshot.data.documents, context);
        }
      },
    );
  }
   Widget lista(List<DocumentSnapshot> document, BuildContext context){
    if(document.length==0){
     return const Text("Aún no tienes calificación",style: const TextStyle(color: Colors.grey,fontSize: 11.5),);

    }else{
     final datos= document[0].data["calificacion"];
    return  

      
         GestureDetector(
             onTap: (){
               showGeneralDialog(
                   barrierColor: Colors.black.withOpacity(0.5),
                   transitionBuilder: (context, a1, a2, widget) {
                     return Transform.scale(
                       scale: a1.value,
                       child: Opacity(
                         opacity: a1.value,
                         child: Metodos().showInfoCalificacion(datos[0]/datos[1])
                       ),
                     );
                   },
                   transitionDuration: Duration(milliseconds: 200),
                   barrierDismissible: true,
                   barrierLabel: '',
                   context: context,
                   pageBuilder: (context, animation1, animation2) {});

             },
             child: Text((datos[0]/datos[1]).toStringAsFixed(1),textAlign: TextAlign.right,));
    }
  }
}
