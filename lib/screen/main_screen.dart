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
import 'package:taksi/providers/publicidad.dart';
import 'package:taksi/providers/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:taksi/screen/ayuda.dart';
import 'package:taksi/screen/profile.dart';
import 'package:taksi/screen/viajes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taksi/state/app_state.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: WillPopScope(
        onWillPop: onWillPop,
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
              Provider.of<AppState>(context).showAppBar == false
                  ? Positioned(
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
                                    //color: Colors.grey,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white12
                                        : Colors.grey,
                                    offset: Offset(1.0, 5.0),
                                    blurRadius: 10.0,
                                    spreadRadius: 4)
                              ]),
                          child: CircleAvatar(
                            radius: 25.0,
                            backgroundImage: NetworkImage(
                                Provider.of<Usuario>(context).foto),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        onPressed: () {
                          Provider.of<AppState>(context)
                              .scaffoldKey
                              .currentState
                              .openDrawer();
                        },
                      ),
                    )
                  : const SizedBox(),
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
                  DialogError().dialogError(
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
                DialogPhoto().dialogPhoto(
                    context, Provider.of<Usuario>(context).foto, 'internet');
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
              leading: const Icon(
                Icons.local_taxi,
                color: Colors.lightBlue,
              ),
              title: const Text("Mis viajes"),
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => Viajes()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.lightBlue,
              ),
              title: const Text("Mi cuenta"),
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => UserProfilePage()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.share,
                color: Colors.lightBlue,
              ),
              title: const Text("Compartir"),
              onTap: () {
                Navigator.of(context).pop();
                Share.share(
                    'Descubre una fabulosa aplicación llamada Tak-si descargala ya!',
                    subject: 'hola');
              },
            ),
            ListTile(
                leading: const Icon(
                  Icons.help,
                  color: Colors.lightBlue,
                ),
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
              onChanged: (sa) async {
                //Provider.of<Usuario>(context).dark = true;
                Provider.of<AppState>(context).changeMapMode(
                    Theme.of(context).brightness == Brightness.dark
                        ? Brightness.light
                        : Brightness.dark);

                await DynamicTheme.of(context).setBrightness(
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
              leading: const Icon(
                Icons.exit_to_app,
                color: Colors.lightBlue,
              ),
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
              leading: Icon(
                Icons.developer_mode,
                color: Colors.lightBlue,
              ),
              title: Text("Tak-si"),
              subtitle: Text("Version 1.0.0 (Beta) © 2020 iSoft"),
              onTap: () async {
                if (await canLaunch('https://www.google.com.mx/')) {
                  await launch('https://www.google.com.mx/');
                } else {
                  Toast.show('Ocurrio un error, intentelo de nuevo', context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                }
              },
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
      print('calificacion: ' + califi);
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
    double mitad = MediaQuery.of(context).size.height / 2;
    final appState = Provider.of<AppState>(context);
    return appState.initialPosition == null
        ? Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/loader_tak-si.gif",
                ),
                Visibility(
                  visible: appState.locationServiceActive == false,
                  child: Text(
                    appState
                        .msgUsuario, //"Por favor active el gps o verifique su conexion a internet"
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                appState.msgUsuario == 'Permiso de ubicación no otorgado'
                    ? FlatButton(
                        onPressed: () {
                          appState.requestUbicationPermission(
                              onPermissionDenied: () {
                            print('periso denegado');
                          });
                        },
                        child: new Text('Otorgar permiso'),
                      )
                    : SizedBox()
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
                onLongPress: (latLng) {
                  appState.getDestinationLongPress(latLng, context);
                },
                polylines: appState.polyLines,
              ),
              Positioned(
                top: 95,
                right: 8,
                child: SizedBox.fromSize(
                  size: Size(40, 40), // button width and height
                  child: ClipOval(
                    child: Material(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white24
                          : Colors.black26, // button color
                      child: InkWell(
                        splashColor: Colors.blue, // splash color
                        onTap: () {
                          Provider.of<AppState>(context)
                              .getUserLocation(context);
                        }, // button pressed
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.my_location,
                              color: Colors.white70,
                              size: 30,
                            ), // icon
                            //Text("Call"), // text
                          ],
                        ),
                      ),
                    ),
                  ),
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
                                      offset: Offset(1.0, 5.0),
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white12
                                          : Colors.grey,
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
                  : const SizedBox(),
              Provider.of<AppState>(context).showbtnNext
                  ? Positioned(
                      bottom: 5,
                      right: 10,
                      left: 10,
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 5, left: 5, right: 5, bottom: 5),
                        height: 75,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            //color: Colors.white,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black87
                                    : Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 10,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white12
                                      : Colors.grey,
                                  //color: Colors.grey,
                                  spreadRadius: 3)
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, right: 30),
                                child: RaisedButton.icon(
                                  //splashColor: Colors.black87,
                                  color: Colors.lightBlue,
                                  label: Text(
                                      !Provider.of<AppState>(context)
                                              .showBtnPersistentDialog
                                          ? 'Continuar'
                                          : 'Confirmar',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                  icon: Icon(
                                    Icons.navigate_next,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    if (!Provider.of<AppState>(context)
                                        .showBtnPersistentDialog) {
                                      Provider.of<AppState>(context)
                                          .selectPuntoPartida(context);
                                    } else {
                                      Provider.of<AppState>(context)
                                          .btnContinuarPuntoPartida(context);
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ) /* SizedBox(
                        height: 38,
                        child: RaisedButton.icon(
                          splashColor: Colors.black87,
                          color: Colors.lightBlue,
                          label: Text('Continuar',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          icon: Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (!Provider.of<AppState>(context)
                                .showBtnPersistentDialog) {
                              Provider.of<AppState>(context)
                                  .selectPuntoPartida(context);
                            } else {
                              Provider.of<AppState>(context)
                                  .btnContinuarPuntoPartida(context);
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ), */
                      )
                  : const SizedBox(),
              Provider.of<AppState>(context).showAppBar
                  ? Positioned(
                      child: Container(
                      alignment: Alignment.center,
                      height: 75,
                      color: Colors.lightBlue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Punto de partida',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ))
                  : const SizedBox(),
              Provider.of<AppState>(context).showInfoMarker
                  ? Positioned(
                      top: mitad,
                      left: 20,
                      right: 20,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              //color: Colors.white,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black87
                                  : Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white12
                                        : Colors.grey,
                                    //color: Colors.grey,
                                    spreadRadius: 3)
                              ]),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                Provider.of<Publicidad>(context).empresa,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundImage: NetworkImage(
                                          Provider.of<Publicidad>(context)
                                              .marker),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            Provider.of<Publicidad>(context)
                                                .descripcion,
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          Text(
                                            Provider.of<Publicidad>(context)
                                                .telefono,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )))
                  : SizedBox()
            ],
          );
  }
}
