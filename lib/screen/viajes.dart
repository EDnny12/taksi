import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taksi/providers/estilos.dart';
import 'package:taksi/widgets/listaViajes.dart';

class Viajes extends StatefulWidget {
  @override
  _ViajesState createState() => _ViajesState();
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'Ordenar por', icon: Icons.list),
];

List<CustomPopupMenu> choic = <CustomPopupMenu>[
  CustomPopupMenu(title: 'Fecha', icon: Icons.date_range),
  CustomPopupMenu(title: 'Calificación', icon: Icons.note),
];

class _ViajesState extends State<Viajes> {
  String ordenar = "fecha";

  void _select(CustomPopupMenu choice) {
    if (choice.title == "Fecha") {
      if (ordenar != "fecha") {
        setState(() {
          ordenar = "fecha";
        });
      }
    } else {
      if (ordenar != "calificacion") {
        setState(() {
          ordenar = "calificacion";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        actions: <Widget>[
          PopupMenuButton<CustomPopupMenu>(
            icon: Icon(Icons.reorder),
            tooltip: 'Ordenar por',
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choic.map((CustomPopupMenu choice) {
                return PopupMenuItem<CustomPopupMenu>(
                  value: choice,
                  child: ListTile(
                      leading: Icon(choice.icon),
                      title: Text(
                        choice.title,
                      )),
                );
              }).toList();
            },
          )
        ],
        title: Estilos().estilo(context, "Mis viajes"),
        backgroundColor: Estilos().background(context),
        iconTheme: Estilos().colorIcon(context),
      ),
      body: MisViajes(ordenar),
    );
  }
}

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon});

  String title;
  IconData icon;
}
