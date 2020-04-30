import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taksi/dialogs/dialogError.dart';
import 'package:taksi/dialogs/showPhoto.dart';
import 'package:taksi/providers/configuration.dart';
import 'package:taksi/providers/dynamic_theme.dart';
import 'package:taksi/providers/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:taksi/screen/ayuda.dart';
import 'package:taksi/screen/calificacionUser.dart';
import 'package:taksi/screen/profile.dart';
import 'package:taksi/screen/ubicaciones.dart';
import 'package:taksi/screen/viajes.dart';
import 'package:taksi/state/app_state.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:taksi/screen/mapa.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Menu extends StatefulWidget {
  final _MyAppState;
  Menu(this._MyAppState);

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

  Map map = new Map();
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

  DateTime currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Provider.of<AppState>(context, listen: true).scaffoldKey,
      body: WillPopScope(
        onWillPop: onWillPop,
        child: SlidingUpPanel(
          panel: Provider.of<AppState>(context, listen: true)
              .floatingPanel(context),
          collapsed: Provider.of<AppState>(context, listen: true)
              .floatingCollapsed(context),
          maxHeight:
              Provider.of<AppState>(context, listen: true).sizeSliderOpen,
          minHeight: Provider.of<AppState>(context, listen: true).sizeSlider,
          color: Colors.transparent,
          body: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              Map(),
              Provider.of<AppState>(context, listen: true).showAppBar == false
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
                                Provider.of<Usuario>(context, listen: true)
                                    .foto),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        onPressed: () {
                          Provider.of<AppState>(context, listen: false)
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
      floatingActionButton:
          Provider.of<AppState>(context, listen: true).showBtnRestablecer
              ? SizedBox()
              : FloatingActionButton(
                  onPressed: () {
                    if (Provider.of<AppState>(context, listen: false)
                        .descuentoAplicado) {
                      print('tiene descuento');
                      DialogError().dialogError(
                          context,
                          'Restablecer valores',
                          'Si restablece los valores, el codigo de descuento que ha ingresado se perdera, ¿Desea continuar?',
                          'menu');
                    } else {
                      print('no tiene descuento');
                      Provider.of<AppState>(context, listen: false)
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
              subtitle:
                  Text(Provider.of<Usuario>(context, listen: true).correo),
              title: Text(Provider.of<Usuario>(context, listen: true).nombre),
              leading: CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                    Provider.of<Usuario>(context, listen: true).foto),
                backgroundColor: Colors.transparent,
              ),
              onTap: () {
                DialogPhoto().dialogPhoto(
                    context,
                    Provider.of<Usuario>(context, listen: false).foto,
                    'internet');
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
                Icons.add_location,
                color: Colors.lightBlue,
              ),
              title: const Text("Mis ubicaciones"),
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => UbicacionesPage(
                            Provider.of<Usuario>(context, listen: true).map)));
              },
            ),
            ListTile(
              leading: const Icon(
                FontAwesomeIcons.slideshare,
                color: Colors.lightBlue,
              ),
              title: const Text("Compartir"),
              onTap: () {
                Navigator.of(context).pop();
                Share.share(
                    'Descubre una fabulosa aplicación llamada Tak-si descárgala ya! ' +
                        Provider.of<Configuration>(context, listen: false)
                            .link_playstore,
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
                Provider.of<AppState>(context, listen: false).changeMapMode(
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
                print('clic cerrar sesion');
                Navigator.of(context).pop();
                await FirebaseAuth.instance.signOut().then((value) async {
                  print('en el then');
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove("correo");
                  prefs.remove("nombre");
                  prefs.remove("foto");
                  prefs.remove("telefono");
                  Provider.of<Usuario>(context, listen: false).nombre = null;
                  Provider.of<Usuario>(context, listen: false).foto = null;
                  Provider.of<Usuario>(context, listen: false).correo = null;
                  Provider.of<Usuario>(context, listen: false).inicio = null;
                  setState(() {
                    widget._MyAppState.actualizar();
                  });
                });
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
                FontAwesomeIcons.facebook,
                color: Colors.lightBlue,
              ),
              title: Text("Tak-si oficial"),
              subtitle: Text("Siguenos en Facebook"),
              onTap: () async {
                if (await canLaunch(
                    Provider.of<Configuration>(context, listen: false)
                        .link_facebook)) {
                  await launch(
                      Provider.of<Configuration>(context, listen: false)
                          .link_facebook);
                } else {
                  Toast.show('Ocurrio un error, intentelo de nuevo', context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                }
              },
            ),
            ListTile(
              leading: Icon(
                Icons.developer_mode,
                color: Colors.lightBlue,
              ),
              title: Text("Tak-si"),
              subtitle: Text("Version 1.0.10 © 2020 iSoft"),
              onTap: () async {
                if (await canLaunch(
                    Provider.of<Configuration>(context, listen: false)
                        .link_pagina)) {
                  await launch(
                      Provider.of<Configuration>(context, listen: false)
                          .link_pagina);
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
      Toast.show('Presione otra vez para salir', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return Future.value(false);
    }
    return Future.value(true);
  }
}
