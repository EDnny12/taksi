import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taksi/providers/usuario.dart';

class DialogSolicitar {

  final GlobalKey<ScaffoldState> scaffoldKey;
  String ciudadUsuario;
  String estado;
  DialogSolicitar(this.ciudadUsuario, this.scaffoldKey);


  dialogSolicitar(context) {
    showGeneralDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.5),
        barrierLabel: '',
        barrierDismissible: true,
        transitionDuration: Duration(milliseconds: 200),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                contentPadding: EdgeInsets.all(0),
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Image.asset(
                        "assets/logo.png",
                        height: 200,
                        //width: MediaQuery.of(context).size.width,
                        scale: 1.8,
                      ),
                      Center(
                        child: Text('Lo sentimos!', style: TextStyle(fontSize: 20)),
                      ),
                      Center(
                        child: Text(
                          'Tak-si aún no se encuentra en tu ciudad',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: RaisedButton.icon(
                          onPressed: () {
                            insertSolicitud(context);
                          },
                          label: Text('Solicitar', style: TextStyle(fontSize: 20)),
                          icon: Icon(Icons.transit_enterexit),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        pageBuilder: (context, animation1, animation2) {});
  }

  void insertSolicitud(context) async {
    await Firestore.instance.collection("solicitudes").document().setData({
      'usuario': Provider.of<Usuario>(context, listen: false).nombre,
      'ciudad': ciudadUsuario,
      'fecha': DateTime.now(),
      'estado': Provider.of<Usuario>(context, listen: false).estado,
    }).whenComplete(() {
      Navigator.of(context).pop();
      showSnackBar('Tu solicitud ha sido enviada!');
    });
  }

  void showSnackBar(String texto) {
    final snackBar = SnackBar(
      content: Text(texto),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }


}
