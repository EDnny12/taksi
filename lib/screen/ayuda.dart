import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taksi/dialogs/reportar_problema.dart';
import 'package:taksi/providers/estilos.dart';
import 'package:taksi/screen/calificaciones.dart';
import 'package:taksi/screen/opciones_pago.dart';
import 'package:taksi/screen/preguntas_frecuentes.dart';
import 'package:taksi/screen/profile.dart';

class Ayuda extends StatefulWidget {
  @override
  _AyudaState createState() => _AyudaState();
}

class _AyudaState extends State<Ayuda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Estilos().estilo(context, 'Ayuda'),
        backgroundColor: Estilos().background(context),
        iconTheme: Estilos().colorIcon(context),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          ListTile(
            title: Text("Cuenta"),
            leading: Icon(Icons.account_circle),
            subtitle: Text("Conoce como configurar las opciones de tu cuenta"),
            onTap: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (context) => UserProfilePage(context)));
            },
          ),
          SizedBox(
            height: 5,
          ),
          ListTile(
            title: Text("Calificaciones"),
            leading: Icon(Icons.star),
            subtitle: Text("Funcionamiento del sistema de calificaciones"),
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => Calificaciones()));
            },
          ),
          SizedBox(
            height: 5,
          ),
          ListTile(
            title: Text("Opciones de pago"),
            leading: Icon(Icons.payment),
            subtitle: Text("Métodos de pago existentes y su utilización"),
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => Opciones_pago()));
            },
          ),
          SizedBox(
            height: 5,
          ),
          ListTile(
            title: Text("Reportar un problema"),
            leading: Icon(Icons.report_problem),
            subtitle: Text("Inconvenientes en algún viaje o enviar comentarios para mejorar el servicio"),
            onTap: () {
              Alerts().Dialog_reportarProblema(context);
            },
          ),
          SizedBox(
            height: 5,
          ),
          ListTile(
            title: Text("Preguntas frecuentes"),
            leading: Icon(Icons.question_answer),
            subtitle: Text('Resuelve tus dudas'),
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => Preguntas_frecuentes()));
            },
          ),
        ],
      ),
    );
  }
}
