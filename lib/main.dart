import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taksi/providers/dynamic_theme.dart';
import 'package:taksi/providers/usuario.dart';
import 'package:taksi/state/app_state.dart';
import 'package:taksi/screen/main_screen.dart';
import 'login/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {

  SharedPreferences prefs;
  String valor;

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
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

                      if (snapshot.hasData) {
                        if (prefs.getString('nombre') != null) { //valor != 'null'
                          inicializarUsuario(context);
                          /*Provider.of<Usuario>(context).correo = prefs.getString('correo');
                          Provider.of<Usuario>(context).nombre = prefs.getString('nombre');
                          Provider.of<Usuario>(context).foto = prefs.getString('foto');
                          Provider.of<Usuario>(context).telefono = prefs.getString('telefono');
                          Provider.of<Usuario>(context).inicio = prefs.getString('inicio');*/
                        }

                        return prefs.getString('nombre') != null
                            ? MultiProvider(
                                providers: [
                                  ChangeNotifierProvider(create: (context) => AppState(context)),
                                ],
                                child: Menu(),
                              )
                            : Log();
                      }
                      return CircularProgressIndicator();
                    })

                /*valor != '' ? MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                      create: (context) => AppState(context)),
                ],
                child: Menu(),

              ) : Log(),*/
                );
          }),
    );
  }

  void inicializarUsuario(context) {
    Provider.of<Usuario>(context).correo = prefs.getString('correo');
    Provider.of<Usuario>(context).nombre = prefs.getString('nombre');
    Provider.of<Usuario>(context).foto = prefs.getString('foto');
    Provider.of<Usuario>(context).telefono = prefs.getString('telefono');
    Provider.of<Usuario>(context).inicio = prefs.getString('inicio');
  }
}
