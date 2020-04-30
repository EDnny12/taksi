import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:taksi/dialogs/loader.dart';
import 'package:taksi/state/app_state.dart';


class DialogCancelacionViaje {

  cancelacionViaje(context2, String titulo, String mensaje, String tipo) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return WillPopScope(
            onWillPop: () async => tipo == 'usuario' ? true : false,
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  contentPadding: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  content: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 10,),
                          Center(
                            child: Text(titulo, style: TextStyle(fontSize: 20)),
                          ),
                          SizedBox(height: 10,),
                          Lottie.asset('assets/error.json', width: 180, height: 150),
                          Center(
                            child: Text(
                              mensaje,
                              style: TextStyle(fontSize: 17),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 15,),
                          RaisedButton.icon(
                            color: Colors.redAccent,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pop();
                              Loader().showCargando(context2, 'Cancelando su viaje!');
                              if (tipo == 'usuario') {
                                Provider.of<AppState>(context2, listen: false).cancelarViaje(context2);
                              } else {
                                Provider.of<AppState>(context2, listen: false).cancelViaje();
                                Provider.of<AppState>(context2, listen: false).deleteRegistroViaje();
                                Provider.of<AppState>(context2, listen: false).restablecerVariables(context2, 'cancelado');
                              }
                            },
                            label: Text('Aceptar',
                                style:
                                TextStyle(fontSize: 20)),
                            icon: Icon(
                              Icons.tag_faces,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: tipo == 'usuario' ? true : false,
        barrierLabel: '',
        context: context2,
        pageBuilder: (context, animation1, animation2) {});
  }
}