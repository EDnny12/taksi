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
        title: Text("Tak-si",style: TextStyle(color: Theme.of(context).brightness==Brightness.dark? Colors.white:Colors.black),),
        iconTheme: IconThemeData(color: Theme.of(context).brightness==Brightness.dark? Colors.white:Colors.black)),

      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const Padding(
              padding: const EdgeInsets.only(left:15.0,bottom: 5.0,top: 25.0),
              child: const Text("BIENVENIDO",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),textAlign: TextAlign.center,),),


             ListTile(subtitle:Text(Provider.of<Usuario>(context).correo),title: Text(Provider.of<Usuario>(context).nombre),
             leading:CircleAvatar(
               radius: 25.0,
               backgroundImage:
               NetworkImage(Provider.of<Usuario>(context).foto),
               backgroundColor: Colors.transparent,
             ),
             ),
            /*
            UserAccountsDrawerHeader(
              accountEmail: Text(Provider.of<Usuario>(context).correo),
              accountName: Text(Provider.of<Usuario>(context).nombre),
              currentAccountPicture: CircleAvatar(child: Image.network(Provider.of<Usuario>(context).foto),),

            ),

             */
            
            const SizedBox(height: 20.0,),
            const Padding(
                padding: const EdgeInsets.only(left:15.0,bottom: 5.0),
                child: const Text("Menú",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),),
            Divider(),
            ListTile(leading:const Icon(Icons.local_taxi) ,title: const Text("Mis viajes"),
            onTap: (){},
            ),
            ListTile(leading: const Icon(Icons.star),title: const Text("Calificaciones"),),
            ListTile(leading: const Icon(Icons.share),title: const Text("Compartir"),),
            ListTile(leading: const Icon(Icons.help),title: const Text("Tutorial"),),
            ListTile(leading: const Icon(Icons.comment),title: const Text("Acerca de"),),

            const SizedBox(height: 45.0,),
           const  Padding(
              padding: const EdgeInsets.only(left:15.0,bottom: 5.0),
              child: const Text("Configuración",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),),
            Divider(),
            SwitchListTile(title: const Text("Tema oscuro"),subtitle: const Text("Experiencia de la interfaz ideal para la noche"),
            value: Theme.of(context).brightness==Brightness.dark?true:false,
            ),
            ListTile(leading: const Icon(Icons.exit_to_app),title: const Text("Cerrar sesión"),),
          ],
        ),
      ),
    );
  }
}
