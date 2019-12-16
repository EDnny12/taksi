import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taksi/providers/dynamic_theme.dart';
import 'package:taksi/providers/usuario.dart';
import 'dart:io';

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
    if (Theme.of(context).brightness == Brightness.dark) {
      Provider.of<Usuario>(context).dark = true;
    } else {
      Provider.of<Usuario>(context).dark = false;
    }
    print("variable" + Usuario().darkMode.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Provider.of<AppState>(context).scaffoldKey,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            "Tak-si",
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
          ),
          iconTheme: IconThemeData(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black)),
      body: Map(),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Continuar'),
        onPressed: () {
          Provider.of<AppState>(context).showBottomShettLineas(context);
        },
        icon: Icon(
          Icons.check,
        ),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

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
            /*
            UserAccountsDrawerHeader(
              accountEmail: Text(Provider.of<Usuario>(context).correo),
              accountName: Text(Provider.of<Usuario>(context).nombre),
              currentAccountPicture: CircleAvatar(child: Image.network(Provider.of<Usuario>(context).foto),),

            ),

             */

            const SizedBox(
              height: 20.0,
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
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text("Calificaciones"),
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text("Compartir"),
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text("Tutorial"),
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
                changeBrightness();
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

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return SafeArea(
      child: appState.initialPosition == null
          ? Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SpinKitPouringHourglass(
                        color: Colors.black,
                        size: 50.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: appState.locationServiceActive == false,
                    child: Text(
                      "Por favor active el gps",
                      style: TextStyle(color: Colors.amber, fontSize: 18.0),
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
                ),
                Positioned(
                  top: 105.0,
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
                      onSubmitted: (value) {
                        appState.sendRequest(value);
                      },
                      decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 20.0, top: 5.0),
                          width: 10.0,
                          height: 10,
                          child: Icon(
                            Icons.local_taxi,
                          ),
                        ),
                        hintText: "Destino",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
