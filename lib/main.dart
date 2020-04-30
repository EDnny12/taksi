import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taksi/providers/configuration.dart';
import 'package:taksi/providers/dynamic_theme.dart';
import 'package:taksi/providers/publicidad.dart';
import 'package:taksi/providers/usuario.dart';
import 'package:taksi/requests/push_notification.dart';
import 'package:taksi/state/app_state.dart';
import 'package:taksi/screen/main_screen.dart';
import 'login/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  PushNotification().initialize();
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences prefs;

  String valor;

  actualizar () {
    setState(() {
      verificarSesion();
    });
  }

  Future<String> verificarSesion() async {
    prefs = await SharedPreferences.getInstance();
    String prueba = prefs.getString('nombre').toString();
    return prueba;
  }

  @override
  Widget build(BuildContext context) {
    verificarSesion().then((value) {
      valor = value;
    });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Usuario()),
        ChangeNotifierProvider(create: (context) => Publicidad()),
        ChangeNotifierProvider(create: (context) => Configuration()),
      ],
      child: DynamicTheme(
          defaultBrightness: Brightness.light,
          data: (brightness) => ThemeData(
                brightness: brightness,
                bottomSheetTheme: BottomSheetThemeData(
                    backgroundColor: Colors.black.withOpacity(0)),
              ),
          themedWidgetBuilder: (context, theme) {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                ),
                title: 'TAK-SI',
                theme: theme,
                home: FutureBuilder(
                    future: verificarSesion(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        if (prefs.getString('nombre') != null) {
                          //valor != 'null'
                          inicializarUsuario(context);
                        }

                        return Provider.of<Usuario>(context, listen: true)
                                    .nombre
                                    .toString() !=
                                'null' //prefs.getString('nombre')
                            ? MultiProvider(
                                providers: [
                                  ChangeNotifierProvider(
                                      create: (context) =>
                                          AppState(context, theme.brightness)),
                                ],
                                child: Menu(this),
                              )
                            : Log();
                      }
                      return CircularProgressIndicator();
                    }));
          }),
    );
  }

  void inicializarUsuario(context) {
    Provider.of<Usuario>(context, listen: true).correo =
        prefs.getString('correo');
    Provider.of<Usuario>(context, listen: true).nombre =
        prefs.getString('nombre');
    Provider.of<Usuario>(context, listen: true).foto = prefs.getString('foto');
    Provider.of<Usuario>(context, listen: true).telefono =
        prefs.getString('telefono');
    Provider.of<Usuario>(context, listen: true).inicio =
        prefs.getString('inicio');
  }
}
