import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:taksi/dialogs/loader.dart';
import 'package:taksi/state/app_state.dart';


class dialogCancelacionViaje {

  CancelacionViaje(context2, String titulo, String mensaje, String tipo) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
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
                          onPressed: () {
                            Navigator.of(context).pop();
                            Loader().ShowCargando(context2, 'Cancelando su viaje!');
                            if (tipo == 'usuario') {
                              Provider.of<AppState>(context2).cancelarViaje(context2);
                            } else {
                              Provider.of<AppState>(context2).cancelViaje();
                              Provider.of<AppState>(context2).deleteRegistroViaje();
                              Provider.of<AppState>(context2).restablecerVariables(context2, 'cancelado');
                            }
                          },
                          label: Text('Aceptar',
                              style:
                              TextStyle(fontSize: 20, color: Colors.white)),
                          icon: Icon(
                            Icons.tag_faces,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: tipo == 'chofer' ? false : true,
        barrierLabel: '',
        context: context2,
        pageBuilder: (context, animation1, animation2) {});
  }
}