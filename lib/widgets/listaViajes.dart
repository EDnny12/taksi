import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:taksi/providers/usuario.dart';

class MisViajes extends StatelessWidget {
  String ordenar;
  MisViajes(this.ordenar);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("viajes")
          .orderBy(ordenar, descending: true)
          .where("email", isEqualTo: Provider.of<Usuario>(context).correo)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return const Text('ERROR AL CARGAR LOS AVISOS');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: const CircularProgressIndicator(),
            );

          default:
            return lista(snapshot.data.documents, context);
        }
      },
    );
  }

  Widget lista(List<DocumentSnapshot> document, BuildContext context) {
    return document.length != 0
        ? ListView.separated(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            itemBuilder: (context, int index) {
              final chofer = document[index].data["chofer"];
              final destino = document[index].data["destino"];
              final inicio = document[index].data["inicio"];
              final fecha = document[index].data["fecha"];
              final calificacion = document[index].data["calificacion"];
              final sitio = document[index].data["sitio"];
              final foto = document[index].data["foto"];
              return Card(
                elevation: 1.6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(foto),
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text("Chofer: " + chofer),
                      subtitle: Text(sitio),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[Text("Partida")],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            child: Text(inicio),
                            shape: StadiumBorder(),
                            onPressed: () {},
                            animationDuration: Duration(seconds: 0),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[Text("Destino")],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            child: Text(destino),
                            shape: StadiumBorder(),
                            onPressed: () {},
                            animationDuration: Duration(seconds: 0),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent, //
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Text(
                            DateTime.fromMillisecondsSinceEpoch(
                                        fecha.millisecondsSinceEpoch)
                                    .day
                                    .toString() +
                                "/" +
                                DateTime.fromMillisecondsSinceEpoch(
                                        fecha.millisecondsSinceEpoch)
                                    .month
                                    .toString() +
                                "/" +
                                DateTime.fromMillisecondsSinceEpoch(
                                        fecha.millisecondsSinceEpoch)
                                    .year
                                    .toString() +
                                " " +
                                DateTime.fromMillisecondsSinceEpoch(
                                        fecha.millisecondsSinceEpoch)
                                    .hour
                                    .toString() +
                                ":" +
                                DateTime.fromMillisecondsSinceEpoch(
                                        fecha.millisecondsSinceEpoch)
                                    .minute
                                    .toString(),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          width: 140,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, d) {
                                return d <= (calificacion - 1)
                                    ? Icon(Icons.star, color: Color(0xFFFFD700))
                                    : Icon(Icons.star_border);
                              },
                              separatorBuilder: (context, s) {
                                return SizedBox(
                                  width: 3.0,
                                );
                              },
                              itemCount: 5),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context, int d) {
              return const SizedBox(height: 15.0,);
            },
            itemCount: document.length)
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/taxo.png",
                  scale: 5,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white38
                      : Colors.black,
                ),
                const SizedBox(height: 40.0,),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                      child: Text(
                    "Aún no has realizado algún viaje",
                    style: const TextStyle(fontSize: 25.0),
                    textAlign: TextAlign.center,
                  )),
                ),
                const SizedBox(height: 18.0,),
                Text(
                  "¿Qué estás esperando?",
                  style: const TextStyle(fontSize: 25.0),
                ),
                const SizedBox(height: 30.0,),
                SizedBox(
                  height: 50.0,
                  child: RaisedButton(
                    child: const Text(
                      "Planea tu primer viaje",
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    shape: StadiumBorder(),
                  ),
                ),
              ],
            ),
          );
  }
}
