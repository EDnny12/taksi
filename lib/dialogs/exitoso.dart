import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:taksi/dialogs/loader.dart';
import 'package:taksi/providers/usuario.dart';
import 'package:taksi/state/app_state.dart';

class Dialog_Exitoso {

  DialogExitoso(context2, String titulo, String mensaje) {
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
                        SizedBox(height: 5,),
                        Lottie.asset('assets/exitoso.json', width: 160, height: 160),
                        SizedBox(height: 5,),
                        Center(
                          child: Text(
                            mensaje,
                            style: TextStyle(fontSize: 17),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 15,),
                        RaisedButton.icon(
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.of(context).pop();
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
        barrierDismissible: true,
        barrierLabel: '',
        context: context2,
        pageBuilder: (context, animation1, animation2) {});
  }
}
