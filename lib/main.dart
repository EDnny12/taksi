import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taksi/providers/dynamic_theme.dart';
import 'package:taksi/providers/usuario.dart';
import 'package:taksi/state/app_state.dart';
import 'package:taksi/screen/main_screen.dart';
import 'login/login.dart';

//void main() => runApp(MyApp());
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(MyApp());
  /*return runApp(MultiProvider(
    //providers: [],
    child: MyApp(),
  ));*/
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Usuario()),
        //ChangeNotifierProvider.value(value: AppState(context)),
      ],
      child: DynamicTheme(
          defaultBrightness: Brightness.light,
          data: (brightness) => ThemeData(
                brightness: brightness,
              ),
          themedWidgetBuilder: (context, theme) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              darkTheme: ThemeData(
                brightness: Brightness.dark,
              ),
              title: 'TAK-SI',
              theme: theme,
              home: Provider.of<Usuario>(context).nombre != null
                  ? MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                            create: (context) => AppState(context)),
                      ],
                      child: Menu(),
                    )
                  : Log(),
            );
          }),
    );
  }
}
