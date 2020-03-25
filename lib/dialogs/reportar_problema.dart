import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taksi/dialogs/exitoso.dart';
import 'package:taksi/dialogs/loader.dart';
import 'package:taksi/providers/usuario.dart';
import 'package:toast/toast.dart';

class Alerts {
  TextEditingController reportessage = TextEditingController();

  dialogReportarProblema(context2) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
                opacity: a1.value,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    height: 300.0,
                    width: 300.0,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 140,
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[500],
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Reportar un problema',
                                style: TextStyle(fontSize: 22, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                            controller: reportessage,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Ingrese el mensaje',
                              suffixIcon:
                                  Icon(Icons.sentiment_very_dissatisfied),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              onPressed: () {
                                if (reportessage.text.isEmpty) {
                                  Toast.show('Ingrese el mensaje', context,
                                      duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                                } else {
                                  Navigator.of(context2).pop();
                                  Loader().showCargando(
                                      context2, 'Enviando su reporte');
                                  print(reportessage.text);
                                  print(Provider.of<Usuario>(context).nombre);
                                  print(Provider.of<Usuario>(context).correo);
                                  print(DateTime.now());
                                  print(Provider.of<Usuario>(context).ciudad);
                                  print(Provider.of<Usuario>(context).estado);
                                  insertReporte(
                                      context2,
                                      reportessage.text,
                                      Provider.of<Usuario>(context).nombre,
                                      Provider.of<Usuario>(context).correo,
                                      Provider.of<Usuario>(context).ciudad,
                                      Provider.of<Usuario>(context).estado);
                                }
                              },
                              child: Text(
                                'Enviar',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context2,
        pageBuilder: (context, animation1, animation2) {});
  }

  void insertReporte(context, String mensaje, String nombre, String correo,
      String ciudad, String estado) async {
    await Firestore.instance
        .collection('reportes_usuarios')
        .document()
        .setData({
      'reporte': mensaje,
      'nombre': nombre,
      'correo': correo,
      'ciudad': ciudad,
      'estado': estado,
      'fecha': DateTime.now(),
    }).whenComplete(() {
      Navigator.of(context).pop();
      DialogExitoso().dialogExitoso(context, 'Reporte enviado',
          'Gracias por enviarnos su reporte! sera tomado en cuenta para mejorar el servicio');
    });
  }
}
