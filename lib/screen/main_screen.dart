import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taksi/providers/dynamic_theme.dart';
import 'package:taksi/providers/metodos.dart';
import 'package:taksi/providers/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:taksi/screen/viajes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taksi/screen/viajesGratis.dart';
import 'package:taksi/state/app_state.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String tiempo() {
    if (DateTime.now().hour >= 0 && DateTime.now().hour < 12) {
      return "¡Buenos Días!";
    } else if (DateTime.now().hour >= 12 && DateTime.now().hour < 18) {
      return "¡Buenas Tardes!";
    } else {
      return "¡Buenas Noches!";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Provider.of<AppState>(context).scaffoldKey,
      body: SlidingUpPanel(
        panel: Provider.of<AppState>(context).floatingPanel(context),
        collapsed: Provider.of<AppState>(context).floatingCollapsed(context),
        maxHeight: Provider.of<AppState>(context).sizeSliderOpen,
        minHeight: Provider.of<AppState>(context).sizeSlider,
        color: Colors.transparent,
        body: Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            Map(),
            Positioned(
              top: 20,
              left: 5,
              child: IconButton(
                iconSize: 30,
                icon: Icon(Icons.menu),
                onPressed: () {
                  Provider.of<AppState>(context)
                      .scaffoldKey
                      .currentState
                      .openDrawer();
                },
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Provider.of<AppState>(context).showBtnPersistentDialog
                      ? FlatButton(
                          child: new Text('Mi Tak-si'),
                          onPressed: () {
                            Provider.of<AppState>(context)
                                .persistentBottomSheet(context);
                          },
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, bottom: 5.0, top: 25.0),
              child: Text(
                tiempo(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ),
            ListTile(
              subtitle: Text(Provider.of<Usuario>(context).correo),
              title: Text(Provider.of<Usuario>(context).nombre),
              leading: CircleAvatar(
                radius: 25.0,
                backgroundImage:
                    NetworkImage(Provider.of<Usuario>(context).foto),
                backgroundColor: Colors.transparent,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 0.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Calificacion(),
                    const SizedBox(
                      width: 2.0,
                    ),
                    Icon(
                      Icons.star,
                      color: Color(0xFFFFD700),
                    )
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
              child: const Text(
                "Menú",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.local_taxi),
              title: const Text("Mis viajes"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Viajes()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.card_travel),
              title: const Text("Viajes gratis"),
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Gratis()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text("Compartir"),
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text("Ayuda"),
            ),
            const SizedBox(
              height: 40.0,
            ),
            const Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
              child: const Text(
                "Configuración",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            ),
            Divider(),
            SwitchListTile(
              onChanged: (sa) {
                DynamicTheme.of(context).setBrightness(
                    Theme.of(context).brightness == Brightness.dark
                        ? Brightness.light
                        : Brightness.dark);
              },
              title: const Text("Tema oscuro"),
              subtitle:
                  const Text("Experiencia de la interfaz ideal para la noche"),
              value: Theme.of(context).brightness == Brightness.dark
                  ? true
                  : false,
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Cerrar sesión"),
              onTap: () async {
                Navigator.of(context).pop();
                await FirebaseAuth.instance.signOut();
                Provider.of<Usuario>(context).nombre = null;
                Provider.of<Usuario>(context).foto = null;
                Provider.of<Usuario>(context).correo = null;
              },
            ),
            const SizedBox(
              height: 40.0,
            ),
            const Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
              child: const Text(
                "Acerca de",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.developer_mode),
              title: Text("Tak-si"),
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

  Widget lista(List<DocumentSnapshot> document, BuildContext context) {
    if (document.length == 0) {
      return const Text(
        "Aún no tienes calificación",
        style: const TextStyle(color: Colors.grey, fontSize: 11.5),
      );
    } else {
      final datos = document[0].data["calificacion"];
      String califi = (datos[0] / datos[1]).toStringAsFixed(1);
      return GestureDetector(
          onTap: () {
            showGeneralDialog(
                barrierColor: Colors.black.withOpacity(0.5),
                transitionBuilder: (context, a1, a2, widget) {
                  return Transform.scale(
                    scale: a1.value,
                    child: Opacity(
                        opacity: a1.value,
                        child: Metodos()
                            .showInfoCalificacion(datos[0] / datos[1])),
                  );
                },
                transitionDuration: Duration(milliseconds: 200),
                barrierDismissible: true,
                barrierLabel: '',
                context: context,
                pageBuilder: (context, animation1, animation2) {});
          },
          child: Text(
            califi,
            textAlign: TextAlign.right,
          ));
    }
  }
}

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return appState.initialPosition == null
        ? Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitFadingCircle(
                      color: Colors.black,
                      size: 60.0,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: appState.locationServiceActive == false,
                  child: Text(
                    "Por favor active el gps o verifique su conexion a internet",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          )
        : Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: appState.initialPosition, zoom: 17.0),
                onMapCreated: appState.onCreated,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                myLocationEnabled: true,
                mapType: MapType.normal, //normal
                compassEnabled: true,
                rotateGesturesEnabled: false,
                markers: appState.markers,
                onCameraMove: appState.onCameraMove,
                onLongPress: (LatLng) {
                  appState.getDestinationLongPress(LatLng, context);
                },
                polylines: appState.polyLines,
              ),
              Positioned(
                top: 24,
                right: 5,
                child: IconButton(
                  iconSize: 30,
                  icon: Icon(
                    Icons.my_location,
                    color: Colors.blueGrey,
                  ),
                  onPressed: () {
                    Provider.of<AppState>(context).getUserLocation(context);
                  },
                ),
              ),

              /*Positioned(
                top: 50.0,
                right: 15.0,
                left: 15.0,
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 5.0),
                            blurRadius: 10.0,
                            spreadRadius: 3.0)
                      ]),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: appState.locationController,
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(left: 20.0, top: 5.0),
                        width: 10.0,
                        height: 10,
                        child: Icon(
                          Icons.location_on,
                        ),
                      ),
                      hintText: "Origen",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                    ),
                  ),
                ),
              ),*/
              Provider.of<AppState>(context).showBtnPersistentDialog == false
                  ? Positioned(
                      top: 70.0,
                      right: 15.0,
                      left: 15.0,
                      child: Container(
                        height: 50.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(1.0, 5.0),
                                  blurRadius: 10.0,
                                  spreadRadius: 3)
                            ]),
                        child: TextField(
                          onTap: () async {
                            appState.getDestinationLocation(context);
                          },
                          cursorColor: Colors.blue.shade900,
                          controller: appState.destinationController,
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                            icon: Container(
                              margin: EdgeInsets.only(left: 20.0, top: 5.0),
                              width: 10.0,
                              height: 10,
                              child: Icon(
                                Icons.local_taxi,
                              ),
                            ),
                            hintText: "¿A donde vamos?",
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(left: 15.0, top: 16.0),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          );
  }
}
