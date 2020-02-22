import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taksi/dialogs/dialogError.dart';
import 'package:taksi/dialogs/showPhoto.dart';
import 'package:taksi/providers/dynamic_theme.dart';
import 'package:taksi/providers/metodos.dart';
import 'package:taksi/providers/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:taksi/screen/ayuda.dart';
import 'package:taksi/screen/viajes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taksi/state/app_state.dart';
import 'package:toast/toast.dart';

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
    //inicializarUsuario(context);
    super.initState();
  }

  /*Future<void> inicializarUsuario(context) async {
    SharedPreferences prefs = await  SharedPreferences.getInstance();
    Provider.of<Usuario>(context).correo = prefs.getString('correo');
    Provider.of<Usuario>(context).nombre = prefs.getString('nombre');
    Provider.of<Usuario>(context).foto = prefs.getString('foto');
    Provider.of<Usuario>(context).inicio = prefs.getString('inicio');
  }*/

  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  DateTime currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Provider.of<AppState>(context).scaffoldKey,
      body: DoubleBackToCloseApp(
        //onWillPop: onWillPop,
        snackBar: SnackBar(
          content: Text('Tap back again to leave'),
        ),
        child: SlidingUpPanel(
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
                top: 28,
                left: 3,
                child: IconButton(
                  iconSize: 50,
                  icon: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(1.0, 5.0),
                              blurRadius: 10.0,
                              spreadRadius: 4)
                        ]),
                    child: CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(Provider.of<Usuario>(context).foto),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  onPressed: () {
                    /*Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => Tutorial()));*/
                    Provider.of<AppState>(context)
                        .scaffoldKey
                        .currentState
                        .openDrawer();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Provider.of<AppState>(context).showBtnRestablecer
          ? SizedBox()
          : FloatingActionButton(
              onPressed: () {
                if (Provider.of<AppState>(context).descuentoAplicado) {
                  print('tiene descuento');
                  dialogError().Dialog_Error(
                      context,
                      'Restablecer valores',
                      'Si restablece los valores, el codigo de descuento que ha ingresado se perdera, ¿Desea continuar?',
                      'menu');
                } else {
                  print('no tiene descuento');
                  Provider.of<AppState>(context)
                      .restablecerVariables(context, 'menu');
                }
              },
              child: Icon(Icons.threesixty),
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
              onTap: () {
                Dialog_Photo()
                    .dialogPhoto(context, Provider.of<Usuario>(context).foto);
              },
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
            /*ListTile(
              leading: const Icon(Icons.card_travel),
              title: const Text("Viajes gratis"),
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Gratis()));
              },
            ),*/
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text("Compartir"),
              onTap: () {
                Navigator.of(context).pop();
                Share.share(
                    'Descubre una fabulosa aplicación llamada Tak-si descargala ya!',
                    subject: 'hola');
              },
            ),
            ListTile(
                leading: const Icon(Icons.help),
                title: const Text("Ayuda"),
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => Ayuda()));
                }),
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
                //Provider.of<Usuario>(context).dark = true;
                DynamicTheme.of(context).setBrightness(
                    Theme.of(context).brightness == Brightness.dark
                        ? Brightness.light
                        : Brightness.dark);
                //Provider.of<AppState>(context).changeMapMode();
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

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("correo");
                prefs.remove("nombre");
                prefs.remove("foto");
                prefs.remove("telefono");
                Provider.of<Usuario>(context).nombre = null;
                Provider.of<Usuario>(context).foto = null;
                Provider.of<Usuario>(context).correo = null;
                Provider.of<Usuario>(context).inicio = null;
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
              subtitle: Text("Version 1.0.0 (Beta) © 2020 iSoft"),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      print('toast');
      Toast.show('Precione otra vez para salir', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      //Fluttertoast.showToast(msg: 'salir');
      return Future.value(false);
    }
    return Future.value(true);
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
                Image.asset(
                  "assets/loader_tak-si.gif",
                  //height: 125.0,
                  //width: 125.0,
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
                    target: appState.initialPosition, zoom: 16.0),
                onMapCreated: appState.onCreated,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                myLocationEnabled: true,
                mapType: MapType.normal, //normal
                compassEnabled: true,
                rotateGesturesEnabled: true,
                markers: appState.markers,
                onCameraMove: appState.onCameraMove,
                onLongPress: (LatLng) {
                  appState.getDestinationLongPress(LatLng, context);
                },
                polylines: appState.polyLines,
              ),
              Positioned(
                top: 95,
                right: 5,
                child: IconButton(
                  iconSize: 35,
                  icon: Icon(
                    Icons.my_location,
                    color: Colors.blueGrey,
                  ),
                  onPressed: () {
                    Provider.of<AppState>(context).getUserLocation(context);
                  },
                ),
              ),
              Provider.of<AppState>(context).showBtnPersistentDialog == false
                  ? Positioned(
                      top: 42,
                      right: 10.0, //15
                      left: 65.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 40.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
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
                                  margin: EdgeInsets.only(left: 20.0),
                                  width: 10.0,
                                  height: 10,
                                  child: Icon(
                                    Icons.local_taxi,
                                  ),
                                ),
                                hintText: "¿A dónde vamos?",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 15.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox()
            ],
          );
  }
}

/*Future<bool> onWillPop() async {
  BuildContext context;
  DateTime backbuttonpressedTime;
  DateTime currentTime = DateTime.now();
  //Statement 1 Or statement2
  bool backButton = backbuttonpressedTime == null ||
      currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);
  if (backButton) {
    backbuttonpressedTime = currentTime;
    Toast.show('Precione otra vez para salir de la app', context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    */ /*Fluttertoast.showToast(
        msg: "Double Click to exit app",
        backgroundColor: Colors.black,
        textColor: Colors.white);*/ /*
    return false;
  }
  return true;
}*/
