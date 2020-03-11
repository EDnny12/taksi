import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taksi/dialogs/reportar_problema.dart';
import 'package:taksi/providers/usuario.dart';
import 'package:taksi/screen/calificaciones.dart';
import 'package:taksi/screen/opciones_pago.dart';
import 'package:taksi/screen/preguntas_frecuentes.dart';
import 'package:taksi/widgets/tutorial.dart';

class Ayuda extends StatefulWidget {
  @override
  _AyudaState createState() => _AyudaState();
}

class _AyudaState extends State<Ayuda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 210.0,
              floating: false, //true
              pinned: true, //false
              //snap: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text('Ayuda',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    )),
                background: Image.asset(
                  'assets/img_ayuda.jpg',
                  fit: BoxFit.cover,
                ),
                /*background: Image.network(
                      "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                      fit: BoxFit.cover,
                    ),*/
              ),
            ),
          ];
        },
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              ListTile(
                title: Text("Calificaciones"),
                leading: Icon(
                  Icons.star,
                  color: Color(0xFFFFD700),
                ),
                subtitle: Text("Funcionamiento del sistema de calificaciones"),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => Calificaciones()));
                },
              ),
              SizedBox(
                height: 5,
              ),
              ListTile(
                title: Text("Opciones de pago"),
                leading: Icon(
                  Icons.payment,
                  color: Colors.blue,
                ),
                subtitle: Text("Métodos de pago existentes y su utilización"),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => Opciones_pago()));
                },
              ),
              SizedBox(
                height: 5,
              ),
              ListTile(
                title: Text("Tutorial"),
                leading: Icon(
                  Icons.slideshow,
                  color: Colors.blue,
                ),
                subtitle: Text("Tutorial para ver el proceso de solicitar un servicio"),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => Tutorial(Provider.of<Usuario>(context).nombre)));//Provider.of<Usuario>(context).nombre
                },
              ),
              SizedBox(
                height: 5,
              ),
              ListTile(
                title: Text("Reportar un problema"),
                leading: Icon(
                  Icons.report_problem,
                  color: Colors.blue,
                ),
                subtitle: Text(
                    "Inconvenientes en algún viaje o enviar comentarios para mejorar el servicio"),
                onTap: () {
                  Alerts().Dialog_reportarProblema(context);
                },
              ),
              SizedBox(
                height: 5,
              ),
              ListTile(
                title: Text("Preguntas frecuentes"),
                leading: Icon(
                  Icons.question_answer,
                  color: Colors.blue,
                ),
                subtitle: Text('Resuelve tus dudas'),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => Preguntas_frecuentes()));
                },
              ),
            ],
          ),
        ),
      ),
    );

    /*return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Estilos().estilo(context, 'Ayuda'),
        backgroundColor: Estilos().background(context),
        iconTheme: Estilos().colorIcon(context),
      ),
      body: ListView(
        children: <Widget>[
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
    );*/
  }
}
