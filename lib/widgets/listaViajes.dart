import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:taksi/dialogs/showPhoto.dart';
import 'package:taksi/providers/usuario.dart';

class MisViajes extends StatelessWidget {
  String ordenar;

  MisViajes(this.ordenar);

  @override
  Widget build(BuildContext context) {
    print(Provider.of<Usuario>(context, listen: true).correo);
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("viajes")
          .orderBy(ordenar, descending: true)
          .where("usuario", isEqualTo: Provider.of<Usuario>(context, listen: true).correo)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return new Center(child: new CircularProgressIndicator());
        if(snapshot.hasError) {
          return Text('Error al cargar sus viajes');
        } else if(snapshot.hasData) { //snapshot.hasdata
          return lista(snapshot.data.documents, context);
        } else {
          return const Text('Error al cargar sus viajes');
        }

        //if (snapshot.hasError) return const Text('ERROR AL CARGAR SUS VIAJES');
        /*switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: const CircularProgressIndicator(),
            );

          default:

        }*/
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
              final tipoPago = document[index].data["tipoPago"];
              final numeroTaxi = document[index].data["numerotaxi"];
              final costo = document[index].data["costo"];
              print(tipoPago);

              return Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Card(
                      elevation: 1.6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: InkWell(
                              child: CircleAvatar(
                                radius: 25.0,
                                backgroundImage: NetworkImage(foto),
                                backgroundColor: Colors.transparent,
                              ),
                              onTap: () {
                                DialogPhoto()
                                    .dialogPhoto(context, foto, 'internet');
                              },
                            ),
                            title: Text("Chofer: " + chofer),
                            subtitle: Text(sitio + '.  N°: ' + numeroTaxi),
                          ),
                          Divider(
                            indent: 10,
                            endIndent: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: ListTile(
                                      title: Text(inicio.split('-')[0]),
                                      subtitle: Text(inicio.split('-')[1]),
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.subdirectory_arrow_right,
                                size: 26,
                              ),
                              Column(
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: ListTile(
                                      title: Text(destino.split('-')[0]),
                                      subtitle: Text(destino.split('-')[1]),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            indent: 10,
                            endIndent: 10,
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
                                          ? Icon(Icons.star,
                                              color: Color(0xFFFFD700))
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
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        height: 30,
                        width: 120,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 3,
                                  color: Colors.grey,
                                  spreadRadius: 1)
                            ]),
                        child: Center(
                            child: Text(
                          tipoPago + ' \$' + costo.toString() + '.00',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        )),
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, int d) {
              return const SizedBox(
                height: 15.0,
              );
            },
            itemCount: document.length)
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/taxiApp.png",
                  scale: 2,
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Center(
                      child: TypewriterAnimatedTextKit(
                    speed: Duration(milliseconds: 70),
                    totalRepeatCount: 100,
                    text: [
                      'Aún no has realizado algún viaje',
                      ' ¿Qué estás esperando?'
                    ],
                    textStyle: TextStyle(fontSize: 20.0, fontFamily: "Agne"),
                  )),
                ),
                const SizedBox(
                  height: 18.0,
                ),
                const SizedBox(
                  height: 30.0,
                ),
                SizedBox(
                  height: 40.0,
                  child: RaisedButton(
                    color: Colors.lightBlue,
                    child: const Text(
                      "Planea tu primer viaje",
                      style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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

/*
Dismissible(
                //key: Key(), aqui se pone lo que se eliminara items[index]
                key: Key(document[0].toString()),
                background: Container(
                  color: Colors.black12,
                  alignment: AlignmentDirectional.centerStart,
                  child: Icon(Icons.delete_forever, color: Colors.redAccent,size: 50,),
                ),
                onDismissed: (direction) {
                  print('se elimino');
                },
                direction: DismissDirection.startToEnd,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Card(
                        elevation: 1.6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: InkWell(
                                child: CircleAvatar(
                                  radius: 25.0,
                                  backgroundImage: NetworkImage(foto),
                                  backgroundColor: Colors.transparent,
                                ),
                                onTap: () {
                                  Dialog_Photo().dialogPhoto(context, foto);
                                },
                              ),
                              title: Text("Chofer: " + chofer),
                              subtitle: Text(sitio + '.  N°: ' + numeroTaxi),
                            ),
                            Divider(indent: 10,endIndent: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.35,
                                      child: ListTile(
                                        title: Text(inicio.split('-')[0]),
                                        subtitle: Text(inicio.split('-')[1]),
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(Icons.subdirectory_arrow_right, size: 26,),
                                Column(
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.35,
                                      child: ListTile(
                                        title: Text(destino.split('-')[0]),
                                        subtitle: Text(destino.split('-')[1]),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(indent: 10, endIndent: 10,),
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
                                            ? Icon(Icons.star,
                                                color: Color(0xFFFFD700))
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
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          height: 30,
                          width: 120,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 3,
                                    color: Colors.grey,
                                    spreadRadius: 1)
                              ]),
                          child: Center(child: Text(tipoPago + ' \$' + costo.toString() + '.00',
                            style: TextStyle(color: Colors.white, fontSize: 14),)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
* */
